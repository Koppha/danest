import { IsString } from 'class-validator';

export class ReverseExpenseDto {
  @IsString()
  reason!: string;
}
