import { IsString } from 'class-validator';
import { PinOverrideFields } from '../../../common/dto/pin-override.dto.js';

export class VoidPaymentDto extends PinOverrideFields {
  @IsString()
  reason!: string;
}
