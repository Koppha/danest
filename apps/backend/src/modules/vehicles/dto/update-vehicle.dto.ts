import { IsBoolean, IsEnum, IsOptional, IsString } from 'class-validator';
import { VehicleType } from '@prisma/client';

export class UpdateVehicleDto {
  @IsOptional()
  @IsString()
  make?: string;

  @IsOptional()
  @IsString()
  model?: string;

  @IsOptional()
  @IsString()
  colour?: string;

  @IsOptional()
  @IsEnum(VehicleType)
  vehicleType?: VehicleType;

  @IsOptional()
  @IsBoolean()
  active?: boolean;
}
