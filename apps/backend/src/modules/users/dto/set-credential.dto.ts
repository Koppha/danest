import { IsString, MinLength } from 'class-validator';

export class SetPasswordDto {
  @IsString()
  @MinLength(8)
  password!: string;
}

export class SetPinDto {
  @IsString()
  @MinLength(4)
  pin!: string;
}
