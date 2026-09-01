import { describe, it, expect, afterEach } from 'vitest';
import { mkdtemp, readFile, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { encryptFile, decryptFile, sha256File } from './backup-crypto.js';

describe('backup-crypto', () => {
  let dir: string;

  afterEach(async () => {
    if (dir) await rm(dir, { recursive: true, force: true });
  });

  it('round-trips: encrypting then decrypting recovers the original bytes', async () => {
    dir = await mkdtemp(join(tmpdir(), 'de-nest-backup-test-'));
    const original = Buffer.from('this is a fake pg_dump payload with some bytes \x00\x01\x02', 'utf-8');
    const inputPath = join(dir, 'input.dump');
    const encryptedPath = join(dir, 'input.dump.enc');
    const decryptedPath = join(dir, 'output.dump');
    await writeFile(inputPath, original);

    await encryptFile(inputPath, encryptedPath, 'a-strong-backup-key');
    const encryptedBytes = await readFile(encryptedPath);
    expect(encryptedBytes.equals(original)).toBe(false); // actually encrypted, not a passthrough copy

    await decryptFile(encryptedPath, decryptedPath, 'a-strong-backup-key');
    const decryptedBytes = await readFile(decryptedPath);
    expect(decryptedBytes.equals(original)).toBe(true);
  });

  it('fails to decrypt (or produces garbage) with the wrong key', async () => {
    dir = await mkdtemp(join(tmpdir(), 'de-nest-backup-test-'));
    const original = Buffer.from('sensitive backup content', 'utf-8');
    const inputPath = join(dir, 'input.dump');
    const encryptedPath = join(dir, 'input.dump.enc');
    await writeFile(inputPath, original);
    await encryptFile(inputPath, encryptedPath, 'correct-key');

    const decryptedPath = join(dir, 'output.dump');
    await expect(decryptFile(encryptedPath, decryptedPath, 'wrong-key')).rejects.toThrow();
  });

  it('sha256File is deterministic for identical content', async () => {
    dir = await mkdtemp(join(tmpdir(), 'de-nest-backup-test-'));
    const pathA = join(dir, 'a.bin');
    const pathB = join(dir, 'b.bin');
    await writeFile(pathA, 'identical content');
    await writeFile(pathB, 'identical content');

    expect(await sha256File(pathA)).toBe(await sha256File(pathB));
  });

  it('sha256File differs for different content', async () => {
    dir = await mkdtemp(join(tmpdir(), 'de-nest-backup-test-'));
    const pathA = join(dir, 'a.bin');
    const pathB = join(dir, 'b.bin');
    await writeFile(pathA, 'content one');
    await writeFile(pathB, 'content two');

    expect(await sha256File(pathA)).not.toBe(await sha256File(pathB));
  });
});
