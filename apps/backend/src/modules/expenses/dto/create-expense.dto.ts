import { IsEnum, IsNumber, IsOptional, IsString, IsUUID, Min } from 'class-validator';
import { ExpensePaymentMethod } from '@prisma/client';

export class CreateExpenseDto {
  /** Client-generated UUID, for idempotent offline retries — see CustomersService/WashOrdersService for the same pattern. */
  @IsOptional()
  @IsUUID()
  id?: string;

  @IsUUID()
  categoryId!: string;

  @IsString()
  description!: string;

  @IsNumber()
  @Min(0.01)
  amount!: number;

  @IsEnum(ExpensePaymentMethod)
  paymentMethod!: ExpensePaymentMethod;

  @IsOptional()
  @IsString()
  receiptFilePath?: string;
}
