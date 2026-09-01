import { IsEnum, IsOptional, IsString, IsUUID, MinLength } from 'class-validator';
import { RoleName } from '@prisma/client';

export class CreateUserDto {
  @IsUUID()
  branchId!: string;

  @IsString()
  fullName!: string;

  @IsString()
  username!: string;

  @IsString()
  @MinLength(8)
  password!: string;

  @IsEnum(RoleName)
  role!: RoleName;

  @IsOptional()
  @IsString()
  @MinLength(4)
  pin?: string;
}
