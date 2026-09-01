import { Body, Controller, Get, Param, Post, Res, UploadedFile, UseGuards, UseInterceptors } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ConfigService } from '@nestjs/config';
import type { Response } from 'express';
import { diskStorage } from 'multer';
import { existsSync, mkdirSync } from 'node:fs';
import { join } from 'node:path';
import { randomUUID } from 'node:crypto';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { ExpensesService } from './expenses.service.js';
import { CreateExpenseDto } from './dto/create-expense.dto.js';
import { ReverseExpenseDto } from './dto/reverse-expense.dto.js';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard.js';
import { RolesGuard } from '../../common/guards/roles.guard.js';
import { Roles } from '../../common/decorators/roles.decorator.js';
import { CurrentUser } from '../../common/decorators/current-user.decorator.js';
import { Audit } from '../../common/decorators/audit.decorator.js';
import type { AuthenticatedUser } from '../../common/types/authenticated-user.js';
import { PrismaService } from '../../database/prisma.service.js';

@ApiTags('expenses')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('ADMINISTRATOR', 'OWNER')
@Controller('expenses')
export class ExpensesController {
  constructor(
    private readonly expensesService: ExpensesService,
    private readonly config: ConfigService,
    private readonly prisma: PrismaService,
  ) {}

  @Get()
  list(@CurrentUser() actor: AuthenticatedUser) {
    return this.expensesService.list(actor.branchId);
  }

  @Get('categories')
  categories() {
    return this.expensesService.listCategories();
  }

  @Post()
  @Audit('EXPENSE_CREATE')
  create(@Body() dto: CreateExpenseDto, @CurrentUser() actor: AuthenticatedUser) {
    return this.expensesService.create(dto, actor);
  }

  @Post(':id/reverse')
  @Audit('EXPENSE_REVERSE')
  reverse(@Param('id') id: string, @Body() dto: ReverseExpenseDto, @CurrentUser() actor: AuthenticatedUser) {
    return this.expensesService.reverse(id, dto.reason, actor);
  }

  @Post(':id/receipt')
  @UseInterceptors(
    FileInterceptor('file', {
      storage: diskStorage({
        destination: (_req, _file, cb) => {
          const dir = process.env.STORAGE_LOCAL_PATH ?? './storage/receipts';
          if (!existsSync(dir)) mkdirSync(dir, { recursive: true });
          cb(null, dir);
        },
        filename: (_req, file, cb) => cb(null, `${randomUUID()}-${file.originalname}`),
      }),
      limits: { fileSize: 10 * 1024 * 1024 },
    }),
  )
  async uploadReceipt(@Param('id') id: string, @UploadedFile() file: Express.Multer.File) {
    await this.prisma.expense.update({ where: { id }, data: { receiptFilePath: file.path } });
    return { receiptFilePath: file.path };
  }

  @Get(':id/receipt')
  async downloadReceipt(@Param('id') id: string, @Res() res: Response) {
    const expense = await this.prisma.expense.findUniqueOrThrow({ where: { id } });
    if (!expense.receiptFilePath) return res.status(404).send({ message: 'No receipt attached' });
    return res.sendFile(join(process.cwd(), expense.receiptFilePath));
  }
}
