import { PrismaClient, RoleName, VehicleType, PackageScope } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import * as argon2 from 'argon2';
import { randomUUID } from 'node:crypto';
import 'dotenv/config';

const adapter = new PrismaPg({ connectionString: process.env.DATABASE_URL });
const prisma = new PrismaClient({ adapter });

const PERMISSIONS: Record<RoleName, string[]> = {
  ATTENDANT: [
    'customers.read', 'customers.create', 'vehicles.read', 'vehicles.create',
    'wash.create', 'wash.transition', 'wash.finish',
    'payments.create', 'loyalty.read', 'prepaid.read', 'prepaid.deposit', 'prepaid.redeem',
    'sms.resend',
  ],
  SUPERVISOR: [
    'discounts.approve', 'wash.void', 'shifts.close', 'overrides.pin',
  ],
  ADMINISTRATOR: [
    'branches.manage', 'users.manage', 'services.manage', 'loyalty.manage',
    'prepaid.manage', 'collections.manage', 'expenses.manage', 'reports.read',
    'audit.read', 'sync.monitor', 'sms.monitor', 'backups.trigger', 'backups.view',
  ],
  OWNER: [
    'system.settings', 'backups.restore', 'administrators.manage',
  ],
};

// Each role inherits everything from the roles listed before it.
const INHERITANCE: RoleName[] = ['ATTENDANT', 'SUPERVISOR', 'ADMINISTRATOR', 'OWNER'];

