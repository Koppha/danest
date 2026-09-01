import { IsEnum, IsOptional, IsString, IsUUID } from 'class-validator';
import { VehicleType } from '@prisma/client';

export class CreateVehicleDto {
  @IsUUID()
  id!: string; // client-generated, offline dedup key

  @IsUUID()
  customerId!: string;

  @IsString()
  regNumber!: string;

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
}
