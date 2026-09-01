import { IsEnum, IsNumber, IsOptional, IsString, IsUUID, Min } from 'class-validator';
import { PaymentMethodCode } from '@prisma/client';

const DEPOSIT_METHODS = [
  PaymentMethodCode.CASH,
  PaymentMethodCode.CARD,
  PaymentMethodCode.MOBILE_MONEY,
  PaymentMethodCode.BANK_TRANSFER,
] as const;

export class DepositDto {
  @IsUUID()
  customerId!: string;

  @IsNumber()
  @Min(0.01)
  amount!: number;

  @IsEnum(DEPOSIT_METHODS)
  method!: (typeof DEPOSIT_METHODS)[number];

  @IsOptional()
  @IsString()
  reference?: string;

  @IsString()
  clientEntryId!: string;
}
