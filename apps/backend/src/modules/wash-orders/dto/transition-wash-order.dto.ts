import { IsEnum, IsOptional, IsString } from 'class-validator';
import { WashStatus } from '@prisma/client';

export class TransitionWashOrderDto {
  @IsEnum(WashStatus)
  toStatus!: WashStatus;

  @IsOptional()
  @IsString()
  cancelReason?: string;

  // Present only when toStatus is CANCELLED (RequiresPin guard enforces this).
  @IsOptional()
  @IsString()
  overridePin?: string;

  @IsOptional()
  @IsString()
  overrideReason?: string;

  @IsOptional()
  @IsString()
  overrideUsername?: string;
}
