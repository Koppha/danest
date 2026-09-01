import { IsEnum, IsString, IsUUID } from 'class-validator';
import { Platform } from '@prisma/client';

export class RegisterDeviceDto {
  @IsUUID()
  branchId!: string;

  @IsString()
  deviceName!: string;

  @IsEnum(Platform)
  platform!: Platform;

  @IsString()
  installId!: string;
}
