import { Body, Controller, Get, Param, Post, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { ConfigService } from '@nestjs/config';
import { PrepaidService } from './prepaid.service.js';
import { DepositDto } from './dto/deposit.dto.js';
import { PurchasePackageDto } from './dto/purchase-package.dto.js';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard.js';
import { CurrentUser } from '../../common/decorators/current-user.decorator.js';
import { Audit } from '../../common/decorators/audit.decorator.js';
import type { AuthenticatedUser } from '../../common/types/authenticated-user.js';

@ApiTags('prepaid')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('prepaid')
export class PrepaidController {
  constructor(
    private readonly prepaidService: PrepaidService,
    private readonly config: ConfigService,
  ) {}

  @Get('customers/:customerId/overview')
  overview(@Param('customerId') customerId: string) {
    return this.prepaidService.customerOverview(customerId);
  }

  @Get('packages')
  listPackages() {
    return this.prepaidService.listPackages();
  }

  @Get('offline-policy')
  offlinePolicy() {
    return this.prepaidService.offlinePolicy(
      this.config.get<number>('offlinePrepaid.freshnessWindowHours')!,
      this.config.get<number>('offlinePrepaid.perTransactionCap')!,
    );
  }

  @Post('deposits')
  @Audit('PREPAID_DEPOSIT')
  deposit(@Body() dto: DepositDto, @CurrentUser() actor: AuthenticatedUser) {
    return this.prepaidService.deposit({ ...dto, actor });
  }

  @Post('package-purchases')
  @Audit('PREPAID_PACKAGE_PURCHASE')
  purchasePackage(@Body() dto: PurchasePackageDto, @CurrentUser() actor: AuthenticatedUser) {
    return this.prepaidService.purchasePackage({ ...dto, actor });
  }
}
