import { IsArray, IsBoolean, IsInt, IsNumber, IsOptional, IsString, Min } from 'class-validator';
import { VehicleType } from '@prisma/client';

export class CreateWashServiceDto {
  @IsString()
  name!: string;

  @IsNumber()
  @Min(0)
  basePrice!: number;

  @IsInt()
  @Min(0)
  durationMinutes!: number;

  @IsOptional()
  @IsArray()
  applicableVehicleTypes?: VehicleType[];
}

export class UpdateWashServiceDto {
  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsNumber()
  @Min(0)
  basePrice?: number;

  @IsOptional()
  @IsInt()
  @Min(0)
  durationMinutes?: number;

  @IsOptional()
  @IsArray()
  applicableVehicleTypes?: VehicleType[];

  @IsOptional()
  @IsBoolean()
  active?: boolean;
}

export class CreateWashExtraDto {
  @IsString()
  name!: string;

  @IsNumber()
  @Min(0)
  price!: number;

  @IsOptional()
  @IsInt()
  @Min(0)
  durationMinutes?: number;
}

export class UpdateWashExtraDto {
  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsNumber()
  @Min(0)
  price?: number;

  @IsOptional()
  @IsInt()
  @Min(0)
  durationMinutes?: number;

  @IsOptional()
  @IsBoolean()
  active?: boolean;
}
