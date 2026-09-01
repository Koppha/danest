import { Type } from 'class-transformer';
import { ArrayMinSize, IsArray, IsEnum, IsInt, IsOptional, IsUUID, Min, ValidateNested } from 'class-validator';
import { WashOrderItemType } from '@prisma/client';

export class WashOrderItemInput {
  @IsEnum(WashOrderItemType)
  itemType!: WashOrderItemType;

  @IsOptional()
  @IsUUID()
  serviceId?: string;

  @IsOptional()
  @IsUUID()
  extraId?: string;

  @IsOptional()
  @IsInt()
  @Min(1)
  qty?: number;
}

export class CreateWashOrderDto {
  @IsUUID()
  id!: string; // client-generated, offline dedup key

  @IsUUID()
  vehicleId!: string;

  @IsArray()
  @ArrayMinSize(1)
  @ValidateNested({ each: true })
  @Type(() => WashOrderItemInput)
  items!: WashOrderItemInput[];

  @IsOptional()
  @IsUUID()
  deviceId?: string;
}
