import { IsNumber, IsOptional, IsString, Min } from 'class-validator';

export class ConfirmCollectionDto {
  @IsNumber()
  @Min(0)
  countedCash!: number;

  @IsOptional()
  @IsString()
  varianceReason?: string;

  @IsOptional()
  @IsString()
  witness?: string;

  @IsOptional()
  @IsString()
  notes?: string;
}
