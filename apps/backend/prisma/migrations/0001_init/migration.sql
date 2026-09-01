-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateEnum
CREATE TYPE "RoleName" AS ENUM ('ATTENDANT', 'SUPERVISOR', 'ADMINISTRATOR', 'OWNER');

-- CreateEnum
CREATE TYPE "Platform" AS ENUM ('ANDROID', 'WINDOWS');

-- CreateEnum
CREATE TYPE "DeviceStatus" AS ENUM ('ACTIVE', 'REVOKED');

-- CreateEnum
CREATE TYPE "CustomerStatus" AS ENUM ('ACTIVE', 'BLOCKED');

-- CreateEnum
CREATE TYPE "VehicleType" AS ENUM ('SEDAN', 'HATCHBACK', 'SUV', 'BAKKIE', 'TRUCK', 'MOTORBIKE', 'OTHER');

-- CreateEnum
CREATE TYPE "WashStatus" AS ENUM ('WAITING', 'WASHING', 'READY', 'COMPLETED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "WashOrderItemType" AS ENUM ('SERVICE', 'EXTRA');

-- CreateEnum
CREATE TYPE "PaymentMethodCode" AS ENUM ('CASH', 'CARD', 'MOBILE_MONEY', 'BANK_TRANSFER', 'WALLET', 'PACKAGE', 'LOYALTY_FREE_WASH');

-- CreateEnum
CREATE TYPE "ReferenceRequirement" AS ENUM ('NONE', 'OPTIONAL', 'MANDATORY');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('PENDING', 'COMPLETED', 'VOIDED');

-- CreateEnum
CREATE TYPE "LoyaltyEventType" AS ENUM ('WASH_CREDITED', 'WASH_REVERSED', 'REWARD_EARNED', 'REWARD_REDEEMED', 'REWARD_EXPIRED', 'MANAGER_ADJUSTMENT');

-- CreateEnum
CREATE TYPE "RewardStatus" AS ENUM ('AVAILABLE', 'REDEEMED', 'EXPIRED', 'REVOKED');

-- CreateEnum
CREATE TYPE "WalletLedgerEntryType" AS ENUM ('DEPOSIT', 'DEBIT', 'ADJUSTMENT');

-- CreateEnum
CREATE TYPE "PackageScope" AS ENUM ('ANY_VEHICLE_OF_CUSTOMER', 'SPECIFIC_VEHICLE');

-- CreateEnum
CREATE TYPE "SmsStatus" AS ENUM ('QUEUED', 'SENT', 'DELIVERED', 'FAILED');

-- CreateEnum
CREATE TYPE "CollectionResult" AS ENUM ('MATCHED', 'SHORT', 'OVER');

-- CreateEnum
CREATE TYPE "ExpensePaymentMethod" AS ENUM ('CASH', 'CARD', 'BANK_TRANSFER', 'OTHER');

-- CreateEnum
CREATE TYPE "SyncBatchStatus" AS ENUM ('ACCEPTED', 'PARTIAL', 'REJECTED');

-- CreateEnum
CREATE TYPE "ConflictType" AS ENUM ('BALANCE_WOULD_GO_NEGATIVE', 'STALE_REFERENCE', 'PERMISSION_DENIED', 'OTHER');

-- CreateEnum
CREATE TYPE "ConflictStatus" AS ENUM ('PENDING', 'RESOLVED', 'DISMISSED');

-- CreateEnum
CREATE TYPE "BackupStatus" AS ENUM ('RUNNING', 'SUCCESS', 'FAILED');

-- CreateEnum
CREATE TYPE "IdempotencyStatus" AS ENUM ('IN_PROGRESS', 'COMPLETED', 'FAILED');

-- CreateTable
CREATE TABLE "branches" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "address" TEXT,
    "phone" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "branches_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "roles" (
    "id" UUID NOT NULL,
    "name" "RoleName" NOT NULL,

    CONSTRAINT "roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "permissions" (
    "id" UUID NOT NULL,
    "key" TEXT NOT NULL,
    "description" TEXT,

    CONSTRAINT "permissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "role_permissions" (
    "roleId" UUID NOT NULL,
    "permissionId" UUID NOT NULL,

    CONSTRAINT "role_permissions_pkey" PRIMARY KEY ("roleId","permissionId")
);

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL,
    "branchId" UUID NOT NULL,
    "fullName" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "pinHash" TEXT,
    "roleId" UUID NOT NULL,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "lastLoginAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "refresh_tokens" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "tokenHash" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "revokedAt" TIMESTAMP(3),
    "replacedByTokenId" UUID,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "refresh_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "devices" (
    "id" UUID NOT NULL,
    "branchId" UUID NOT NULL,
    "deviceName" TEXT NOT NULL,
    "platform" "Platform" NOT NULL,
    "installId" TEXT NOT NULL,
    "lastSyncAt" TIMESTAMP(3),
    "status" "DeviceStatus" NOT NULL DEFAULT 'ACTIVE',
    "registeredById" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "devices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "customers" (
    "id" UUID NOT NULL,
    "branchId" UUID NOT NULL,
    "fullName" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "altPhone" TEXT,
    "dateRegistered" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" "CustomerStatus" NOT NULL DEFAULT 'ACTIVE',
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "customers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "vehicles" (
    "id" UUID NOT NULL,
    "customerId" UUID NOT NULL,
    "regNumberNormalized" TEXT NOT NULL,
    "regNumberDisplay" TEXT NOT NULL,
    "make" TEXT,
    "model" TEXT,
    "colour" TEXT,
    "vehicleType" "VehicleType" NOT NULL DEFAULT 'SEDAN',
    "active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "vehicles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "wash_services" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "tier" TEXT NOT NULL DEFAULT 'standard',
    "basePrice" DECIMAL(12,2) NOT NULL,
    "durationMinutes" INTEGER NOT NULL,
    "applicableVehicleTypes" "VehicleType"[],
    "active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "wash_services_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "wash_extras" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "price" DECIMAL(12,2) NOT NULL,
    "durationMinutes" INTEGER NOT NULL DEFAULT 0,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "wash_extras_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "wash_orders" (
    "id" UUID NOT NULL,
    "branchId" UUID NOT NULL,
    "vehicleId" UUID NOT NULL,
    "customerId" UUID NOT NULL,
    "createdById" UUID NOT NULL,
    "deviceId" UUID,
    "status" "WashStatus" NOT NULL DEFAULT 'WAITING',
    "totalAmount" DECIMAL(12,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'LSL',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completedAt" TIMESTAMP(3),
    "cancelledAt" TIMESTAMP(3),
    "cancelReason" TEXT,

    CONSTRAINT "wash_orders_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "wash_order_items" (
    "id" UUID NOT NULL,
    "washOrderId" UUID NOT NULL,
    "itemType" "WashOrderItemType" NOT NULL,
    "serviceId" UUID,
    "extraId" UUID,
    "nameSnapshot" TEXT NOT NULL,
    "priceSnapshot" DECIMAL(12,2) NOT NULL,
    "qty" INTEGER NOT NULL DEFAULT 1,

    CONSTRAINT "wash_order_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "wash_status_history" (
    "id" UUID NOT NULL,
    "washOrderId" UUID NOT NULL,
    "fromStatus" "WashStatus",
    "toStatus" "WashStatus" NOT NULL,
    "changedById" UUID NOT NULL,
    "changedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deviceId" UUID,

    CONSTRAINT "wash_status_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_methods" (
    "id" UUID NOT NULL,
    "code" "PaymentMethodCode" NOT NULL,
    "label" TEXT NOT NULL,
    "referenceRequired" "ReferenceRequirement" NOT NULL DEFAULT 'NONE',
    "active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "payment_methods_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payments" (
    "id" UUID NOT NULL,
    "washOrderId" UUID NOT NULL,
    "createdById" UUID NOT NULL,
    "deviceId" UUID,
    "totalAmount" DECIMAL(12,2) NOT NULL,
    "status" "PaymentStatus" NOT NULL DEFAULT 'PENDING',
    "completedAt" TIMESTAMP(3),
    "voided" BOOLEAN NOT NULL DEFAULT false,
    "voidedAt" TIMESTAMP(3),
    "voidReason" TEXT,

    CONSTRAINT "payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_components" (
    "id" UUID NOT NULL,
    "paymentId" UUID NOT NULL,
    "paymentMethodId" UUID NOT NULL,
    "amount" DECIMAL(12,2) NOT NULL,
    "externalReference" TEXT,
    "walletLedgerId" UUID,
    "packageUsageId" UUID,
    "loyaltyRewardId" UUID,

    CONSTRAINT "payment_components_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "loyalty_ledger" (
    "id" UUID NOT NULL,
    "vehicleId" UUID NOT NULL,
    "washOrderId" UUID,
    "eventType" "LoyaltyEventType" NOT NULL,
    "periodMonth" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdById" UUID NOT NULL,
    "deviceId" UUID,
    "notes" TEXT,

    CONSTRAINT "loyalty_ledger_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "loyalty_rewards" (
    "id" UUID NOT NULL,
    "vehicleId" UUID NOT NULL,
    "earnedMonth" TIMESTAMP(3) NOT NULL,
    "validMonth" TIMESTAMP(3) NOT NULL,
    "status" "RewardStatus" NOT NULL DEFAULT 'AVAILABLE',
    "earnedFromLedgerId" UUID NOT NULL,
    "redeemedWashOrderId" UUID,
    "redeemedAt" TIMESTAMP(3),
    "expiredAt" TIMESTAMP(3),

    CONSTRAINT "loyalty_rewards_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "prepaid_wallets" (
    "id" UUID NOT NULL,
    "customerId" UUID NOT NULL,
    "balance" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "currency" TEXT NOT NULL DEFAULT 'LSL',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "prepaid_wallets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "prepaid_wallet_ledger" (
    "id" UUID NOT NULL,
    "walletId" UUID NOT NULL,
    "entryType" "WalletLedgerEntryType" NOT NULL,
    "amount" DECIMAL(12,2) NOT NULL,
    "balanceAfter" DECIMAL(12,2) NOT NULL,
    "method" "PaymentMethodCode",
    "reference" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdById" UUID NOT NULL,
    "deviceId" UUID,
    "clientEntryId" TEXT NOT NULL,

    CONSTRAINT "prepaid_wallet_ledger_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "prepaid_packages" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "eligibleTiers" TEXT[],
    "washCount" INTEGER NOT NULL,
    "price" DECIMAL(12,2) NOT NULL,
    "validityDays" INTEGER NOT NULL,
    "applicableScope" "PackageScope" NOT NULL DEFAULT 'ANY_VEHICLE_OF_CUSTOMER',
    "active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "prepaid_packages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "prepaid_package_purchases" (
    "id" UUID NOT NULL,
    "packageId" UUID NOT NULL,
    "customerId" UUID NOT NULL,
    "vehicleId" UUID,
    "purchasedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "remainingCount" INTEGER NOT NULL,
    "purchasePaymentId" UUID,

    CONSTRAINT "prepaid_package_purchases_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "prepaid_package_usage" (
    "id" UUID NOT NULL,
    "purchaseId" UUID NOT NULL,
    "washOrderId" UUID NOT NULL,
    "vehicleId" UUID NOT NULL,
    "usedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "usedById" UUID NOT NULL,
    "clientEntryId" TEXT NOT NULL,

    CONSTRAINT "prepaid_package_usage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sms_messages" (
    "id" UUID NOT NULL,
    "messageKey" TEXT NOT NULL,
    "customerId" UUID,
    "washOrderId" UUID,
    "phone" TEXT NOT NULL,
    "templateCode" TEXT NOT NULL,
    "renderedBody" TEXT NOT NULL,
    "status" "SmsStatus" NOT NULL DEFAULT 'QUEUED',
    "attemptCount" INTEGER NOT NULL DEFAULT 0,
    "nextAttemptAt" TIMESTAMP(3),
    "providerMessageId" TEXT,
    "lastError" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "sms_messages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cash_collections" (
    "id" UUID NOT NULL,
    "branchId" UUID NOT NULL,
    "periodStartAt" TIMESTAMP(3) NOT NULL,
    "periodEndAt" TIMESTAMP(3) NOT NULL,
    "expectedCash" DECIMAL(12,2) NOT NULL,
    "countedCash" DECIMAL(12,2) NOT NULL,
    "variance" DECIMAL(12,2) NOT NULL,
    "result" "CollectionResult" NOT NULL,
    "varianceReason" TEXT,
    "collectedById" UUID NOT NULL,
    "approvedById" UUID,
    "witness" TEXT,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "reversedByCollectionId" UUID,

    CONSTRAINT "cash_collections_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "expense_categories" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "expense_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "expenses" (
    "id" UUID NOT NULL,
    "branchId" UUID NOT NULL,
    "categoryId" UUID NOT NULL,
    "description" TEXT NOT NULL,
    "amount" DECIMAL(12,2) NOT NULL,
    "paymentMethod" "ExpensePaymentMethod" NOT NULL,
    "receiptFilePath" TEXT,
    "createdById" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "reversedByExpenseId" UUID,

    CONSTRAINT "expenses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sync_batches" (
    "id" UUID NOT NULL,
    "deviceId" UUID NOT NULL,
    "submittedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "recordCount" INTEGER NOT NULL,
    "status" "SyncBatchStatus" NOT NULL,
    "submittedById" UUID NOT NULL,

    CONSTRAINT "sync_batches_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sync_conflicts" (
    "id" UUID NOT NULL,
    "syncBatchId" UUID NOT NULL,
    "entityType" TEXT NOT NULL,
    "entityId" TEXT NOT NULL,
    "conflictType" "ConflictType" NOT NULL,
    "payloadSnapshot" JSONB NOT NULL,
    "status" "ConflictStatus" NOT NULL DEFAULT 'PENDING',
    "resolvedById" UUID,
    "resolvedAt" TIMESTAMP(3),
    "resolutionNotes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "sync_conflicts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "backup_runs" (
    "id" UUID NOT NULL,
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "finishedAt" TIMESTAMP(3),
    "status" "BackupStatus" NOT NULL DEFAULT 'RUNNING',
    "fileName" TEXT,
    "fileSizeBytes" BIGINT,
    "sha256Checksum" TEXT,
    "driveFileId" TEXT,
    "errorMessage" TEXT,
    "retentionExpiresAt" TIMESTAMP(3),

    CONSTRAINT "backup_runs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" UUID NOT NULL,
    "branchId" UUID,
    "userId" UUID,
    "deviceId" UUID,
    "action" TEXT NOT NULL,
    "entityType" TEXT NOT NULL,
    "entityId" TEXT,
    "beforeSnapshot" JSONB,
    "afterSnapshot" JSONB,
    "ipAddress" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "idempotency_keys" (
    "key" TEXT NOT NULL,
    "endpoint" TEXT NOT NULL,
    "requestHash" TEXT NOT NULL,
    "status" "IdempotencyStatus" NOT NULL DEFAULT 'IN_PROGRESS',
    "responseSnapshot" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completedAt" TIMESTAMP(3),

    CONSTRAINT "idempotency_keys_pkey" PRIMARY KEY ("key")
);

-- CreateIndex
CREATE UNIQUE INDEX "branches_code_key" ON "branches"("code");

-- CreateIndex
CREATE UNIQUE INDEX "roles_name_key" ON "roles"("name");

-- CreateIndex
CREATE UNIQUE INDEX "permissions_key_key" ON "permissions"("key");

-- CreateIndex
CREATE UNIQUE INDEX "users_username_key" ON "users"("username");

-- CreateIndex
CREATE UNIQUE INDEX "refresh_tokens_tokenHash_key" ON "refresh_tokens"("tokenHash");

-- CreateIndex
CREATE UNIQUE INDEX "devices_installId_key" ON "devices"("installId");

-- CreateIndex
CREATE UNIQUE INDEX "customers_branchId_phone_key" ON "customers"("branchId", "phone");

-- CreateIndex
CREATE UNIQUE INDEX "vehicles_regNumberNormalized_key" ON "vehicles"("regNumberNormalized");

-- CreateIndex
CREATE INDEX "wash_orders_branchId_status_idx" ON "wash_orders"("branchId", "status");

-- CreateIndex
CREATE INDEX "wash_orders_vehicleId_idx" ON "wash_orders"("vehicleId");

-- CreateIndex
CREATE UNIQUE INDEX "payment_methods_code_key" ON "payment_methods"("code");

-- CreateIndex
CREATE UNIQUE INDEX "payments_washOrderId_key" ON "payments"("washOrderId");

-- CreateIndex
CREATE UNIQUE INDEX "payment_components_walletLedgerId_key" ON "payment_components"("walletLedgerId");

-- CreateIndex
CREATE UNIQUE INDEX "payment_components_packageUsageId_key" ON "payment_components"("packageUsageId");

-- CreateIndex
CREATE UNIQUE INDEX "payment_components_loyaltyRewardId_key" ON "payment_components"("loyaltyRewardId");

-- CreateIndex
CREATE INDEX "loyalty_ledger_vehicleId_periodMonth_eventType_idx" ON "loyalty_ledger"("vehicleId", "periodMonth", "eventType");

-- CreateIndex
CREATE UNIQUE INDEX "loyalty_ledger_washOrderId_eventType_key" ON "loyalty_ledger"("washOrderId", "eventType");

-- CreateIndex
CREATE UNIQUE INDEX "loyalty_rewards_earnedFromLedgerId_key" ON "loyalty_rewards"("earnedFromLedgerId");

-- CreateIndex
CREATE INDEX "loyalty_rewards_vehicleId_validMonth_status_idx" ON "loyalty_rewards"("vehicleId", "validMonth", "status");

-- CreateIndex
CREATE UNIQUE INDEX "prepaid_wallets_customerId_key" ON "prepaid_wallets"("customerId");

-- CreateIndex
CREATE UNIQUE INDEX "prepaid_wallet_ledger_clientEntryId_key" ON "prepaid_wallet_ledger"("clientEntryId");

-- CreateIndex
CREATE UNIQUE INDEX "prepaid_package_usage_clientEntryId_key" ON "prepaid_package_usage"("clientEntryId");

-- CreateIndex
CREATE UNIQUE INDEX "sms_messages_messageKey_key" ON "sms_messages"("messageKey");

-- CreateIndex
CREATE UNIQUE INDEX "cash_collections_reversedByCollectionId_key" ON "cash_collections"("reversedByCollectionId");

-- CreateIndex
CREATE UNIQUE INDEX "expense_categories_name_key" ON "expense_categories"("name");

-- CreateIndex
CREATE UNIQUE INDEX "expenses_reversedByExpenseId_key" ON "expenses"("reversedByExpenseId");

-- CreateIndex
CREATE INDEX "audit_logs_entityType_entityId_idx" ON "audit_logs"("entityType", "entityId");

-- CreateIndex
CREATE INDEX "audit_logs_userId_createdAt_idx" ON "audit_logs"("userId", "createdAt");

-- AddForeignKey
ALTER TABLE "role_permissions" ADD CONSTRAINT "role_permissions_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "role_permissions" ADD CONSTRAINT "role_permissions_permissionId_fkey" FOREIGN KEY ("permissionId") REFERENCES "permissions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_branchId_fkey" FOREIGN KEY ("branchId") REFERENCES "branches"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refresh_tokens" ADD CONSTRAINT "refresh_tokens_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "devices" ADD CONSTRAINT "devices_branchId_fkey" FOREIGN KEY ("branchId") REFERENCES "branches"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "devices" ADD CONSTRAINT "devices_registeredById_fkey" FOREIGN KEY ("registeredById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "customers" ADD CONSTRAINT "customers_branchId_fkey" FOREIGN KEY ("branchId") REFERENCES "branches"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vehicles" ADD CONSTRAINT "vehicles_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "customers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wash_orders" ADD CONSTRAINT "wash_orders_branchId_fkey" FOREIGN KEY ("branchId") REFERENCES "branches"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wash_orders" ADD CONSTRAINT "wash_orders_vehicleId_fkey" FOREIGN KEY ("vehicleId") REFERENCES "vehicles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wash_orders" ADD CONSTRAINT "wash_orders_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "customers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wash_orders" ADD CONSTRAINT "wash_orders_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wash_orders" ADD CONSTRAINT "wash_orders_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES "devices"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wash_order_items" ADD CONSTRAINT "wash_order_items_washOrderId_fkey" FOREIGN KEY ("washOrderId") REFERENCES "wash_orders"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wash_order_items" ADD CONSTRAINT "wash_order_items_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "wash_services"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wash_order_items" ADD CONSTRAINT "wash_order_items_extraId_fkey" FOREIGN KEY ("extraId") REFERENCES "wash_extras"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wash_status_history" ADD CONSTRAINT "wash_status_history_washOrderId_fkey" FOREIGN KEY ("washOrderId") REFERENCES "wash_orders"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wash_status_history" ADD CONSTRAINT "wash_status_history_changedById_fkey" FOREIGN KEY ("changedById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wash_status_history" ADD CONSTRAINT "wash_status_history_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES "devices"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_washOrderId_fkey" FOREIGN KEY ("washOrderId") REFERENCES "wash_orders"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES "devices"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_components" ADD CONSTRAINT "payment_components_paymentId_fkey" FOREIGN KEY ("paymentId") REFERENCES "payments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_components" ADD CONSTRAINT "payment_components_paymentMethodId_fkey" FOREIGN KEY ("paymentMethodId") REFERENCES "payment_methods"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_components" ADD CONSTRAINT "payment_components_walletLedgerId_fkey" FOREIGN KEY ("walletLedgerId") REFERENCES "prepaid_wallet_ledger"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_components" ADD CONSTRAINT "payment_components_packageUsageId_fkey" FOREIGN KEY ("packageUsageId") REFERENCES "prepaid_package_usage"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_components" ADD CONSTRAINT "payment_components_loyaltyRewardId_fkey" FOREIGN KEY ("loyaltyRewardId") REFERENCES "loyalty_rewards"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "loyalty_ledger" ADD CONSTRAINT "loyalty_ledger_vehicleId_fkey" FOREIGN KEY ("vehicleId") REFERENCES "vehicles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "loyalty_ledger" ADD CONSTRAINT "loyalty_ledger_washOrderId_fkey" FOREIGN KEY ("washOrderId") REFERENCES "wash_orders"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "loyalty_ledger" ADD CONSTRAINT "loyalty_ledger_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "loyalty_ledger" ADD CONSTRAINT "loyalty_ledger_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES "devices"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "loyalty_rewards" ADD CONSTRAINT "loyalty_rewards_vehicleId_fkey" FOREIGN KEY ("vehicleId") REFERENCES "vehicles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "loyalty_rewards" ADD CONSTRAINT "loyalty_rewards_earnedFromLedgerId_fkey" FOREIGN KEY ("earnedFromLedgerId") REFERENCES "loyalty_ledger"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prepaid_wallets" ADD CONSTRAINT "prepaid_wallets_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "customers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prepaid_wallet_ledger" ADD CONSTRAINT "prepaid_wallet_ledger_walletId_fkey" FOREIGN KEY ("walletId") REFERENCES "prepaid_wallets"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prepaid_wallet_ledger" ADD CONSTRAINT "prepaid_wallet_ledger_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prepaid_wallet_ledger" ADD CONSTRAINT "prepaid_wallet_ledger_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES "devices"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prepaid_package_purchases" ADD CONSTRAINT "prepaid_package_purchases_packageId_fkey" FOREIGN KEY ("packageId") REFERENCES "prepaid_packages"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prepaid_package_purchases" ADD CONSTRAINT "prepaid_package_purchases_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "customers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prepaid_package_purchases" ADD CONSTRAINT "prepaid_package_purchases_vehicleId_fkey" FOREIGN KEY ("vehicleId") REFERENCES "vehicles"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prepaid_package_usage" ADD CONSTRAINT "prepaid_package_usage_purchaseId_fkey" FOREIGN KEY ("purchaseId") REFERENCES "prepaid_package_purchases"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prepaid_package_usage" ADD CONSTRAINT "prepaid_package_usage_washOrderId_fkey" FOREIGN KEY ("washOrderId") REFERENCES "wash_orders"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prepaid_package_usage" ADD CONSTRAINT "prepaid_package_usage_vehicleId_fkey" FOREIGN KEY ("vehicleId") REFERENCES "vehicles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prepaid_package_usage" ADD CONSTRAINT "prepaid_package_usage_usedById_fkey" FOREIGN KEY ("usedById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sms_messages" ADD CONSTRAINT "sms_messages_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "customers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sms_messages" ADD CONSTRAINT "sms_messages_washOrderId_fkey" FOREIGN KEY ("washOrderId") REFERENCES "wash_orders"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cash_collections" ADD CONSTRAINT "cash_collections_branchId_fkey" FOREIGN KEY ("branchId") REFERENCES "branches"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cash_collections" ADD CONSTRAINT "cash_collections_collectedById_fkey" FOREIGN KEY ("collectedById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cash_collections" ADD CONSTRAINT "cash_collections_approvedById_fkey" FOREIGN KEY ("approvedById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cash_collections" ADD CONSTRAINT "cash_collections_reversedByCollectionId_fkey" FOREIGN KEY ("reversedByCollectionId") REFERENCES "cash_collections"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expenses" ADD CONSTRAINT "expenses_branchId_fkey" FOREIGN KEY ("branchId") REFERENCES "branches"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expenses" ADD CONSTRAINT "expenses_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "expense_categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expenses" ADD CONSTRAINT "expenses_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expenses" ADD CONSTRAINT "expenses_reversedByExpenseId_fkey" FOREIGN KEY ("reversedByExpenseId") REFERENCES "expenses"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sync_batches" ADD CONSTRAINT "sync_batches_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES "devices"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sync_batches" ADD CONSTRAINT "sync_batches_submittedById_fkey" FOREIGN KEY ("submittedById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sync_conflicts" ADD CONSTRAINT "sync_conflicts_syncBatchId_fkey" FOREIGN KEY ("syncBatchId") REFERENCES "sync_batches"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sync_conflicts" ADD CONSTRAINT "sync_conflicts_resolvedById_fkey" FOREIGN KEY ("resolvedById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_branchId_fkey" FOREIGN KEY ("branchId") REFERENCES "branches"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES "devices"("id") ON DELETE SET NULL ON UPDATE CASCADE;

