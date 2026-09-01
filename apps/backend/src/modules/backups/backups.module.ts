import { Module, OnModuleInit } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { ScheduleModule, SchedulerRegistry } from '@nestjs/schedule';
import { CronJob } from 'cron';
import { BackupsController } from './backups.controller.js';
import { BackupsService } from './backups.service.js';
import { BackupsRetentionScheduler } from './backups-retention.scheduler.js';
import { BACKUP_STORAGE_ADAPTER } from './backup-storage.interface.js';
import { LocalDiskBackupStorage } from './adapters/local-disk-backup-storage.js';
import { GoogleDriveBackupStorage } from './adapters/google-drive-backup-storage.js';
import { UnconfiguredGoogleDriveStorage } from './adapters/unconfigured-google-drive-storage.js';

@Module({
  imports: [ConfigModule, ScheduleModule.forRoot()],
  controllers: [BackupsController],
  providers: [
    BackupsService,
    BackupsRetentionScheduler,
    {
      provide: BACKUP_STORAGE_ADAPTER,
      inject: [ConfigService],
      useFactory: (config: ConfigService) => {
        const driver = config.get<string>('backup.storageDriver');
        if (driver === 'google_drive') {
          const configured =
            config.get<string>('backup.googleDrive.clientEmail') &&
            config.get<string>('backup.googleDrive.privateKey') &&
            config.get<string>('backup.googleDrive.folderId');
          return configured ? new GoogleDriveBackupStorage(config) : new UnconfiguredGoogleDriveStorage();
        }
        return new LocalDiskBackupStorage(config.get<string>('backup.localPath')!);
      },
    },
  ],
})
export class BackupsModule implements OnModuleInit {
  constructor(
    private readonly config: ConfigService,
    private readonly schedulerRegistry: SchedulerRegistry,
    private readonly backupsService: BackupsService,
  ) {}

  // BACKUP_CRON is user-configurable, so the job is registered dynamically
  // here rather than via a static @Cron() decorator.
  onModuleInit() {
    const cronExpression = this.config.get<string>('backup.cron')!;
    const job = new CronJob(cronExpression, () => void this.backupsService.runBackup());
    this.schedulerRegistry.addCronJob('scheduled-backup', job);
    job.start();
  }
}
