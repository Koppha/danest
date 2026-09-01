import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { GoogleAuth } from 'google-auth-library';
import { drive as driveApi, type drive_v3 } from '@googleapis/drive';
import { createReadStream } from 'node:fs';
import type { BackupStorageAdapter, UploadResult } from '../backup-storage.interface.js';

/**
 * Uploads encrypted backup files to a Google Drive folder via a service
 * account. The service account's key never touches disk beyond the env
 * var it's read from; the private key's `\n` sequences must be literal
 * newlines when set (most .env loaders need `\\n` in the file, unescaped
 * here).
 */
@Injectable()
export class GoogleDriveBackupStorage implements BackupStorageAdapter {
  private readonly logger = new Logger('GoogleDriveBackupStorage');
  private readonly drive: drive_v3.Drive;
  private readonly folderId: string;

  constructor(config: ConfigService) {
    const clientEmail = config.get<string>('backup.googleDrive.clientEmail');
    const privateKey = config.get<string>('backup.googleDrive.privateKey')?.replace(/\\n/g, '\n');
    this.folderId = config.get<string>('backup.googleDrive.folderId')!;

    const auth = new GoogleAuth({
      credentials: { client_email: clientEmail, private_key: privateKey },
      scopes: ['https://www.googleapis.com/auth/drive.file'],
    });
    this.drive = driveApi({ version: 'v3', auth: auth as unknown as string });
  }

  async upload(localFilePath: string, fileName: string): Promise<UploadResult> {
    this.logger.log(`Uploading ${fileName} to Google Drive folder ${this.folderId}`);
    const res = await this.drive.files.create({
      requestBody: { name: fileName, parents: [this.folderId] },
      media: { mimeType: 'application/octet-stream', body: createReadStream(localFilePath) },
      fields: 'id',
    });
    const fileId = res.data.id;
    if (!fileId) throw new Error('Google Drive upload did not return a file id');
    return { externalFileId: fileId };
  }
}
