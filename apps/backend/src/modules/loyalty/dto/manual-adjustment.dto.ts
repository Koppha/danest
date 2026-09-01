import { IsString, IsUUID } from 'class-validator';
import { PinOverrideFields } from '../../../common/dto/pin-override.dto.js';

export class ManualLoyaltyAdjustmentDto extends PinOverrideFields {
  @IsUUID()
  vehicleId!: string;

  @IsString()
  note!: string;
}
