import { IsBoolean, IsEnum, IsOptional, IsString } from 'class-validator';
import { RoleName } from '@prisma/client';

export class UpdateUserDto {
  @IsOptional()
  @IsString()
  fullName?: string;

  @IsOptional()
  @IsEnum(RoleName)
  role?: RoleName;

  @IsOptional()
  @IsBoolean()
  active?: boolean;
}