async function main() {
  // --- roles + permissions (cumulative) ---
  const allKeys = new Map<string, string>();
  for (const role of INHERITANCE) {
    for (const key of PERMISSIONS[role]) allKeys.set(key, key);
  }
  for (const key of allKeys.keys()) {
    await prisma.permission.upsert({ where: { key }, update: {}, create: { key } });
  }

  const roleRecords = new Map<RoleName, { id: string }>();
  let cumulative: string[] = [];
  for (const roleName of INHERITANCE) {
    cumulative = [...cumulative, ...PERMISSIONS[roleName]];
    const role = await prisma.role.upsert({
      where: { name: roleName },
      update: {},
      create: { name: roleName },
    });
    roleRecords.set(roleName, role);
    const perms = await prisma.permission.findMany({ where: { key: { in: cumulative } } });
    await prisma.rolePermission.deleteMany({ where: { roleId: role.id } });
    await prisma.rolePermission.createMany({
      data: perms.map((p) => ({ roleId: role.id, permissionId: p.id })),
      skipDuplicates: true,
    });
  }

  // --- demo branch ---
  const branch = await prisma.branch.upsert({
    where: { code: 'MAIN' },
    update: {},
    create: { name: 'De Nest Main Branch', code: 'MAIN', address: 'Maseru, Lesotho' },
  });

  // --- seed admin user ---
  const adminUsername = process.env.SEED_ADMIN_USERNAME || 'admin';
  const adminPassword = process.env.SEED_ADMIN_PASSWORD || 'changeme_admin_password';
  const ownerRole = roleRecords.get('OWNER')!;
  await prisma.user.upsert({
    where: { username: adminUsername },
    update: {},
    create: {
      branchId: branch.id,
      fullName: 'De Nest Owner',
      username: adminUsername,
      passwordHash: await argon2.hash(adminPassword),
      roleId: ownerRole.id,
    },
  });

  // --- system account for scheduled/automated ledger entries (reward expiry, backups, etc.) ---
  // Loyalty ledger rows always reference a user; there is no human actor for
  // a cron-triggered expiry, so this dedicated non-login account fills that
  // role. It has no usable password (random hash, never issued to anyone).
  await prisma.user.upsert({
    where: { username: 'system' },
    update: {},
    create: {
      branchId: branch.id,
      fullName: 'System',
      username: 'system',
      passwordHash: await argon2.hash(randomUUID()),
      roleId: ownerRole.id,
      active: false,
    },
  });

  // --- payment methods ---
  const paymentMethods: { code: any; label: string; referenceRequired: any }[] = [
    { code: 'CASH', label: 'Cash', referenceRequired: 'NONE' },
    { code: 'CARD', label: 'Card', referenceRequired: 'OPTIONAL' },
    { code: 'MOBILE_MONEY', label: 'Mobile Money', referenceRequired: 'MANDATORY' },
    { code: 'BANK_TRANSFER', label: 'Bank transfer', referenceRequired: 'MANDATORY' },
    { code: 'WALLET', label: 'Prepaid balance', referenceRequired: 'NONE' },
    { code: 'PACKAGE', label: 'Wash package', referenceRequired: 'NONE' },
    { code: 'LOYALTY_FREE_WASH', label: 'Free wash', referenceRequired: 'NONE' },
  ];
  for (const pm of paymentMethods) {
    await prisma.paymentMethodConfig.upsert({
      where: { code: pm.code },
      update: {},
      create: pm,
    });
  }

  // --- wash services ---
  const services = [
    { name: 'Standard Wash', tier: 'standard', basePrice: 60, durationMinutes: 15, applicableVehicleTypes: [] as VehicleType[] },
    { name: 'Deluxe Wash', tier: 'deluxe', basePrice: 80, durationMinutes: 30, applicableVehicleTypes: [] as VehicleType[] },
    { name: 'Premium Wash', tier: 'premium', basePrice: 120, durationMinutes: 50, applicableVehicleTypes: [] as VehicleType[] },
    { name: 'Engine Bay Wash', tier: 'standard', basePrice: 80, durationMinutes: 20, applicableVehicleTypes: [] as VehicleType[] },
    { name: 'Bakkie & SUV Full', tier: 'deluxe', basePrice: 130, durationMinutes: 40, applicableVehicleTypes: ['BAKKIE', 'SUV'] as VehicleType[] },
  ];
  for (const s of services) {
    const existing = await prisma.washService.findFirst({ where: { name: s.name } });
    if (!existing) await prisma.washService.create({ data: s });
  }

  // --- extras ---
  const extras = [
    { name: 'Interior Vacuum', price: 30 },
    { name: 'Tyre Shine', price: 20 },
    { name: 'Dashboard Polish', price: 25 },
    { name: 'Mats Deep Clean', price: 40 },
    { name: 'Air Freshener', price: 15 },
  ];
  for (const e of extras) {
    const existing = await prisma.washExtra.findFirst({ where: { name: e.name } });
    if (!existing) await prisma.washExtra.create({ data: e });
  }

  // --- expense categories ---
  const categories = [
    'Cleaning supplies', 'Water', 'Electricity', 'Equipment maintenance',
    'Salaries and casual labour', 'Rent', 'Transport', 'Marketing', 'Other',
  ];
  for (const name of categories) {
    await prisma.expenseCategory.upsert({ where: { name }, update: {}, create: { name } });
  }

  // --- example prepaid packages ---
  const packages = [
    { name: '5 Standard Washes', eligibleTiers: ['standard'], washCount: 5, price: 270, validityDays: 90, applicableScope: 'ANY_VEHICLE_OF_CUSTOMER' as PackageScope },
    { name: '8 Deluxe Washes', eligibleTiers: ['standard', 'deluxe'], washCount: 8, price: 560, validityDays: 120, applicableScope: 'ANY_VEHICLE_OF_CUSTOMER' as PackageScope },
    { name: 'Fleet Monthly, 20 washes', eligibleTiers: ['standard', 'deluxe'], washCount: 20, price: 1800, validityDays: 30, applicableScope: 'ANY_VEHICLE_OF_CUSTOMER' as PackageScope },
  ];
  for (const p of packages) {
    const existing = await prisma.prepaidPackage.findFirst({ where: { name: p.name } });
    if (!existing) await prisma.prepaidPackage.create({ data: p });
  }

  console.log('Seed complete. Admin login:', adminUsername, '/', adminPassword);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
