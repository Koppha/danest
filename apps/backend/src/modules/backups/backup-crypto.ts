import { createReadStream, createWriteStream } from 'node:fs';
import { createCipheriv, createDecipheriv, createHash, randomBytes, scryptSync } from 'node:crypto';
import { pipeline } from 'node:stream/promises';

const SALT = 'de-nest-backup-salt';

function deriveKey(encryptionKey: string): Buffer {
  return scryptSync(encryptionKey, SALT, 32);
}

/** IV is not secret; it's prepended to the ciphertext so restore can read it back out. */
export async function encryptFile(inputPath: string, outputPath: string, encryptionKey: string): Promise<void> {
  const iv = randomBytes(16);
  const cipher = createCipheriv('aes-256-cbc', deriveKey(encryptionKey), iv);
  const output = createWriteStream(outputPath);
  output.write(iv);
  await pipeline(createReadStream(inputPath), cipher, output);
}

export async function decryptFile(inputPath: string, outputPath: string, encryptionKey: string): Promise<void> {
  const input = createReadStream(inputPath, { start: 0, end: 15 });
  const iv = await new Promise<Buffer>((resolve, reject) => {
    const chunks: Buffer[] = [];
    input.on('data', (c) => chunks.push(c as Buffer));
    input.on('end', () => resolve(Buffer.concat(chunks)));
    input.on('error', reject);
  });
  const decipher = createDecipheriv('aes-256-cbc', deriveKey(encryptionKey), iv);
  await pipeline(createReadStream(inputPath, { start: 16 }), decipher, createWriteStream(outputPath));
}

export async function sha256File(filePath: string): Promise<string> {
  const hash = createHash('sha256');
  await pipeline(createReadStream(filePath), hash);
  return hash.digest('hex');
}
