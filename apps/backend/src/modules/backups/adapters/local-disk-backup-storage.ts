import { Injectable } from '@nestjs/common';
import { copyFile, mkdir } from 'node:fs/promises';
import { dirname, join } from 'node:path';
import type { BackupStorageAdapter, UploadResult } from '../backup-storage.interface.js';

/** Dev/no-Drive-credentials default: copies the encrypted dump into a local folder. */
@Injectable()
export class LocalDiskBackupStorage implements BackupStorageAdapter {
  constructor(private readonly basePath: string) {}

  async upload(localFilePath: string, fileName: string): Promise<UploadResult> {
    const destination = join(this.basePath, fileName);
    await mkdir(dirname(destination), { recursive: true });
    await copyFile(localFilePath, destination);
    return { externalFileId: null };
  }
}
