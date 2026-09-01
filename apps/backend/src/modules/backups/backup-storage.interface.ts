export interface UploadResult {
  /** External file identifier (e.g. Google Drive file ID); null for local storage. */
  externalFileId: string | null;
}

export interface BackupStorageAdapter {
  upload(localFilePath: string, fileName: string): Promise<UploadResult>;
}

export const BACKUP_STORAGE_ADAPTER = Symbol('BACKUP_STORAGE_ADAPTER');
