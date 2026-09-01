export default () => ({
  port: parseInt(process.env.PORT ?? '3000', 10),
  nodeEnv: process.env.NODE_ENV ?? 'development',
  corsOrigin: process.env.CORS_ORIGIN ?? '*',
  databaseUrl: process.env.DATABASE_URL,
  jwt: {
    accessSecret: process.env.JWT_ACCESS_SECRET ?? 'changeme_access_secret',
    accessTtl: process.env.JWT_ACCESS_TTL ?? '15m',
    refreshSecret: process.env.JWT_REFRESH_SECRET ?? 'changeme_refresh_secret',
    refreshTtl: process.env.JWT_REFRESH_TTL ?? '30d',
  },
  throttle: {
    ttlMs: parseInt(process.env.THROTTLE_TTL_MS ?? '60000', 10),
    limit: parseInt(process.env.THROTTLE_LIMIT ?? '100', 10),
  },
  sms: {
    provider: process.env.SMS_PROVIDER ?? 'mock',
    from: process.env.SMS_FROM ?? 'DeNest',
    africastalking: {
      apiKey: process.env.AFRICASTALKING_API_KEY ?? '',
      username: process.env.AFRICASTALKING_USERNAME ?? '',
    },
    twilio: {
      accountSid: process.env.TWILIO_ACCOUNT_SID ?? '',
      authToken: process.env.TWILIO_AUTH_TOKEN ?? '',
      fromNumber: process.env.TWILIO_FROM_NUMBER ?? '',
    },
    clickatell: {
      apiKey: process.env.CLICKATELL_API_KEY ?? '',
    },
  },
  storage: {
    driver: process.env.STORAGE_DRIVER ?? 'local',
    localPath: process.env.STORAGE_LOCAL_PATH ?? './storage/receipts',
  },
  backup: {
    storageDriver: process.env.BACKUP_STORAGE_DRIVER ?? 'local',
    localPath: process.env.BACKUP_LOCAL_PATH ?? './storage/backups',
    encryptionKey: process.env.BACKUP_ENCRYPTION_KEY ?? '',
    retentionDays: parseInt(process.env.BACKUP_RETENTION_DAYS ?? '30', 10),
    cron: process.env.BACKUP_CRON ?? '0 2 * * *',
    googleDrive: {
      clientEmail: process.env.GOOGLE_DRIVE_CLIENT_EMAIL ?? '',
      privateKey: process.env.GOOGLE_DRIVE_PRIVATE_KEY ?? '',
      folderId: process.env.GOOGLE_DRIVE_FOLDER_ID ?? '',
    },
  },
  offlinePrepaid: {
    freshnessWindowHours: parseInt(process.env.OFFLINE_PREPAID_FRESHNESS_HOURS ?? '24', 10),
    perTransactionCap: parseFloat(process.env.OFFLINE_PREPAID_PER_TX_CAP ?? '500'),
  },
});
