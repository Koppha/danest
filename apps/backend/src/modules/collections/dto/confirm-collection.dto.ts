import { IsDateString, IsNumber, IsOptional, IsString, IsUUID, Min } from 'class-validator';

export class ConfirmCollectionDto {
  /** Client-generated UUID, for idempotent offline retries. */
  @IsOptional()
  @IsUUID()
  id?: string;

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

  /**
   * When the attendant actually counted the cash (may be well before the
   * device reconnects and this request lands, if it was queued offline).
   * Used as the period end for computeExpected() instead of server "now",
   * so a late sync doesn't pull in transactions the attendant never saw.
   */
  @IsOptional()
  @IsDateString()
  countedAt?: string;
}
