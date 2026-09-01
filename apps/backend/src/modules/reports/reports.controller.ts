import { Controller, Get, Query, Res, UseGuards } from '@nestjs/common';
import type { Response } from 'express';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { ReportsService } from './reports.service.js';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard.js';
import { RolesGuard } from '../../common/guards/roles.guard.js';
import { Roles } from '../../common/decorators/roles.decorator.js';
import { CurrentUser } from '../../common/decorators/current-user.decorator.js';
import type { AuthenticatedUser } from '../../common/types/authenticated-user.js';

@ApiTags('reports')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('SUPERVISOR', 'ADMINISTRATOR', 'OWNER')
@Controller('reports')
export class ReportsController {
  constructor(private readonly reportsService: ReportsService) {}

  @Get('summary')
  summary(@CurrentUser() actor: AuthenticatedUser, @Query('from') from: string, @Query('to') to: string) {
    return this.reportsService.summary(actor.branchId, new Date(from), new Date(to));
  }

  @Get('transactions')
  transactions(@CurrentUser() actor: AuthenticatedUser, @Query('from') from: string, @Query('to') to: string) {
    return this.reportsService.transactions(actor.branchId, new Date(from), new Date(to));
  }

  @Get('transactions.csv')
  async transactionsCsv(
    @CurrentUser() actor: AuthenticatedUser,
    @Query('from') from: string,
    @Query('to') to: string,
    @Res() res: Response,
  ) {
    const rows = await this.reportsService.transactions(actor.branchId, new Date(from), new Date(to));
    const flat = rows.map((r) => ({
      date: r.completedAt?.toISOString() ?? '',
      vehicle: r.washOrder.vehicle.regNumberDisplay,
      customer: r.washOrder.customer.fullName,
      total: r.totalAmount.toString(),
      methods: r.components.map((c) => c.paymentMethod.code).join('+'),
      voided: r.voided,
    }));
    const csv = this.reportsService.toCsv(flat);
    res.setHeader('Content-Type', 'text/csv');
    res.setHeader('Content-Disposition', 'attachment; filename="transactions.csv"');
    res.send(csv);
  }
}
