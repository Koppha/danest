import { BadRequestException, Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service.js';
import { AuditService } from '../audit/audit.service.js';
import type { CreateExpenseDto } from './dto/create-expense.dto.js';
import type { AuthenticatedUser } from '../../common/types/authenticated-user.js';

@Injectable()
export class ExpensesService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
  ) {}

  list(branchId: string) {
    return this.prisma.expense.findMany({ where: { branchId }, include: { category: true }, orderBy: { createdAt: 'desc' } });
  }

  listCategories() {
    return this.prisma.expenseCategory.findMany({ where: { active: true } });
  }

  async create(dto: CreateExpenseDto, actor: AuthenticatedUser) {
    const expense = await this.prisma.expense.create({
      data: { ...dto, branchId: actor.branchId, createdById: actor.userId },
    });

    await this.audit.record({
      branchId: actor.branchId,
      userId: actor.userId,
      deviceId: actor.deviceId,
      action: 'EXPENSE_CREATED',
      entityType: 'Expense',
      entityId: expense.id,
      afterSnapshot: expense,
    });

    return expense;
  }

  /** Append-only correction: creates a negative-amount reversal row rather than editing the original. */
  async reverse(id: string, reason: string, actor: AuthenticatedUser) {
    const original = await this.prisma.expense.findUniqueOrThrow({ where: { id } });
    if (original.reversedByExpenseId) throw new BadRequestException('This expense has already been reversed');

    const [reversal] = await this.prisma.$transaction([
      this.prisma.expense.create({
        data: {
          branchId: original.branchId,
          categoryId: original.categoryId,
          description: `Reversal of ${original.id}: ${reason}`,
          amount: Number(original.amount) * -1,
          paymentMethod: original.paymentMethod,
          createdById: actor.userId,
        },
      }),
    ]);
    await this.prisma.expense.update({ where: { id: original.id }, data: { reversedByExpenseId: reversal.id } });

    await this.audit.record({
      branchId: actor.branchId,
      userId: actor.userId,
      deviceId: actor.deviceId,
      action: 'EXPENSE_REVERSED',
      entityType: 'Expense',
      entityId: id,
      afterSnapshot: { reversalId: reversal.id, reason },
    });

    return reversal;
  }
}
