import { Type } from 'class-transformer';
import { ArrayMinSize, IsArray, IsEnum, IsNumber, IsOptional, IsString, Min, ValidateNested } from 'class-validator';
import { PaymentMethodCode } from '@prisma/client';

export class PaymentComponentInput {
  @IsEnum(PaymentMethodCode)
  method!: PaymentMethodCode;

  @IsNumber()
  @Min(0)
  amount!: number;

  @IsOptional()
  @IsString()
  externalReference?: string;
}

export class FinishWashDto {
  @IsArray()
  @ArrayMinSize(1)
  @ValidateNested({ each: true })
  @Type(() => PaymentComponentInput)
  components!: PaymentComponentInput[];
}
