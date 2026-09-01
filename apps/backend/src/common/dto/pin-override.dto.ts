import { IsOptional, IsString } from 'class-validator';

/** Extend this on any DTO used on a route guarded by PinOverrideGuard/@RequiresPin(). */
export class PinOverrideFields {
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
