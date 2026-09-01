import { IsOptional, IsString, IsUUID } from 'class-validator';

export class CreateCustomerDto {
  @IsUUID()
  id!: string; // client-generated, offline dedup key

  @IsUUID()
  branchId!: string;

  @IsString()
  fullName!: string;

  @IsString()
  phone!: string;

  @IsOptional()
  @IsString()
  altPhone?: string;

  @IsOptional()
  @IsString()
  notes?: string;
}
