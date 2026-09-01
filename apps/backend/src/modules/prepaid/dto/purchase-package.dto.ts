import { IsOptional, IsString, IsUUID } from 'class-validator';

export class PurchasePackageDto {
  @IsUUID()
  customerId!: string;

  @IsUUID()
  packageId!: string;

  @IsOptional()
  @IsUUID()
  vehicleId?: string;

  @IsString()
  paymentMethod!: string; // CASH | CARD | MOBILE_MONEY | BANK_TRANSFER

  @IsOptional()
  @IsString()
  paymentReference?: string;
}
