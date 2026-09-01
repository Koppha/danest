import { Injectable } from '@nestjs/common';
import type { BackupStorageAdapter, UploadResult } from '../backup-storage.interface.js';

/** Placeholder until GOOGLE_DRIVE_* credentials are configured in .env. */
@Injectable()
export class UnconfiguredGoogleDriveStorage implements BackupStorageAdapter {
  async upload(): Promise<UploadResult> {
    throw new Error('BACKUP_STORAGE_DRIVER=google_drive but no Google Drive credentials are configured — see .env.example');
  }
}
