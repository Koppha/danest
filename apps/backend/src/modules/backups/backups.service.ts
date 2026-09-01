import { Inject, Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { execFile } from 'node:child_process';
import { promisify } from 'node:util';
import { mkdir, readdir, rm, stat } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { PrismaService } from '../../database/prisma.service.js';
import { BACKUP_STORAGE_ADAPTER, type BackupStorageAdapter } from './backup-storage.interface.js';
import { encryptFile, sha256File } from './backup-crypto.js';

const execFileAsync = promisify(execFile);

@Injectable()
export class BackupsService {
  private readonly logger = new Logger('BackupsService');

  constructor(
    private readonly prisma: PrismaService,
    private readonly config: ConfigService,
    @Inject(BACKUP_STORAGE_ADAPTER) private readonly storage: BackupStorageAdapter,
  ) {}

  list() {
    return this.prisma.backupRun.findMany({ orderBy: { startedAt: 'desc' }, take: 50 });
  }

  /**
   * Dumps Postgres to a consistent snapshot (pg_dump handles that — it
   * never reads a live/mid-write file), encrypts it, uploads via the
   * configured storage adapter, and records the outcome. Never uploads an
   * unencrypted or in-progress file.
   */
  async runBackup(): Promise<void> {
    const run = await this.prisma.backupRun.create({ data: { status: 'RUNNING' } });
    const dumpPath = join(tmpdir(), `de-nest-${run.id}.dump`);
    const encryptedPath = `${dumpPath}.enc`;

    try {
      const databaseUrl = this.config.get<string>('databaseUrl')!;
      await execFileAsync('pg_dump', [databaseUrl, '--format=custom', '--file', dumpPath]);

      await encryptFile(dumpPath, encryptedPath, this.config.get<string>('backup.encryptionKey')!);

      const fileName = `de-nest-${new Date().toISOString().slice(0, 10)}-${run.id}.dump.enc`;
      const { externalFileId } = await this.storage.upload(encryptedPath, fileName);

      const [checksum, size] = await Promise.all([sha256File(encryptedPath), stat(encryptedPath).then((s) => s.size)]);
      const retentionDays = this.config.get<number>('backup.retentionDays')!;

      await this.prisma.backupRun.update({
        where: { id: run.id },
        data: {
          status: 'SUCCESS',
          finishedAt: new Date(),
          fileName,
          fileSizeBytes: BigInt(size),
          sha256Checksum: checksum,
          driveFileId: externalFileId,
          retentionExpiresAt: new Date(Date.now() + retentionDays * 86_400_000),
        },
      });
      this.logger.log(`Backup ${run.id} completed: ${fileName}`);
    } catch (err) {
      this.logger.error(`Backup ${run.id} failed: ${(err as Error).message}`);
      await this.prisma.backupRun.update({
        where: { id: run.id },
        data: { status: 'FAILED', finishedAt: new Date(), errorMessage: (err as Error).message },
      });
    } finally {
      await Promise.allSettled([rm(dumpPath, { force: true }), rm(encryptedPath, { force: true })]);
    }
  }

  /** Deletes local backup files past their retention window (bookkeeping only for non-local adapters). */
  async pruneExpired(): Promise<number> {
    const localPath = this.config.get<string>('backup.localPath')!;
    const expired = await this.prisma.backupRun.findMany({
      where: { status: 'SUCCESS', retentionExpiresAt: { lt: new Date() } },
    });
    let pruned = 0;
    for (const run of expired) {
      if (!run.fileName) continue;
      try {
        await rm(join(localPath, run.fileName), { force: true });
        pruned++;
      } catch {
        // Already gone or on non-local storage — not an error worth failing the sweep over.
      }
    }
    return pruned;
  }

}

/** Ensures the local backup directory exists at startup (used by the local storage adapter). */
export async function ensureLocalBackupDir(path: string): Promise<void> {
  await mkdir(path, { recursive: true }).catch(() => undefined);
  await readdir(path).catch(() => undefined);
}
