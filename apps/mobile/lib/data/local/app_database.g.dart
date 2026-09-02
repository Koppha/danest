// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalWashServicesTable extends LocalWashServices
    with TableInfo<$LocalWashServicesTable, LocalWashService> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalWashServicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tierMeta = const VerificationMeta('tier');
  @override
  late final GeneratedColumn<String> tier = GeneratedColumn<String>(
    'tier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _basePriceMeta = const VerificationMeta(
    'basePrice',
  );
  @override
  late final GeneratedColumn<int> basePrice = GeneratedColumn<int>(
    'base_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    tier,
    basePrice,
    durationMinutes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_wash_services';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalWashService> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('tier')) {
      context.handle(
        _tierMeta,
        tier.isAcceptableOrUnknown(data['tier']!, _tierMeta),
      );
    } else if (isInserting) {
      context.missing(_tierMeta);
    }
    if (data.containsKey('base_price')) {
      context.handle(
        _basePriceMeta,
        basePrice.isAcceptableOrUnknown(data['base_price']!, _basePriceMeta),
      );
    } else if (isInserting) {
      context.missing(_basePriceMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalWashService map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalWashService(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      tier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tier'],
      )!,
      basePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_price'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
    );
  }

  @override
  $LocalWashServicesTable createAlias(String alias) {
    return $LocalWashServicesTable(attachedDatabase, alias);
  }
}

class LocalWashService extends DataClass
    implements Insertable<LocalWashService> {
  final String id;
  final String name;
  final String tier;
  final int basePrice;
  final int durationMinutes;
  const LocalWashService({
    required this.id,
    required this.name,
    required this.tier,
    required this.basePrice,
    required this.durationMinutes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['tier'] = Variable<String>(tier);
    map['base_price'] = Variable<int>(basePrice);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    return map;
  }

  LocalWashServicesCompanion toCompanion(bool nullToAbsent) {
    return LocalWashServicesCompanion(
      id: Value(id),
      name: Value(name),
      tier: Value(tier),
      basePrice: Value(basePrice),
      durationMinutes: Value(durationMinutes),
    );
  }

  factory LocalWashService.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalWashService(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      tier: serializer.fromJson<String>(json['tier']),
      basePrice: serializer.fromJson<int>(json['basePrice']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'tier': serializer.toJson<String>(tier),
      'basePrice': serializer.toJson<int>(basePrice),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
    };
  }

  LocalWashService copyWith({
    String? id,
    String? name,
    String? tier,
    int? basePrice,
    int? durationMinutes,
  }) => LocalWashService(
    id: id ?? this.id,
    name: name ?? this.name,
    tier: tier ?? this.tier,
    basePrice: basePrice ?? this.basePrice,
    durationMinutes: durationMinutes ?? this.durationMinutes,
  );
  LocalWashService copyWithCompanion(LocalWashServicesCompanion data) {
    return LocalWashService(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      tier: data.tier.present ? data.tier.value : this.tier,
      basePrice: data.basePrice.present ? data.basePrice.value : this.basePrice,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalWashService(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('tier: $tier, ')
          ..write('basePrice: $basePrice, ')
          ..write('durationMinutes: $durationMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, tier, basePrice, durationMinutes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalWashService &&
          other.id == this.id &&
          other.name == this.name &&
          other.tier == this.tier &&
          other.basePrice == this.basePrice &&
          other.durationMinutes == this.durationMinutes);
}

class LocalWashServicesCompanion extends UpdateCompanion<LocalWashService> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> tier;
  final Value<int> basePrice;
  final Value<int> durationMinutes;
  final Value<int> rowid;
  const LocalWashServicesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.tier = const Value.absent(),
    this.basePrice = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalWashServicesCompanion.insert({
    required String id,
    required String name,
    required String tier,
    required int basePrice,
    required int durationMinutes,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       tier = Value(tier),
       basePrice = Value(basePrice),
       durationMinutes = Value(durationMinutes);
  static Insertable<LocalWashService> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? tier,
    Expression<int>? basePrice,
    Expression<int>? durationMinutes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (tier != null) 'tier': tier,
      if (basePrice != null) 'base_price': basePrice,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalWashServicesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? tier,
    Value<int>? basePrice,
    Value<int>? durationMinutes,
    Value<int>? rowid,
  }) {
    return LocalWashServicesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      tier: tier ?? this.tier,
      basePrice: basePrice ?? this.basePrice,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (tier.present) {
      map['tier'] = Variable<String>(tier.value);
    }
    if (basePrice.present) {
      map['base_price'] = Variable<int>(basePrice.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalWashServicesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('tier: $tier, ')
          ..write('basePrice: $basePrice, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalWashExtrasTable extends LocalWashExtras
    with TableInfo<$LocalWashExtrasTable, LocalWashExtra> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalWashExtrasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int> price = GeneratedColumn<int>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, price];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_wash_extras';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalWashExtra> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalWashExtra map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalWashExtra(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price'],
      )!,
    );
  }

  @override
  $LocalWashExtrasTable createAlias(String alias) {
    return $LocalWashExtrasTable(attachedDatabase, alias);
  }
}

class LocalWashExtra extends DataClass implements Insertable<LocalWashExtra> {
  final String id;
  final String name;
  final int price;
  const LocalWashExtra({
    required this.id,
    required this.name,
    required this.price,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['price'] = Variable<int>(price);
    return map;
  }

  LocalWashExtrasCompanion toCompanion(bool nullToAbsent) {
    return LocalWashExtrasCompanion(
      id: Value(id),
      name: Value(name),
      price: Value(price),
    );
  }

  factory LocalWashExtra.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalWashExtra(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      price: serializer.fromJson<int>(json['price']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'price': serializer.toJson<int>(price),
    };
  }

  LocalWashExtra copyWith({String? id, String? name, int? price}) =>
      LocalWashExtra(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
      );
  LocalWashExtra copyWithCompanion(LocalWashExtrasCompanion data) {
    return LocalWashExtra(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      price: data.price.present ? data.price.value : this.price,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalWashExtra(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, price);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalWashExtra &&
          other.id == this.id &&
          other.name == this.name &&
          other.price == this.price);
}

class LocalWashExtrasCompanion extends UpdateCompanion<LocalWashExtra> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> price;
  final Value<int> rowid;
  const LocalWashExtrasCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalWashExtrasCompanion.insert({
    required String id,
    required String name,
    required int price,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       price = Value(price);
  static Insertable<LocalWashExtra> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? price,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalWashExtrasCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? price,
    Value<int>? rowid,
  }) {
    return LocalWashExtrasCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalWashExtrasCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalCustomersTable extends LocalCustomers
    with TableInfo<$LocalCustomersTable, LocalCustomer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalCustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _branchIdMeta = const VerificationMeta(
    'branchId',
  );
  @override
  late final GeneratedColumn<String> branchId = GeneratedColumn<String>(
    'branch_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _altPhoneMeta = const VerificationMeta(
    'altPhone',
  );
  @override
  late final GeneratedColumn<String> altPhone = GeneratedColumn<String>(
    'alt_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    branchId,
    fullName,
    phone,
    altPhone,
    notes,
    dirty,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalCustomer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('branch_id')) {
      context.handle(
        _branchIdMeta,
        branchId.isAcceptableOrUnknown(data['branch_id']!, _branchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('alt_phone')) {
      context.handle(
        _altPhoneMeta,
        altPhone.isAcceptableOrUnknown(data['alt_phone']!, _altPhoneMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalCustomer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalCustomer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      branchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch_id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      altPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alt_phone'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
    );
  }

  @override
  $LocalCustomersTable createAlias(String alias) {
    return $LocalCustomersTable(attachedDatabase, alias);
  }
}

class LocalCustomer extends DataClass implements Insertable<LocalCustomer> {
  final String id;
  final String branchId;
  final String fullName;
  final String phone;
  final String? altPhone;
  final String? notes;
  final bool dirty;
  const LocalCustomer({
    required this.id,
    required this.branchId,
    required this.fullName,
    required this.phone,
    this.altPhone,
    this.notes,
    required this.dirty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['branch_id'] = Variable<String>(branchId);
    map['full_name'] = Variable<String>(fullName);
    map['phone'] = Variable<String>(phone);
    if (!nullToAbsent || altPhone != null) {
      map['alt_phone'] = Variable<String>(altPhone);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['dirty'] = Variable<bool>(dirty);
    return map;
  }

  LocalCustomersCompanion toCompanion(bool nullToAbsent) {
    return LocalCustomersCompanion(
      id: Value(id),
      branchId: Value(branchId),
      fullName: Value(fullName),
      phone: Value(phone),
      altPhone: altPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(altPhone),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      dirty: Value(dirty),
    );
  }

  factory LocalCustomer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalCustomer(
      id: serializer.fromJson<String>(json['id']),
      branchId: serializer.fromJson<String>(json['branchId']),
      fullName: serializer.fromJson<String>(json['fullName']),
      phone: serializer.fromJson<String>(json['phone']),
      altPhone: serializer.fromJson<String?>(json['altPhone']),
      notes: serializer.fromJson<String?>(json['notes']),
      dirty: serializer.fromJson<bool>(json['dirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'branchId': serializer.toJson<String>(branchId),
      'fullName': serializer.toJson<String>(fullName),
      'phone': serializer.toJson<String>(phone),
      'altPhone': serializer.toJson<String?>(altPhone),
      'notes': serializer.toJson<String?>(notes),
      'dirty': serializer.toJson<bool>(dirty),
    };
  }

  LocalCustomer copyWith({
    String? id,
    String? branchId,
    String? fullName,
    String? phone,
    Value<String?> altPhone = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? dirty,
  }) => LocalCustomer(
    id: id ?? this.id,
    branchId: branchId ?? this.branchId,
    fullName: fullName ?? this.fullName,
    phone: phone ?? this.phone,
    altPhone: altPhone.present ? altPhone.value : this.altPhone,
    notes: notes.present ? notes.value : this.notes,
    dirty: dirty ?? this.dirty,
  );
  LocalCustomer copyWithCompanion(LocalCustomersCompanion data) {
    return LocalCustomer(
      id: data.id.present ? data.id.value : this.id,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      phone: data.phone.present ? data.phone.value : this.phone,
      altPhone: data.altPhone.present ? data.altPhone.value : this.altPhone,
      notes: data.notes.present ? data.notes.value : this.notes,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalCustomer(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('fullName: $fullName, ')
          ..write('phone: $phone, ')
          ..write('altPhone: $altPhone, ')
          ..write('notes: $notes, ')
          ..write('dirty: $dirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, branchId, fullName, phone, altPhone, notes, dirty);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalCustomer &&
          other.id == this.id &&
          other.branchId == this.branchId &&
          other.fullName == this.fullName &&
          other.phone == this.phone &&
          other.altPhone == this.altPhone &&
          other.notes == this.notes &&
          other.dirty == this.dirty);
}

class LocalCustomersCompanion extends UpdateCompanion<LocalCustomer> {
  final Value<String> id;
  final Value<String> branchId;
  final Value<String> fullName;
  final Value<String> phone;
  final Value<String?> altPhone;
  final Value<String?> notes;
  final Value<bool> dirty;
  final Value<int> rowid;
  const LocalCustomersCompanion({
    this.id = const Value.absent(),
    this.branchId = const Value.absent(),
    this.fullName = const Value.absent(),
    this.phone = const Value.absent(),
    this.altPhone = const Value.absent(),
    this.notes = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalCustomersCompanion.insert({
    required String id,
    required String branchId,
    required String fullName,
    required String phone,
    this.altPhone = const Value.absent(),
    this.notes = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       branchId = Value(branchId),
       fullName = Value(fullName),
       phone = Value(phone);
  static Insertable<LocalCustomer> custom({
    Expression<String>? id,
    Expression<String>? branchId,
    Expression<String>? fullName,
    Expression<String>? phone,
    Expression<String>? altPhone,
    Expression<String>? notes,
    Expression<bool>? dirty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (branchId != null) 'branch_id': branchId,
      if (fullName != null) 'full_name': fullName,
      if (phone != null) 'phone': phone,
      if (altPhone != null) 'alt_phone': altPhone,
      if (notes != null) 'notes': notes,
      if (dirty != null) 'dirty': dirty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalCustomersCompanion copyWith({
    Value<String>? id,
    Value<String>? branchId,
    Value<String>? fullName,
    Value<String>? phone,
    Value<String?>? altPhone,
    Value<String?>? notes,
    Value<bool>? dirty,
    Value<int>? rowid,
  }) {
    return LocalCustomersCompanion(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      altPhone: altPhone ?? this.altPhone,
      notes: notes ?? this.notes,
      dirty: dirty ?? this.dirty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<String>(branchId.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (altPhone.present) {
      map['alt_phone'] = Variable<String>(altPhone.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalCustomersCompanion(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('fullName: $fullName, ')
          ..write('phone: $phone, ')
          ..write('altPhone: $altPhone, ')
          ..write('notes: $notes, ')
          ..write('dirty: $dirty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalVehiclesTable extends LocalVehicles
    with TableInfo<$LocalVehiclesTable, LocalVehicle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalVehiclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _regNumberNormalizedMeta =
      const VerificationMeta('regNumberNormalized');
  @override
  late final GeneratedColumn<String> regNumberNormalized =
      GeneratedColumn<String>(
        'reg_number_normalized',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _regNumberDisplayMeta = const VerificationMeta(
    'regNumberDisplay',
  );
  @override
  late final GeneratedColumn<String> regNumberDisplay = GeneratedColumn<String>(
    'reg_number_display',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _makeMeta = const VerificationMeta('make');
  @override
  late final GeneratedColumn<String> make = GeneratedColumn<String>(
    'make',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colourMeta = const VerificationMeta('colour');
  @override
  late final GeneratedColumn<String> colour = GeneratedColumn<String>(
    'colour',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vehicleTypeMeta = const VerificationMeta(
    'vehicleType',
  );
  @override
  late final GeneratedColumn<String> vehicleType = GeneratedColumn<String>(
    'vehicle_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('SEDAN'),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerId,
    regNumberNormalized,
    regNumberDisplay,
    make,
    model,
    colour,
    vehicleType,
    dirty,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_vehicles';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalVehicle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('reg_number_normalized')) {
      context.handle(
        _regNumberNormalizedMeta,
        regNumberNormalized.isAcceptableOrUnknown(
          data['reg_number_normalized']!,
          _regNumberNormalizedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_regNumberNormalizedMeta);
    }
    if (data.containsKey('reg_number_display')) {
      context.handle(
        _regNumberDisplayMeta,
        regNumberDisplay.isAcceptableOrUnknown(
          data['reg_number_display']!,
          _regNumberDisplayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_regNumberDisplayMeta);
    }
    if (data.containsKey('make')) {
      context.handle(
        _makeMeta,
        make.isAcceptableOrUnknown(data['make']!, _makeMeta),
      );
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    }
    if (data.containsKey('colour')) {
      context.handle(
        _colourMeta,
        colour.isAcceptableOrUnknown(data['colour']!, _colourMeta),
      );
    }
    if (data.containsKey('vehicle_type')) {
      context.handle(
        _vehicleTypeMeta,
        vehicleType.isAcceptableOrUnknown(
          data['vehicle_type']!,
          _vehicleTypeMeta,
        ),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalVehicle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalVehicle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      regNumberNormalized: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reg_number_normalized'],
      )!,
      regNumberDisplay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reg_number_display'],
      )!,
      make: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}make'],
      ),
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      ),
      colour: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}colour'],
      ),
      vehicleType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_type'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
    );
  }

  @override
  $LocalVehiclesTable createAlias(String alias) {
    return $LocalVehiclesTable(attachedDatabase, alias);
  }
}

class LocalVehicle extends DataClass implements Insertable<LocalVehicle> {
  final String id;
  final String customerId;
  final String regNumberNormalized;
  final String regNumberDisplay;
  final String? make;
  final String? model;
  final String? colour;
  final String vehicleType;
  final bool dirty;
  const LocalVehicle({
    required this.id,
    required this.customerId,
    required this.regNumberNormalized,
    required this.regNumberDisplay,
    this.make,
    this.model,
    this.colour,
    required this.vehicleType,
    required this.dirty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['customer_id'] = Variable<String>(customerId);
    map['reg_number_normalized'] = Variable<String>(regNumberNormalized);
    map['reg_number_display'] = Variable<String>(regNumberDisplay);
    if (!nullToAbsent || make != null) {
      map['make'] = Variable<String>(make);
    }
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    if (!nullToAbsent || colour != null) {
      map['colour'] = Variable<String>(colour);
    }
    map['vehicle_type'] = Variable<String>(vehicleType);
    map['dirty'] = Variable<bool>(dirty);
    return map;
  }

  LocalVehiclesCompanion toCompanion(bool nullToAbsent) {
    return LocalVehiclesCompanion(
      id: Value(id),
      customerId: Value(customerId),
      regNumberNormalized: Value(regNumberNormalized),
      regNumberDisplay: Value(regNumberDisplay),
      make: make == null && nullToAbsent ? const Value.absent() : Value(make),
      model: model == null && nullToAbsent
          ? const Value.absent()
          : Value(model),
      colour: colour == null && nullToAbsent
          ? const Value.absent()
          : Value(colour),
      vehicleType: Value(vehicleType),
      dirty: Value(dirty),
    );
  }

  factory LocalVehicle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalVehicle(
      id: serializer.fromJson<String>(json['id']),
      customerId: serializer.fromJson<String>(json['customerId']),
      regNumberNormalized: serializer.fromJson<String>(
        json['regNumberNormalized'],
      ),
      regNumberDisplay: serializer.fromJson<String>(json['regNumberDisplay']),
      make: serializer.fromJson<String?>(json['make']),
      model: serializer.fromJson<String?>(json['model']),
      colour: serializer.fromJson<String?>(json['colour']),
      vehicleType: serializer.fromJson<String>(json['vehicleType']),
      dirty: serializer.fromJson<bool>(json['dirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerId': serializer.toJson<String>(customerId),
      'regNumberNormalized': serializer.toJson<String>(regNumberNormalized),
      'regNumberDisplay': serializer.toJson<String>(regNumberDisplay),
      'make': serializer.toJson<String?>(make),
      'model': serializer.toJson<String?>(model),
      'colour': serializer.toJson<String?>(colour),
      'vehicleType': serializer.toJson<String>(vehicleType),
      'dirty': serializer.toJson<bool>(dirty),
    };
  }

  LocalVehicle copyWith({
    String? id,
    String? customerId,
    String? regNumberNormalized,
    String? regNumberDisplay,
    Value<String?> make = const Value.absent(),
    Value<String?> model = const Value.absent(),
    Value<String?> colour = const Value.absent(),
    String? vehicleType,
    bool? dirty,
  }) => LocalVehicle(
    id: id ?? this.id,
    customerId: customerId ?? this.customerId,
    regNumberNormalized: regNumberNormalized ?? this.regNumberNormalized,
    regNumberDisplay: regNumberDisplay ?? this.regNumberDisplay,
    make: make.present ? make.value : this.make,
    model: model.present ? model.value : this.model,
    colour: colour.present ? colour.value : this.colour,
    vehicleType: vehicleType ?? this.vehicleType,
    dirty: dirty ?? this.dirty,
  );
  LocalVehicle copyWithCompanion(LocalVehiclesCompanion data) {
    return LocalVehicle(
      id: data.id.present ? data.id.value : this.id,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      regNumberNormalized: data.regNumberNormalized.present
          ? data.regNumberNormalized.value
          : this.regNumberNormalized,
      regNumberDisplay: data.regNumberDisplay.present
          ? data.regNumberDisplay.value
          : this.regNumberDisplay,
      make: data.make.present ? data.make.value : this.make,
      model: data.model.present ? data.model.value : this.model,
      colour: data.colour.present ? data.colour.value : this.colour,
      vehicleType: data.vehicleType.present
          ? data.vehicleType.value
          : this.vehicleType,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalVehicle(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('regNumberNormalized: $regNumberNormalized, ')
          ..write('regNumberDisplay: $regNumberDisplay, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('colour: $colour, ')
          ..write('vehicleType: $vehicleType, ')
          ..write('dirty: $dirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerId,
    regNumberNormalized,
    regNumberDisplay,
    make,
    model,
    colour,
    vehicleType,
    dirty,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalVehicle &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.regNumberNormalized == this.regNumberNormalized &&
          other.regNumberDisplay == this.regNumberDisplay &&
          other.make == this.make &&
          other.model == this.model &&
          other.colour == this.colour &&
          other.vehicleType == this.vehicleType &&
          other.dirty == this.dirty);
}

class LocalVehiclesCompanion extends UpdateCompanion<LocalVehicle> {
  final Value<String> id;
  final Value<String> customerId;
  final Value<String> regNumberNormalized;
  final Value<String> regNumberDisplay;
  final Value<String?> make;
  final Value<String?> model;
  final Value<String?> colour;
  final Value<String> vehicleType;
  final Value<bool> dirty;
  final Value<int> rowid;
  const LocalVehiclesCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.regNumberNormalized = const Value.absent(),
    this.regNumberDisplay = const Value.absent(),
    this.make = const Value.absent(),
    this.model = const Value.absent(),
    this.colour = const Value.absent(),
    this.vehicleType = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalVehiclesCompanion.insert({
    required String id,
    required String customerId,
    required String regNumberNormalized,
    required String regNumberDisplay,
    this.make = const Value.absent(),
    this.model = const Value.absent(),
    this.colour = const Value.absent(),
    this.vehicleType = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       customerId = Value(customerId),
       regNumberNormalized = Value(regNumberNormalized),
       regNumberDisplay = Value(regNumberDisplay);
  static Insertable<LocalVehicle> custom({
    Expression<String>? id,
    Expression<String>? customerId,
    Expression<String>? regNumberNormalized,
    Expression<String>? regNumberDisplay,
    Expression<String>? make,
    Expression<String>? model,
    Expression<String>? colour,
    Expression<String>? vehicleType,
    Expression<bool>? dirty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (regNumberNormalized != null)
        'reg_number_normalized': regNumberNormalized,
      if (regNumberDisplay != null) 'reg_number_display': regNumberDisplay,
      if (make != null) 'make': make,
      if (model != null) 'model': model,
      if (colour != null) 'colour': colour,
      if (vehicleType != null) 'vehicle_type': vehicleType,
      if (dirty != null) 'dirty': dirty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalVehiclesCompanion copyWith({
    Value<String>? id,
    Value<String>? customerId,
    Value<String>? regNumberNormalized,
    Value<String>? regNumberDisplay,
    Value<String?>? make,
    Value<String?>? model,
    Value<String?>? colour,
    Value<String>? vehicleType,
    Value<bool>? dirty,
    Value<int>? rowid,
  }) {
    return LocalVehiclesCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      regNumberNormalized: regNumberNormalized ?? this.regNumberNormalized,
      regNumberDisplay: regNumberDisplay ?? this.regNumberDisplay,
      make: make ?? this.make,
      model: model ?? this.model,
      colour: colour ?? this.colour,
      vehicleType: vehicleType ?? this.vehicleType,
      dirty: dirty ?? this.dirty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (regNumberNormalized.present) {
      map['reg_number_normalized'] = Variable<String>(
        regNumberNormalized.value,
      );
    }
    if (regNumberDisplay.present) {
      map['reg_number_display'] = Variable<String>(regNumberDisplay.value);
    }
    if (make.present) {
      map['make'] = Variable<String>(make.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (colour.present) {
      map['colour'] = Variable<String>(colour.value);
    }
    if (vehicleType.present) {
      map['vehicle_type'] = Variable<String>(vehicleType.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalVehiclesCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('regNumberNormalized: $regNumberNormalized, ')
          ..write('regNumberDisplay: $regNumberDisplay, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('colour: $colour, ')
          ..write('vehicleType: $vehicleType, ')
          ..write('dirty: $dirty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalLoyaltySummariesTable extends LocalLoyaltySummaries
    with TableInfo<$LocalLoyaltySummariesTable, LocalLoyaltySummary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalLoyaltySummariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qualifyingCountMeta = const VerificationMeta(
    'qualifyingCount',
  );
  @override
  late final GeneratedColumn<int> qualifyingCount = GeneratedColumn<int>(
    'qualifying_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasAvailableRewardMeta =
      const VerificationMeta('hasAvailableReward');
  @override
  late final GeneratedColumn<bool> hasAvailableReward = GeneratedColumn<bool>(
    'has_available_reward',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_available_reward" IN (0, 1))',
    ),
  );
  static const VerificationMeta _asOfMeta = const VerificationMeta('asOf');
  @override
  late final GeneratedColumn<DateTime> asOf = GeneratedColumn<DateTime>(
    'as_of',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    vehicleId,
    qualifyingCount,
    hasAvailableReward,
    asOf,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_loyalty_summaries';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalLoyaltySummary> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('qualifying_count')) {
      context.handle(
        _qualifyingCountMeta,
        qualifyingCount.isAcceptableOrUnknown(
          data['qualifying_count']!,
          _qualifyingCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_qualifyingCountMeta);
    }
    if (data.containsKey('has_available_reward')) {
      context.handle(
        _hasAvailableRewardMeta,
        hasAvailableReward.isAcceptableOrUnknown(
          data['has_available_reward']!,
          _hasAvailableRewardMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hasAvailableRewardMeta);
    }
    if (data.containsKey('as_of')) {
      context.handle(
        _asOfMeta,
        asOf.isAcceptableOrUnknown(data['as_of']!, _asOfMeta),
      );
    } else if (isInserting) {
      context.missing(_asOfMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {vehicleId};
  @override
  LocalLoyaltySummary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalLoyaltySummary(
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      qualifyingCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qualifying_count'],
      )!,
      hasAvailableReward: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_available_reward'],
      )!,
      asOf: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}as_of'],
      )!,
    );
  }

  @override
  $LocalLoyaltySummariesTable createAlias(String alias) {
    return $LocalLoyaltySummariesTable(attachedDatabase, alias);
  }
}

class LocalLoyaltySummary extends DataClass
    implements Insertable<LocalLoyaltySummary> {
  final String vehicleId;
  final int qualifyingCount;
  final bool hasAvailableReward;
  final DateTime asOf;
  const LocalLoyaltySummary({
    required this.vehicleId,
    required this.qualifyingCount,
    required this.hasAvailableReward,
    required this.asOf,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['qualifying_count'] = Variable<int>(qualifyingCount);
    map['has_available_reward'] = Variable<bool>(hasAvailableReward);
    map['as_of'] = Variable<DateTime>(asOf);
    return map;
  }

  LocalLoyaltySummariesCompanion toCompanion(bool nullToAbsent) {
    return LocalLoyaltySummariesCompanion(
      vehicleId: Value(vehicleId),
      qualifyingCount: Value(qualifyingCount),
      hasAvailableReward: Value(hasAvailableReward),
      asOf: Value(asOf),
    );
  }

  factory LocalLoyaltySummary.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalLoyaltySummary(
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      qualifyingCount: serializer.fromJson<int>(json['qualifyingCount']),
      hasAvailableReward: serializer.fromJson<bool>(json['hasAvailableReward']),
      asOf: serializer.fromJson<DateTime>(json['asOf']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'vehicleId': serializer.toJson<String>(vehicleId),
      'qualifyingCount': serializer.toJson<int>(qualifyingCount),
      'hasAvailableReward': serializer.toJson<bool>(hasAvailableReward),
      'asOf': serializer.toJson<DateTime>(asOf),
    };
  }

  LocalLoyaltySummary copyWith({
    String? vehicleId,
    int? qualifyingCount,
    bool? hasAvailableReward,
    DateTime? asOf,
  }) => LocalLoyaltySummary(
    vehicleId: vehicleId ?? this.vehicleId,
    qualifyingCount: qualifyingCount ?? this.qualifyingCount,
    hasAvailableReward: hasAvailableReward ?? this.hasAvailableReward,
    asOf: asOf ?? this.asOf,
  );
  LocalLoyaltySummary copyWithCompanion(LocalLoyaltySummariesCompanion data) {
    return LocalLoyaltySummary(
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      qualifyingCount: data.qualifyingCount.present
          ? data.qualifyingCount.value
          : this.qualifyingCount,
      hasAvailableReward: data.hasAvailableReward.present
          ? data.hasAvailableReward.value
          : this.hasAvailableReward,
      asOf: data.asOf.present ? data.asOf.value : this.asOf,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalLoyaltySummary(')
          ..write('vehicleId: $vehicleId, ')
          ..write('qualifyingCount: $qualifyingCount, ')
          ..write('hasAvailableReward: $hasAvailableReward, ')
          ..write('asOf: $asOf')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(vehicleId, qualifyingCount, hasAvailableReward, asOf);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalLoyaltySummary &&
          other.vehicleId == this.vehicleId &&
          other.qualifyingCount == this.qualifyingCount &&
          other.hasAvailableReward == this.hasAvailableReward &&
          other.asOf == this.asOf);
}

class LocalLoyaltySummariesCompanion
    extends UpdateCompanion<LocalLoyaltySummary> {
  final Value<String> vehicleId;
  final Value<int> qualifyingCount;
  final Value<bool> hasAvailableReward;
  final Value<DateTime> asOf;
  final Value<int> rowid;
  const LocalLoyaltySummariesCompanion({
    this.vehicleId = const Value.absent(),
    this.qualifyingCount = const Value.absent(),
    this.hasAvailableReward = const Value.absent(),
    this.asOf = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalLoyaltySummariesCompanion.insert({
    required String vehicleId,
    required int qualifyingCount,
    required bool hasAvailableReward,
    required DateTime asOf,
    this.rowid = const Value.absent(),
  }) : vehicleId = Value(vehicleId),
       qualifyingCount = Value(qualifyingCount),
       hasAvailableReward = Value(hasAvailableReward),
       asOf = Value(asOf);
  static Insertable<LocalLoyaltySummary> custom({
    Expression<String>? vehicleId,
    Expression<int>? qualifyingCount,
    Expression<bool>? hasAvailableReward,
    Expression<DateTime>? asOf,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (qualifyingCount != null) 'qualifying_count': qualifyingCount,
      if (hasAvailableReward != null)
        'has_available_reward': hasAvailableReward,
      if (asOf != null) 'as_of': asOf,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalLoyaltySummariesCompanion copyWith({
    Value<String>? vehicleId,
    Value<int>? qualifyingCount,
    Value<bool>? hasAvailableReward,
    Value<DateTime>? asOf,
    Value<int>? rowid,
  }) {
    return LocalLoyaltySummariesCompanion(
      vehicleId: vehicleId ?? this.vehicleId,
      qualifyingCount: qualifyingCount ?? this.qualifyingCount,
      hasAvailableReward: hasAvailableReward ?? this.hasAvailableReward,
      asOf: asOf ?? this.asOf,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (qualifyingCount.present) {
      map['qualifying_count'] = Variable<int>(qualifyingCount.value);
    }
    if (hasAvailableReward.present) {
      map['has_available_reward'] = Variable<bool>(hasAvailableReward.value);
    }
    if (asOf.present) {
      map['as_of'] = Variable<DateTime>(asOf.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalLoyaltySummariesCompanion(')
          ..write('vehicleId: $vehicleId, ')
          ..write('qualifyingCount: $qualifyingCount, ')
          ..write('hasAvailableReward: $hasAvailableReward, ')
          ..write('asOf: $asOf, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalLoyaltyLedgerTable extends LocalLoyaltyLedger
    with TableInfo<$LocalLoyaltyLedgerTable, LocalLoyaltyLedgerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalLoyaltyLedgerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _washOrderIdMeta = const VerificationMeta(
    'washOrderId',
  );
  @override
  late final GeneratedColumn<String> washOrderId = GeneratedColumn<String>(
    'wash_order_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodMonthMeta = const VerificationMeta(
    'periodMonth',
  );
  @override
  late final GeneratedColumn<DateTime> periodMonth = GeneratedColumn<DateTime>(
    'period_month',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _createdByIdMeta = const VerificationMeta(
    'createdById',
  );
  @override
  late final GeneratedColumn<String> createdById = GeneratedColumn<String>(
    'created_by_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    washOrderId,
    eventType,
    periodMonth,
    createdAt,
    createdById,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_loyalty_ledger';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalLoyaltyLedgerData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('wash_order_id')) {
      context.handle(
        _washOrderIdMeta,
        washOrderId.isAcceptableOrUnknown(
          data['wash_order_id']!,
          _washOrderIdMeta,
        ),
      );
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('period_month')) {
      context.handle(
        _periodMonthMeta,
        periodMonth.isAcceptableOrUnknown(
          data['period_month']!,
          _periodMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_periodMonthMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('created_by_id')) {
      context.handle(
        _createdByIdMeta,
        createdById.isAcceptableOrUnknown(
          data['created_by_id']!,
          _createdByIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdByIdMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {washOrderId, eventType},
  ];
  @override
  LocalLoyaltyLedgerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalLoyaltyLedgerData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      washOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wash_order_id'],
      ),
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      periodMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}period_month'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdById: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by_id'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $LocalLoyaltyLedgerTable createAlias(String alias) {
    return $LocalLoyaltyLedgerTable(attachedDatabase, alias);
  }
}

class LocalLoyaltyLedgerData extends DataClass
    implements Insertable<LocalLoyaltyLedgerData> {
  final String id;
  final String vehicleId;
  final String? washOrderId;
  final String eventType;
  final DateTime periodMonth;
  final DateTime createdAt;
  final String createdById;
  final String? notes;
  const LocalLoyaltyLedgerData({
    required this.id,
    required this.vehicleId,
    this.washOrderId,
    required this.eventType,
    required this.periodMonth,
    required this.createdAt,
    required this.createdById,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vehicle_id'] = Variable<String>(vehicleId);
    if (!nullToAbsent || washOrderId != null) {
      map['wash_order_id'] = Variable<String>(washOrderId);
    }
    map['event_type'] = Variable<String>(eventType);
    map['period_month'] = Variable<DateTime>(periodMonth);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by_id'] = Variable<String>(createdById);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  LocalLoyaltyLedgerCompanion toCompanion(bool nullToAbsent) {
    return LocalLoyaltyLedgerCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      washOrderId: washOrderId == null && nullToAbsent
          ? const Value.absent()
          : Value(washOrderId),
      eventType: Value(eventType),
      periodMonth: Value(periodMonth),
      createdAt: Value(createdAt),
      createdById: Value(createdById),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory LocalLoyaltyLedgerData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalLoyaltyLedgerData(
      id: serializer.fromJson<String>(json['id']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      washOrderId: serializer.fromJson<String?>(json['washOrderId']),
      eventType: serializer.fromJson<String>(json['eventType']),
      periodMonth: serializer.fromJson<DateTime>(json['periodMonth']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdById: serializer.fromJson<String>(json['createdById']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'washOrderId': serializer.toJson<String?>(washOrderId),
      'eventType': serializer.toJson<String>(eventType),
      'periodMonth': serializer.toJson<DateTime>(periodMonth),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdById': serializer.toJson<String>(createdById),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  LocalLoyaltyLedgerData copyWith({
    String? id,
    String? vehicleId,
    Value<String?> washOrderId = const Value.absent(),
    String? eventType,
    DateTime? periodMonth,
    DateTime? createdAt,
    String? createdById,
    Value<String?> notes = const Value.absent(),
  }) => LocalLoyaltyLedgerData(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    washOrderId: washOrderId.present ? washOrderId.value : this.washOrderId,
    eventType: eventType ?? this.eventType,
    periodMonth: periodMonth ?? this.periodMonth,
    createdAt: createdAt ?? this.createdAt,
    createdById: createdById ?? this.createdById,
    notes: notes.present ? notes.value : this.notes,
  );
  LocalLoyaltyLedgerData copyWithCompanion(LocalLoyaltyLedgerCompanion data) {
    return LocalLoyaltyLedgerData(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      washOrderId: data.washOrderId.present
          ? data.washOrderId.value
          : this.washOrderId,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      periodMonth: data.periodMonth.present
          ? data.periodMonth.value
          : this.periodMonth,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdById: data.createdById.present
          ? data.createdById.value
          : this.createdById,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalLoyaltyLedgerData(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('washOrderId: $washOrderId, ')
          ..write('eventType: $eventType, ')
          ..write('periodMonth: $periodMonth, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdById: $createdById, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    washOrderId,
    eventType,
    periodMonth,
    createdAt,
    createdById,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalLoyaltyLedgerData &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.washOrderId == this.washOrderId &&
          other.eventType == this.eventType &&
          other.periodMonth == this.periodMonth &&
          other.createdAt == this.createdAt &&
          other.createdById == this.createdById &&
          other.notes == this.notes);
}

class LocalLoyaltyLedgerCompanion
    extends UpdateCompanion<LocalLoyaltyLedgerData> {
  final Value<String> id;
  final Value<String> vehicleId;
  final Value<String?> washOrderId;
  final Value<String> eventType;
  final Value<DateTime> periodMonth;
  final Value<DateTime> createdAt;
  final Value<String> createdById;
  final Value<String?> notes;
  final Value<int> rowid;
  const LocalLoyaltyLedgerCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.washOrderId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.periodMonth = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdById = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalLoyaltyLedgerCompanion.insert({
    required String id,
    required String vehicleId,
    this.washOrderId = const Value.absent(),
    required String eventType,
    required DateTime periodMonth,
    this.createdAt = const Value.absent(),
    required String createdById,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vehicleId = Value(vehicleId),
       eventType = Value(eventType),
       periodMonth = Value(periodMonth),
       createdById = Value(createdById);
  static Insertable<LocalLoyaltyLedgerData> custom({
    Expression<String>? id,
    Expression<String>? vehicleId,
    Expression<String>? washOrderId,
    Expression<String>? eventType,
    Expression<DateTime>? periodMonth,
    Expression<DateTime>? createdAt,
    Expression<String>? createdById,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (washOrderId != null) 'wash_order_id': washOrderId,
      if (eventType != null) 'event_type': eventType,
      if (periodMonth != null) 'period_month': periodMonth,
      if (createdAt != null) 'created_at': createdAt,
      if (createdById != null) 'created_by_id': createdById,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalLoyaltyLedgerCompanion copyWith({
    Value<String>? id,
    Value<String>? vehicleId,
    Value<String?>? washOrderId,
    Value<String>? eventType,
    Value<DateTime>? periodMonth,
    Value<DateTime>? createdAt,
    Value<String>? createdById,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return LocalLoyaltyLedgerCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      washOrderId: washOrderId ?? this.washOrderId,
      eventType: eventType ?? this.eventType,
      periodMonth: periodMonth ?? this.periodMonth,
      createdAt: createdAt ?? this.createdAt,
      createdById: createdById ?? this.createdById,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (washOrderId.present) {
      map['wash_order_id'] = Variable<String>(washOrderId.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (periodMonth.present) {
      map['period_month'] = Variable<DateTime>(periodMonth.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdById.present) {
      map['created_by_id'] = Variable<String>(createdById.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalLoyaltyLedgerCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('washOrderId: $washOrderId, ')
          ..write('eventType: $eventType, ')
          ..write('periodMonth: $periodMonth, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdById: $createdById, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalLoyaltyRewardsTable extends LocalLoyaltyRewards
    with TableInfo<$LocalLoyaltyRewardsTable, LocalLoyaltyReward> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalLoyaltyRewardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _earnedMonthMeta = const VerificationMeta(
    'earnedMonth',
  );
  @override
  late final GeneratedColumn<DateTime> earnedMonth = GeneratedColumn<DateTime>(
    'earned_month',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _validMonthMeta = const VerificationMeta(
    'validMonth',
  );
  @override
  late final GeneratedColumn<DateTime> validMonth = GeneratedColumn<DateTime>(
    'valid_month',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('AVAILABLE'),
  );
  static const VerificationMeta _earnedFromLedgerIdMeta =
      const VerificationMeta('earnedFromLedgerId');
  @override
  late final GeneratedColumn<String> earnedFromLedgerId =
      GeneratedColumn<String>(
        'earned_from_ledger_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _redeemedWashOrderIdMeta =
      const VerificationMeta('redeemedWashOrderId');
  @override
  late final GeneratedColumn<String> redeemedWashOrderId =
      GeneratedColumn<String>(
        'redeemed_wash_order_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _redeemedAtMeta = const VerificationMeta(
    'redeemedAt',
  );
  @override
  late final GeneratedColumn<DateTime> redeemedAt = GeneratedColumn<DateTime>(
    'redeemed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiredAtMeta = const VerificationMeta(
    'expiredAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiredAt = GeneratedColumn<DateTime>(
    'expired_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    earnedMonth,
    validMonth,
    status,
    earnedFromLedgerId,
    redeemedWashOrderId,
    redeemedAt,
    expiredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_loyalty_rewards';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalLoyaltyReward> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('earned_month')) {
      context.handle(
        _earnedMonthMeta,
        earnedMonth.isAcceptableOrUnknown(
          data['earned_month']!,
          _earnedMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_earnedMonthMeta);
    }
    if (data.containsKey('valid_month')) {
      context.handle(
        _validMonthMeta,
        validMonth.isAcceptableOrUnknown(data['valid_month']!, _validMonthMeta),
      );
    } else if (isInserting) {
      context.missing(_validMonthMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('earned_from_ledger_id')) {
      context.handle(
        _earnedFromLedgerIdMeta,
        earnedFromLedgerId.isAcceptableOrUnknown(
          data['earned_from_ledger_id']!,
          _earnedFromLedgerIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_earnedFromLedgerIdMeta);
    }
    if (data.containsKey('redeemed_wash_order_id')) {
      context.handle(
        _redeemedWashOrderIdMeta,
        redeemedWashOrderId.isAcceptableOrUnknown(
          data['redeemed_wash_order_id']!,
          _redeemedWashOrderIdMeta,
        ),
      );
    }
    if (data.containsKey('redeemed_at')) {
      context.handle(
        _redeemedAtMeta,
        redeemedAt.isAcceptableOrUnknown(data['redeemed_at']!, _redeemedAtMeta),
      );
    }
    if (data.containsKey('expired_at')) {
      context.handle(
        _expiredAtMeta,
        expiredAt.isAcceptableOrUnknown(data['expired_at']!, _expiredAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalLoyaltyReward map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalLoyaltyReward(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      earnedMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}earned_month'],
      )!,
      validMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}valid_month'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      earnedFromLedgerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}earned_from_ledger_id'],
      )!,
      redeemedWashOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}redeemed_wash_order_id'],
      ),
      redeemedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}redeemed_at'],
      ),
      expiredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expired_at'],
      ),
    );
  }

  @override
  $LocalLoyaltyRewardsTable createAlias(String alias) {
    return $LocalLoyaltyRewardsTable(attachedDatabase, alias);
  }
}

class LocalLoyaltyReward extends DataClass
    implements Insertable<LocalLoyaltyReward> {
  final String id;
  final String vehicleId;
  final DateTime earnedMonth;
  final DateTime validMonth;
  final String status;
  final String earnedFromLedgerId;
  final String? redeemedWashOrderId;
  final DateTime? redeemedAt;
  final DateTime? expiredAt;
  const LocalLoyaltyReward({
    required this.id,
    required this.vehicleId,
    required this.earnedMonth,
    required this.validMonth,
    required this.status,
    required this.earnedFromLedgerId,
    this.redeemedWashOrderId,
    this.redeemedAt,
    this.expiredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['earned_month'] = Variable<DateTime>(earnedMonth);
    map['valid_month'] = Variable<DateTime>(validMonth);
    map['status'] = Variable<String>(status);
    map['earned_from_ledger_id'] = Variable<String>(earnedFromLedgerId);
    if (!nullToAbsent || redeemedWashOrderId != null) {
      map['redeemed_wash_order_id'] = Variable<String>(redeemedWashOrderId);
    }
    if (!nullToAbsent || redeemedAt != null) {
      map['redeemed_at'] = Variable<DateTime>(redeemedAt);
    }
    if (!nullToAbsent || expiredAt != null) {
      map['expired_at'] = Variable<DateTime>(expiredAt);
    }
    return map;
  }

  LocalLoyaltyRewardsCompanion toCompanion(bool nullToAbsent) {
    return LocalLoyaltyRewardsCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      earnedMonth: Value(earnedMonth),
      validMonth: Value(validMonth),
      status: Value(status),
      earnedFromLedgerId: Value(earnedFromLedgerId),
      redeemedWashOrderId: redeemedWashOrderId == null && nullToAbsent
          ? const Value.absent()
          : Value(redeemedWashOrderId),
      redeemedAt: redeemedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(redeemedAt),
      expiredAt: expiredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiredAt),
    );
  }

  factory LocalLoyaltyReward.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalLoyaltyReward(
      id: serializer.fromJson<String>(json['id']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      earnedMonth: serializer.fromJson<DateTime>(json['earnedMonth']),
      validMonth: serializer.fromJson<DateTime>(json['validMonth']),
      status: serializer.fromJson<String>(json['status']),
      earnedFromLedgerId: serializer.fromJson<String>(
        json['earnedFromLedgerId'],
      ),
      redeemedWashOrderId: serializer.fromJson<String?>(
        json['redeemedWashOrderId'],
      ),
      redeemedAt: serializer.fromJson<DateTime?>(json['redeemedAt']),
      expiredAt: serializer.fromJson<DateTime?>(json['expiredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'earnedMonth': serializer.toJson<DateTime>(earnedMonth),
      'validMonth': serializer.toJson<DateTime>(validMonth),
      'status': serializer.toJson<String>(status),
      'earnedFromLedgerId': serializer.toJson<String>(earnedFromLedgerId),
      'redeemedWashOrderId': serializer.toJson<String?>(redeemedWashOrderId),
      'redeemedAt': serializer.toJson<DateTime?>(redeemedAt),
      'expiredAt': serializer.toJson<DateTime?>(expiredAt),
    };
  }

  LocalLoyaltyReward copyWith({
    String? id,
    String? vehicleId,
    DateTime? earnedMonth,
    DateTime? validMonth,
    String? status,
    String? earnedFromLedgerId,
    Value<String?> redeemedWashOrderId = const Value.absent(),
    Value<DateTime?> redeemedAt = const Value.absent(),
    Value<DateTime?> expiredAt = const Value.absent(),
  }) => LocalLoyaltyReward(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    earnedMonth: earnedMonth ?? this.earnedMonth,
    validMonth: validMonth ?? this.validMonth,
    status: status ?? this.status,
    earnedFromLedgerId: earnedFromLedgerId ?? this.earnedFromLedgerId,
    redeemedWashOrderId: redeemedWashOrderId.present
        ? redeemedWashOrderId.value
        : this.redeemedWashOrderId,
    redeemedAt: redeemedAt.present ? redeemedAt.value : this.redeemedAt,
    expiredAt: expiredAt.present ? expiredAt.value : this.expiredAt,
  );
  LocalLoyaltyReward copyWithCompanion(LocalLoyaltyRewardsCompanion data) {
    return LocalLoyaltyReward(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      earnedMonth: data.earnedMonth.present
          ? data.earnedMonth.value
          : this.earnedMonth,
      validMonth: data.validMonth.present
          ? data.validMonth.value
          : this.validMonth,
      status: data.status.present ? data.status.value : this.status,
      earnedFromLedgerId: data.earnedFromLedgerId.present
          ? data.earnedFromLedgerId.value
          : this.earnedFromLedgerId,
      redeemedWashOrderId: data.redeemedWashOrderId.present
          ? data.redeemedWashOrderId.value
          : this.redeemedWashOrderId,
      redeemedAt: data.redeemedAt.present
          ? data.redeemedAt.value
          : this.redeemedAt,
      expiredAt: data.expiredAt.present ? data.expiredAt.value : this.expiredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalLoyaltyReward(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('earnedMonth: $earnedMonth, ')
          ..write('validMonth: $validMonth, ')
          ..write('status: $status, ')
          ..write('earnedFromLedgerId: $earnedFromLedgerId, ')
          ..write('redeemedWashOrderId: $redeemedWashOrderId, ')
          ..write('redeemedAt: $redeemedAt, ')
          ..write('expiredAt: $expiredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    earnedMonth,
    validMonth,
    status,
    earnedFromLedgerId,
    redeemedWashOrderId,
    redeemedAt,
    expiredAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalLoyaltyReward &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.earnedMonth == this.earnedMonth &&
          other.validMonth == this.validMonth &&
          other.status == this.status &&
          other.earnedFromLedgerId == this.earnedFromLedgerId &&
          other.redeemedWashOrderId == this.redeemedWashOrderId &&
          other.redeemedAt == this.redeemedAt &&
          other.expiredAt == this.expiredAt);
}

class LocalLoyaltyRewardsCompanion extends UpdateCompanion<LocalLoyaltyReward> {
  final Value<String> id;
  final Value<String> vehicleId;
  final Value<DateTime> earnedMonth;
  final Value<DateTime> validMonth;
  final Value<String> status;
  final Value<String> earnedFromLedgerId;
  final Value<String?> redeemedWashOrderId;
  final Value<DateTime?> redeemedAt;
  final Value<DateTime?> expiredAt;
  final Value<int> rowid;
  const LocalLoyaltyRewardsCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.earnedMonth = const Value.absent(),
    this.validMonth = const Value.absent(),
    this.status = const Value.absent(),
    this.earnedFromLedgerId = const Value.absent(),
    this.redeemedWashOrderId = const Value.absent(),
    this.redeemedAt = const Value.absent(),
    this.expiredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalLoyaltyRewardsCompanion.insert({
    required String id,
    required String vehicleId,
    required DateTime earnedMonth,
    required DateTime validMonth,
    this.status = const Value.absent(),
    required String earnedFromLedgerId,
    this.redeemedWashOrderId = const Value.absent(),
    this.redeemedAt = const Value.absent(),
    this.expiredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vehicleId = Value(vehicleId),
       earnedMonth = Value(earnedMonth),
       validMonth = Value(validMonth),
       earnedFromLedgerId = Value(earnedFromLedgerId);
  static Insertable<LocalLoyaltyReward> custom({
    Expression<String>? id,
    Expression<String>? vehicleId,
    Expression<DateTime>? earnedMonth,
    Expression<DateTime>? validMonth,
    Expression<String>? status,
    Expression<String>? earnedFromLedgerId,
    Expression<String>? redeemedWashOrderId,
    Expression<DateTime>? redeemedAt,
    Expression<DateTime>? expiredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (earnedMonth != null) 'earned_month': earnedMonth,
      if (validMonth != null) 'valid_month': validMonth,
      if (status != null) 'status': status,
      if (earnedFromLedgerId != null)
        'earned_from_ledger_id': earnedFromLedgerId,
      if (redeemedWashOrderId != null)
        'redeemed_wash_order_id': redeemedWashOrderId,
      if (redeemedAt != null) 'redeemed_at': redeemedAt,
      if (expiredAt != null) 'expired_at': expiredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalLoyaltyRewardsCompanion copyWith({
    Value<String>? id,
    Value<String>? vehicleId,
    Value<DateTime>? earnedMonth,
    Value<DateTime>? validMonth,
    Value<String>? status,
    Value<String>? earnedFromLedgerId,
    Value<String?>? redeemedWashOrderId,
    Value<DateTime?>? redeemedAt,
    Value<DateTime?>? expiredAt,
    Value<int>? rowid,
  }) {
    return LocalLoyaltyRewardsCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      earnedMonth: earnedMonth ?? this.earnedMonth,
      validMonth: validMonth ?? this.validMonth,
      status: status ?? this.status,
      earnedFromLedgerId: earnedFromLedgerId ?? this.earnedFromLedgerId,
      redeemedWashOrderId: redeemedWashOrderId ?? this.redeemedWashOrderId,
      redeemedAt: redeemedAt ?? this.redeemedAt,
      expiredAt: expiredAt ?? this.expiredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (earnedMonth.present) {
      map['earned_month'] = Variable<DateTime>(earnedMonth.value);
    }
    if (validMonth.present) {
      map['valid_month'] = Variable<DateTime>(validMonth.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (earnedFromLedgerId.present) {
      map['earned_from_ledger_id'] = Variable<String>(earnedFromLedgerId.value);
    }
    if (redeemedWashOrderId.present) {
      map['redeemed_wash_order_id'] = Variable<String>(
        redeemedWashOrderId.value,
      );
    }
    if (redeemedAt.present) {
      map['redeemed_at'] = Variable<DateTime>(redeemedAt.value);
    }
    if (expiredAt.present) {
      map['expired_at'] = Variable<DateTime>(expiredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalLoyaltyRewardsCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('earnedMonth: $earnedMonth, ')
          ..write('validMonth: $validMonth, ')
          ..write('status: $status, ')
          ..write('earnedFromLedgerId: $earnedFromLedgerId, ')
          ..write('redeemedWashOrderId: $redeemedWashOrderId, ')
          ..write('redeemedAt: $redeemedAt, ')
          ..write('expiredAt: $expiredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalWashOrdersTable extends LocalWashOrders
    with TableInfo<$LocalWashOrdersTable, LocalWashOrder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalWashOrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _branchIdMeta = const VerificationMeta(
    'branchId',
  );
  @override
  late final GeneratedColumn<String> branchId = GeneratedColumn<String>(
    'branch_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<int> totalAmount = GeneratedColumn<int>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cancelledAtMeta = const VerificationMeta(
    'cancelledAt',
  );
  @override
  late final GeneratedColumn<DateTime> cancelledAt = GeneratedColumn<DateTime>(
    'cancelled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cancelReasonMeta = const VerificationMeta(
    'cancelReason',
  );
  @override
  late final GeneratedColumn<String> cancelReason = GeneratedColumn<String>(
    'cancel_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WashSyncStatus, String>
  syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  ).withConverter<WashSyncStatus>($LocalWashOrdersTable.$convertersyncStatus);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    branchId,
    vehicleId,
    customerId,
    status,
    totalAmount,
    createdAt,
    completedAt,
    cancelledAt,
    cancelReason,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_wash_orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalWashOrder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('branch_id')) {
      context.handle(
        _branchIdMeta,
        branchId.isAcceptableOrUnknown(data['branch_id']!, _branchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('cancelled_at')) {
      context.handle(
        _cancelledAtMeta,
        cancelledAt.isAcceptableOrUnknown(
          data['cancelled_at']!,
          _cancelledAtMeta,
        ),
      );
    }
    if (data.containsKey('cancel_reason')) {
      context.handle(
        _cancelReasonMeta,
        cancelReason.isAcceptableOrUnknown(
          data['cancel_reason']!,
          _cancelReasonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalWashOrder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalWashOrder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      branchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch_id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_amount'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      cancelledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cancelled_at'],
      ),
      cancelReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cancel_reason'],
      ),
      syncStatus: $LocalWashOrdersTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
    );
  }

  @override
  $LocalWashOrdersTable createAlias(String alias) {
    return $LocalWashOrdersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WashSyncStatus, String, String>
  $convertersyncStatus = const EnumNameConverter<WashSyncStatus>(
    WashSyncStatus.values,
  );
}

class LocalWashOrder extends DataClass implements Insertable<LocalWashOrder> {
  final String id;
  final String branchId;
  final String vehicleId;
  final String customerId;
  final String status;
  final int totalAmount;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancelReason;
  final WashSyncStatus syncStatus;
  const LocalWashOrder({
    required this.id,
    required this.branchId,
    required this.vehicleId,
    required this.customerId,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    this.completedAt,
    this.cancelledAt,
    this.cancelReason,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['branch_id'] = Variable<String>(branchId);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['customer_id'] = Variable<String>(customerId);
    map['status'] = Variable<String>(status);
    map['total_amount'] = Variable<int>(totalAmount);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || cancelledAt != null) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt);
    }
    if (!nullToAbsent || cancelReason != null) {
      map['cancel_reason'] = Variable<String>(cancelReason);
    }
    {
      map['sync_status'] = Variable<String>(
        $LocalWashOrdersTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    return map;
  }

  LocalWashOrdersCompanion toCompanion(bool nullToAbsent) {
    return LocalWashOrdersCompanion(
      id: Value(id),
      branchId: Value(branchId),
      vehicleId: Value(vehicleId),
      customerId: Value(customerId),
      status: Value(status),
      totalAmount: Value(totalAmount),
      createdAt: Value(createdAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      cancelledAt: cancelledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelledAt),
      cancelReason: cancelReason == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelReason),
      syncStatus: Value(syncStatus),
    );
  }

  factory LocalWashOrder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalWashOrder(
      id: serializer.fromJson<String>(json['id']),
      branchId: serializer.fromJson<String>(json['branchId']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      customerId: serializer.fromJson<String>(json['customerId']),
      status: serializer.fromJson<String>(json['status']),
      totalAmount: serializer.fromJson<int>(json['totalAmount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      cancelledAt: serializer.fromJson<DateTime?>(json['cancelledAt']),
      cancelReason: serializer.fromJson<String?>(json['cancelReason']),
      syncStatus: $LocalWashOrdersTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'branchId': serializer.toJson<String>(branchId),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'customerId': serializer.toJson<String>(customerId),
      'status': serializer.toJson<String>(status),
      'totalAmount': serializer.toJson<int>(totalAmount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'cancelledAt': serializer.toJson<DateTime?>(cancelledAt),
      'cancelReason': serializer.toJson<String?>(cancelReason),
      'syncStatus': serializer.toJson<String>(
        $LocalWashOrdersTable.$convertersyncStatus.toJson(syncStatus),
      ),
    };
  }

  LocalWashOrder copyWith({
    String? id,
    String? branchId,
    String? vehicleId,
    String? customerId,
    String? status,
    int? totalAmount,
    DateTime? createdAt,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<DateTime?> cancelledAt = const Value.absent(),
    Value<String?> cancelReason = const Value.absent(),
    WashSyncStatus? syncStatus,
  }) => LocalWashOrder(
    id: id ?? this.id,
    branchId: branchId ?? this.branchId,
    vehicleId: vehicleId ?? this.vehicleId,
    customerId: customerId ?? this.customerId,
    status: status ?? this.status,
    totalAmount: totalAmount ?? this.totalAmount,
    createdAt: createdAt ?? this.createdAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    cancelledAt: cancelledAt.present ? cancelledAt.value : this.cancelledAt,
    cancelReason: cancelReason.present ? cancelReason.value : this.cancelReason,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  LocalWashOrder copyWithCompanion(LocalWashOrdersCompanion data) {
    return LocalWashOrder(
      id: data.id.present ? data.id.value : this.id,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      status: data.status.present ? data.status.value : this.status,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      cancelledAt: data.cancelledAt.present
          ? data.cancelledAt.value
          : this.cancelledAt,
      cancelReason: data.cancelReason.present
          ? data.cancelReason.value
          : this.cancelReason,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalWashOrder(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('customerId: $customerId, ')
          ..write('status: $status, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('cancelledAt: $cancelledAt, ')
          ..write('cancelReason: $cancelReason, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    branchId,
    vehicleId,
    customerId,
    status,
    totalAmount,
    createdAt,
    completedAt,
    cancelledAt,
    cancelReason,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalWashOrder &&
          other.id == this.id &&
          other.branchId == this.branchId &&
          other.vehicleId == this.vehicleId &&
          other.customerId == this.customerId &&
          other.status == this.status &&
          other.totalAmount == this.totalAmount &&
          other.createdAt == this.createdAt &&
          other.completedAt == this.completedAt &&
          other.cancelledAt == this.cancelledAt &&
          other.cancelReason == this.cancelReason &&
          other.syncStatus == this.syncStatus);
}

class LocalWashOrdersCompanion extends UpdateCompanion<LocalWashOrder> {
  final Value<String> id;
  final Value<String> branchId;
  final Value<String> vehicleId;
  final Value<String> customerId;
  final Value<String> status;
  final Value<int> totalAmount;
  final Value<DateTime> createdAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime?> cancelledAt;
  final Value<String?> cancelReason;
  final Value<WashSyncStatus> syncStatus;
  final Value<int> rowid;
  const LocalWashOrdersCompanion({
    this.id = const Value.absent(),
    this.branchId = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.status = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.cancelledAt = const Value.absent(),
    this.cancelReason = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalWashOrdersCompanion.insert({
    required String id,
    required String branchId,
    required String vehicleId,
    required String customerId,
    required String status,
    required int totalAmount,
    required DateTime createdAt,
    this.completedAt = const Value.absent(),
    this.cancelledAt = const Value.absent(),
    this.cancelReason = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       branchId = Value(branchId),
       vehicleId = Value(vehicleId),
       customerId = Value(customerId),
       status = Value(status),
       totalAmount = Value(totalAmount),
       createdAt = Value(createdAt);
  static Insertable<LocalWashOrder> custom({
    Expression<String>? id,
    Expression<String>? branchId,
    Expression<String>? vehicleId,
    Expression<String>? customerId,
    Expression<String>? status,
    Expression<int>? totalAmount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? cancelledAt,
    Expression<String>? cancelReason,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (branchId != null) 'branch_id': branchId,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (customerId != null) 'customer_id': customerId,
      if (status != null) 'status': status,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (createdAt != null) 'created_at': createdAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (cancelledAt != null) 'cancelled_at': cancelledAt,
      if (cancelReason != null) 'cancel_reason': cancelReason,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalWashOrdersCompanion copyWith({
    Value<String>? id,
    Value<String>? branchId,
    Value<String>? vehicleId,
    Value<String>? customerId,
    Value<String>? status,
    Value<int>? totalAmount,
    Value<DateTime>? createdAt,
    Value<DateTime?>? completedAt,
    Value<DateTime?>? cancelledAt,
    Value<String?>? cancelReason,
    Value<WashSyncStatus>? syncStatus,
    Value<int>? rowid,
  }) {
    return LocalWashOrdersCompanion(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      vehicleId: vehicleId ?? this.vehicleId,
      customerId: customerId ?? this.customerId,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancelReason: cancelReason ?? this.cancelReason,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<String>(branchId.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<int>(totalAmount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (cancelledAt.present) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt.value);
    }
    if (cancelReason.present) {
      map['cancel_reason'] = Variable<String>(cancelReason.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $LocalWashOrdersTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalWashOrdersCompanion(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('customerId: $customerId, ')
          ..write('status: $status, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('cancelledAt: $cancelledAt, ')
          ..write('cancelReason: $cancelReason, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalWashOrderItemsTable extends LocalWashOrderItems
    with TableInfo<$LocalWashOrderItemsTable, LocalWashOrderItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalWashOrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _washOrderIdMeta = const VerificationMeta(
    'washOrderId',
  );
  @override
  late final GeneratedColumn<String> washOrderId = GeneratedColumn<String>(
    'wash_order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemTypeMeta = const VerificationMeta(
    'itemType',
  );
  @override
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
    'item_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serviceIdMeta = const VerificationMeta(
    'serviceId',
  );
  @override
  late final GeneratedColumn<String> serviceId = GeneratedColumn<String>(
    'service_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _extraIdMeta = const VerificationMeta(
    'extraId',
  );
  @override
  late final GeneratedColumn<String> extraId = GeneratedColumn<String>(
    'extra_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameSnapshotMeta = const VerificationMeta(
    'nameSnapshot',
  );
  @override
  late final GeneratedColumn<String> nameSnapshot = GeneratedColumn<String>(
    'name_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceSnapshotMeta = const VerificationMeta(
    'priceSnapshot',
  );
  @override
  late final GeneratedColumn<int> priceSnapshot = GeneratedColumn<int>(
    'price_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    washOrderId,
    itemType,
    serviceId,
    extraId,
    nameSnapshot,
    priceSnapshot,
    qty,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_wash_order_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalWashOrderItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('wash_order_id')) {
      context.handle(
        _washOrderIdMeta,
        washOrderId.isAcceptableOrUnknown(
          data['wash_order_id']!,
          _washOrderIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_washOrderIdMeta);
    }
    if (data.containsKey('item_type')) {
      context.handle(
        _itemTypeMeta,
        itemType.isAcceptableOrUnknown(data['item_type']!, _itemTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_itemTypeMeta);
    }
    if (data.containsKey('service_id')) {
      context.handle(
        _serviceIdMeta,
        serviceId.isAcceptableOrUnknown(data['service_id']!, _serviceIdMeta),
      );
    }
    if (data.containsKey('extra_id')) {
      context.handle(
        _extraIdMeta,
        extraId.isAcceptableOrUnknown(data['extra_id']!, _extraIdMeta),
      );
    }
    if (data.containsKey('name_snapshot')) {
      context.handle(
        _nameSnapshotMeta,
        nameSnapshot.isAcceptableOrUnknown(
          data['name_snapshot']!,
          _nameSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameSnapshotMeta);
    }
    if (data.containsKey('price_snapshot')) {
      context.handle(
        _priceSnapshotMeta,
        priceSnapshot.isAcceptableOrUnknown(
          data['price_snapshot']!,
          _priceSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_priceSnapshotMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalWashOrderItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalWashOrderItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      washOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wash_order_id'],
      )!,
      itemType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_type'],
      )!,
      serviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_id'],
      ),
      extraId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extra_id'],
      ),
      nameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_snapshot'],
      )!,
      priceSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_snapshot'],
      )!,
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty'],
      )!,
    );
  }

  @override
  $LocalWashOrderItemsTable createAlias(String alias) {
    return $LocalWashOrderItemsTable(attachedDatabase, alias);
  }
}

class LocalWashOrderItem extends DataClass
    implements Insertable<LocalWashOrderItem> {
  final String id;
  final String washOrderId;
  final String itemType;
  final String? serviceId;
  final String? extraId;
  final String nameSnapshot;
  final int priceSnapshot;
  final int qty;
  const LocalWashOrderItem({
    required this.id,
    required this.washOrderId,
    required this.itemType,
    this.serviceId,
    this.extraId,
    required this.nameSnapshot,
    required this.priceSnapshot,
    required this.qty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['wash_order_id'] = Variable<String>(washOrderId);
    map['item_type'] = Variable<String>(itemType);
    if (!nullToAbsent || serviceId != null) {
      map['service_id'] = Variable<String>(serviceId);
    }
    if (!nullToAbsent || extraId != null) {
      map['extra_id'] = Variable<String>(extraId);
    }
    map['name_snapshot'] = Variable<String>(nameSnapshot);
    map['price_snapshot'] = Variable<int>(priceSnapshot);
    map['qty'] = Variable<int>(qty);
    return map;
  }

  LocalWashOrderItemsCompanion toCompanion(bool nullToAbsent) {
    return LocalWashOrderItemsCompanion(
      id: Value(id),
      washOrderId: Value(washOrderId),
      itemType: Value(itemType),
      serviceId: serviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(serviceId),
      extraId: extraId == null && nullToAbsent
          ? const Value.absent()
          : Value(extraId),
      nameSnapshot: Value(nameSnapshot),
      priceSnapshot: Value(priceSnapshot),
      qty: Value(qty),
    );
  }

  factory LocalWashOrderItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalWashOrderItem(
      id: serializer.fromJson<String>(json['id']),
      washOrderId: serializer.fromJson<String>(json['washOrderId']),
      itemType: serializer.fromJson<String>(json['itemType']),
      serviceId: serializer.fromJson<String?>(json['serviceId']),
      extraId: serializer.fromJson<String?>(json['extraId']),
      nameSnapshot: serializer.fromJson<String>(json['nameSnapshot']),
      priceSnapshot: serializer.fromJson<int>(json['priceSnapshot']),
      qty: serializer.fromJson<int>(json['qty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'washOrderId': serializer.toJson<String>(washOrderId),
      'itemType': serializer.toJson<String>(itemType),
      'serviceId': serializer.toJson<String?>(serviceId),
      'extraId': serializer.toJson<String?>(extraId),
      'nameSnapshot': serializer.toJson<String>(nameSnapshot),
      'priceSnapshot': serializer.toJson<int>(priceSnapshot),
      'qty': serializer.toJson<int>(qty),
    };
  }

  LocalWashOrderItem copyWith({
    String? id,
    String? washOrderId,
    String? itemType,
    Value<String?> serviceId = const Value.absent(),
    Value<String?> extraId = const Value.absent(),
    String? nameSnapshot,
    int? priceSnapshot,
    int? qty,
  }) => LocalWashOrderItem(
    id: id ?? this.id,
    washOrderId: washOrderId ?? this.washOrderId,
    itemType: itemType ?? this.itemType,
    serviceId: serviceId.present ? serviceId.value : this.serviceId,
    extraId: extraId.present ? extraId.value : this.extraId,
    nameSnapshot: nameSnapshot ?? this.nameSnapshot,
    priceSnapshot: priceSnapshot ?? this.priceSnapshot,
    qty: qty ?? this.qty,
  );
  LocalWashOrderItem copyWithCompanion(LocalWashOrderItemsCompanion data) {
    return LocalWashOrderItem(
      id: data.id.present ? data.id.value : this.id,
      washOrderId: data.washOrderId.present
          ? data.washOrderId.value
          : this.washOrderId,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      serviceId: data.serviceId.present ? data.serviceId.value : this.serviceId,
      extraId: data.extraId.present ? data.extraId.value : this.extraId,
      nameSnapshot: data.nameSnapshot.present
          ? data.nameSnapshot.value
          : this.nameSnapshot,
      priceSnapshot: data.priceSnapshot.present
          ? data.priceSnapshot.value
          : this.priceSnapshot,
      qty: data.qty.present ? data.qty.value : this.qty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalWashOrderItem(')
          ..write('id: $id, ')
          ..write('washOrderId: $washOrderId, ')
          ..write('itemType: $itemType, ')
          ..write('serviceId: $serviceId, ')
          ..write('extraId: $extraId, ')
          ..write('nameSnapshot: $nameSnapshot, ')
          ..write('priceSnapshot: $priceSnapshot, ')
          ..write('qty: $qty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    washOrderId,
    itemType,
    serviceId,
    extraId,
    nameSnapshot,
    priceSnapshot,
    qty,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalWashOrderItem &&
          other.id == this.id &&
          other.washOrderId == this.washOrderId &&
          other.itemType == this.itemType &&
          other.serviceId == this.serviceId &&
          other.extraId == this.extraId &&
          other.nameSnapshot == this.nameSnapshot &&
          other.priceSnapshot == this.priceSnapshot &&
          other.qty == this.qty);
}

class LocalWashOrderItemsCompanion extends UpdateCompanion<LocalWashOrderItem> {
  final Value<String> id;
  final Value<String> washOrderId;
  final Value<String> itemType;
  final Value<String?> serviceId;
  final Value<String?> extraId;
  final Value<String> nameSnapshot;
  final Value<int> priceSnapshot;
  final Value<int> qty;
  final Value<int> rowid;
  const LocalWashOrderItemsCompanion({
    this.id = const Value.absent(),
    this.washOrderId = const Value.absent(),
    this.itemType = const Value.absent(),
    this.serviceId = const Value.absent(),
    this.extraId = const Value.absent(),
    this.nameSnapshot = const Value.absent(),
    this.priceSnapshot = const Value.absent(),
    this.qty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalWashOrderItemsCompanion.insert({
    required String id,
    required String washOrderId,
    required String itemType,
    this.serviceId = const Value.absent(),
    this.extraId = const Value.absent(),
    required String nameSnapshot,
    required int priceSnapshot,
    this.qty = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       washOrderId = Value(washOrderId),
       itemType = Value(itemType),
       nameSnapshot = Value(nameSnapshot),
       priceSnapshot = Value(priceSnapshot);
  static Insertable<LocalWashOrderItem> custom({
    Expression<String>? id,
    Expression<String>? washOrderId,
    Expression<String>? itemType,
    Expression<String>? serviceId,
    Expression<String>? extraId,
    Expression<String>? nameSnapshot,
    Expression<int>? priceSnapshot,
    Expression<int>? qty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (washOrderId != null) 'wash_order_id': washOrderId,
      if (itemType != null) 'item_type': itemType,
      if (serviceId != null) 'service_id': serviceId,
      if (extraId != null) 'extra_id': extraId,
      if (nameSnapshot != null) 'name_snapshot': nameSnapshot,
      if (priceSnapshot != null) 'price_snapshot': priceSnapshot,
      if (qty != null) 'qty': qty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalWashOrderItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? washOrderId,
    Value<String>? itemType,
    Value<String?>? serviceId,
    Value<String?>? extraId,
    Value<String>? nameSnapshot,
    Value<int>? priceSnapshot,
    Value<int>? qty,
    Value<int>? rowid,
  }) {
    return LocalWashOrderItemsCompanion(
      id: id ?? this.id,
      washOrderId: washOrderId ?? this.washOrderId,
      itemType: itemType ?? this.itemType,
      serviceId: serviceId ?? this.serviceId,
      extraId: extraId ?? this.extraId,
      nameSnapshot: nameSnapshot ?? this.nameSnapshot,
      priceSnapshot: priceSnapshot ?? this.priceSnapshot,
      qty: qty ?? this.qty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (washOrderId.present) {
      map['wash_order_id'] = Variable<String>(washOrderId.value);
    }
    if (itemType.present) {
      map['item_type'] = Variable<String>(itemType.value);
    }
    if (serviceId.present) {
      map['service_id'] = Variable<String>(serviceId.value);
    }
    if (extraId.present) {
      map['extra_id'] = Variable<String>(extraId.value);
    }
    if (nameSnapshot.present) {
      map['name_snapshot'] = Variable<String>(nameSnapshot.value);
    }
    if (priceSnapshot.present) {
      map['price_snapshot'] = Variable<int>(priceSnapshot.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalWashOrderItemsCompanion(')
          ..write('id: $id, ')
          ..write('washOrderId: $washOrderId, ')
          ..write('itemType: $itemType, ')
          ..write('serviceId: $serviceId, ')
          ..write('extraId: $extraId, ')
          ..write('nameSnapshot: $nameSnapshot, ')
          ..write('priceSnapshot: $priceSnapshot, ')
          ..write('qty: $qty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalPaymentsTable extends LocalPayments
    with TableInfo<$LocalPaymentsTable, LocalPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _washOrderIdMeta = const VerificationMeta(
    'washOrderId',
  );
  @override
  late final GeneratedColumn<String> washOrderId = GeneratedColumn<String>(
    'wash_order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<int> totalAmount = GeneratedColumn<int>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    washOrderId,
    totalAmount,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('wash_order_id')) {
      context.handle(
        _washOrderIdMeta,
        washOrderId.isAcceptableOrUnknown(
          data['wash_order_id']!,
          _washOrderIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_washOrderIdMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPayment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      washOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wash_order_id'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_amount'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
    );
  }

  @override
  $LocalPaymentsTable createAlias(String alias) {
    return $LocalPaymentsTable(attachedDatabase, alias);
  }
}

class LocalPayment extends DataClass implements Insertable<LocalPayment> {
  final String id;
  final String washOrderId;
  final int totalAmount;
  final DateTime completedAt;
  const LocalPayment({
    required this.id,
    required this.washOrderId,
    required this.totalAmount,
    required this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['wash_order_id'] = Variable<String>(washOrderId);
    map['total_amount'] = Variable<int>(totalAmount);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  LocalPaymentsCompanion toCompanion(bool nullToAbsent) {
    return LocalPaymentsCompanion(
      id: Value(id),
      washOrderId: Value(washOrderId),
      totalAmount: Value(totalAmount),
      completedAt: Value(completedAt),
    );
  }

  factory LocalPayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPayment(
      id: serializer.fromJson<String>(json['id']),
      washOrderId: serializer.fromJson<String>(json['washOrderId']),
      totalAmount: serializer.fromJson<int>(json['totalAmount']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'washOrderId': serializer.toJson<String>(washOrderId),
      'totalAmount': serializer.toJson<int>(totalAmount),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  LocalPayment copyWith({
    String? id,
    String? washOrderId,
    int? totalAmount,
    DateTime? completedAt,
  }) => LocalPayment(
    id: id ?? this.id,
    washOrderId: washOrderId ?? this.washOrderId,
    totalAmount: totalAmount ?? this.totalAmount,
    completedAt: completedAt ?? this.completedAt,
  );
  LocalPayment copyWithCompanion(LocalPaymentsCompanion data) {
    return LocalPayment(
      id: data.id.present ? data.id.value : this.id,
      washOrderId: data.washOrderId.present
          ? data.washOrderId.value
          : this.washOrderId,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPayment(')
          ..write('id: $id, ')
          ..write('washOrderId: $washOrderId, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, washOrderId, totalAmount, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPayment &&
          other.id == this.id &&
          other.washOrderId == this.washOrderId &&
          other.totalAmount == this.totalAmount &&
          other.completedAt == this.completedAt);
}

class LocalPaymentsCompanion extends UpdateCompanion<LocalPayment> {
  final Value<String> id;
  final Value<String> washOrderId;
  final Value<int> totalAmount;
  final Value<DateTime> completedAt;
  final Value<int> rowid;
  const LocalPaymentsCompanion({
    this.id = const Value.absent(),
    this.washOrderId = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalPaymentsCompanion.insert({
    required String id,
    required String washOrderId,
    required int totalAmount,
    required DateTime completedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       washOrderId = Value(washOrderId),
       totalAmount = Value(totalAmount),
       completedAt = Value(completedAt);
  static Insertable<LocalPayment> custom({
    Expression<String>? id,
    Expression<String>? washOrderId,
    Expression<int>? totalAmount,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (washOrderId != null) 'wash_order_id': washOrderId,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalPaymentsCompanion copyWith({
    Value<String>? id,
    Value<String>? washOrderId,
    Value<int>? totalAmount,
    Value<DateTime>? completedAt,
    Value<int>? rowid,
  }) {
    return LocalPaymentsCompanion(
      id: id ?? this.id,
      washOrderId: washOrderId ?? this.washOrderId,
      totalAmount: totalAmount ?? this.totalAmount,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (washOrderId.present) {
      map['wash_order_id'] = Variable<String>(washOrderId.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<int>(totalAmount.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('washOrderId: $washOrderId, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalPaymentComponentsTable extends LocalPaymentComponents
    with TableInfo<$LocalPaymentComponentsTable, LocalPaymentComponent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPaymentComponentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentIdMeta = const VerificationMeta(
    'paymentId',
  );
  @override
  late final GeneratedColumn<String> paymentId = GeneratedColumn<String>(
    'payment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _externalReferenceMeta = const VerificationMeta(
    'externalReference',
  );
  @override
  late final GeneratedColumn<String> externalReference =
      GeneratedColumn<String>(
        'external_reference',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    paymentId,
    method,
    amount,
    externalReference,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_payment_components';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPaymentComponent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('payment_id')) {
      context.handle(
        _paymentIdMeta,
        paymentId.isAcceptableOrUnknown(data['payment_id']!, _paymentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_paymentIdMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('external_reference')) {
      context.handle(
        _externalReferenceMeta,
        externalReference.isAcceptableOrUnknown(
          data['external_reference']!,
          _externalReferenceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalPaymentComponent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPaymentComponent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      paymentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_id'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      externalReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_reference'],
      ),
    );
  }

  @override
  $LocalPaymentComponentsTable createAlias(String alias) {
    return $LocalPaymentComponentsTable(attachedDatabase, alias);
  }
}

class LocalPaymentComponent extends DataClass
    implements Insertable<LocalPaymentComponent> {
  final String id;
  final String paymentId;
  final String method;
  final int amount;
  final String? externalReference;
  const LocalPaymentComponent({
    required this.id,
    required this.paymentId,
    required this.method,
    required this.amount,
    this.externalReference,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['payment_id'] = Variable<String>(paymentId);
    map['method'] = Variable<String>(method);
    map['amount'] = Variable<int>(amount);
    if (!nullToAbsent || externalReference != null) {
      map['external_reference'] = Variable<String>(externalReference);
    }
    return map;
  }

  LocalPaymentComponentsCompanion toCompanion(bool nullToAbsent) {
    return LocalPaymentComponentsCompanion(
      id: Value(id),
      paymentId: Value(paymentId),
      method: Value(method),
      amount: Value(amount),
      externalReference: externalReference == null && nullToAbsent
          ? const Value.absent()
          : Value(externalReference),
    );
  }

  factory LocalPaymentComponent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPaymentComponent(
      id: serializer.fromJson<String>(json['id']),
      paymentId: serializer.fromJson<String>(json['paymentId']),
      method: serializer.fromJson<String>(json['method']),
      amount: serializer.fromJson<int>(json['amount']),
      externalReference: serializer.fromJson<String?>(
        json['externalReference'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'paymentId': serializer.toJson<String>(paymentId),
      'method': serializer.toJson<String>(method),
      'amount': serializer.toJson<int>(amount),
      'externalReference': serializer.toJson<String?>(externalReference),
    };
  }

  LocalPaymentComponent copyWith({
    String? id,
    String? paymentId,
    String? method,
    int? amount,
    Value<String?> externalReference = const Value.absent(),
  }) => LocalPaymentComponent(
    id: id ?? this.id,
    paymentId: paymentId ?? this.paymentId,
    method: method ?? this.method,
    amount: amount ?? this.amount,
    externalReference: externalReference.present
        ? externalReference.value
        : this.externalReference,
  );
  LocalPaymentComponent copyWithCompanion(
    LocalPaymentComponentsCompanion data,
  ) {
    return LocalPaymentComponent(
      id: data.id.present ? data.id.value : this.id,
      paymentId: data.paymentId.present ? data.paymentId.value : this.paymentId,
      method: data.method.present ? data.method.value : this.method,
      amount: data.amount.present ? data.amount.value : this.amount,
      externalReference: data.externalReference.present
          ? data.externalReference.value
          : this.externalReference,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPaymentComponent(')
          ..write('id: $id, ')
          ..write('paymentId: $paymentId, ')
          ..write('method: $method, ')
          ..write('amount: $amount, ')
          ..write('externalReference: $externalReference')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, paymentId, method, amount, externalReference);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPaymentComponent &&
          other.id == this.id &&
          other.paymentId == this.paymentId &&
          other.method == this.method &&
          other.amount == this.amount &&
          other.externalReference == this.externalReference);
}

class LocalPaymentComponentsCompanion
    extends UpdateCompanion<LocalPaymentComponent> {
  final Value<String> id;
  final Value<String> paymentId;
  final Value<String> method;
  final Value<int> amount;
  final Value<String?> externalReference;
  final Value<int> rowid;
  const LocalPaymentComponentsCompanion({
    this.id = const Value.absent(),
    this.paymentId = const Value.absent(),
    this.method = const Value.absent(),
    this.amount = const Value.absent(),
    this.externalReference = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalPaymentComponentsCompanion.insert({
    required String id,
    required String paymentId,
    required String method,
    required int amount,
    this.externalReference = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       paymentId = Value(paymentId),
       method = Value(method),
       amount = Value(amount);
  static Insertable<LocalPaymentComponent> custom({
    Expression<String>? id,
    Expression<String>? paymentId,
    Expression<String>? method,
    Expression<int>? amount,
    Expression<String>? externalReference,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (paymentId != null) 'payment_id': paymentId,
      if (method != null) 'method': method,
      if (amount != null) 'amount': amount,
      if (externalReference != null) 'external_reference': externalReference,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalPaymentComponentsCompanion copyWith({
    Value<String>? id,
    Value<String>? paymentId,
    Value<String>? method,
    Value<int>? amount,
    Value<String?>? externalReference,
    Value<int>? rowid,
  }) {
    return LocalPaymentComponentsCompanion(
      id: id ?? this.id,
      paymentId: paymentId ?? this.paymentId,
      method: method ?? this.method,
      amount: amount ?? this.amount,
      externalReference: externalReference ?? this.externalReference,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (paymentId.present) {
      map['payment_id'] = Variable<String>(paymentId.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (externalReference.present) {
      map['external_reference'] = Variable<String>(externalReference.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPaymentComponentsCompanion(')
          ..write('id: $id, ')
          ..write('paymentId: $paymentId, ')
          ..write('method: $method, ')
          ..write('amount: $amount, ')
          ..write('externalReference: $externalReference, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingSyncOpsTable extends PendingSyncOps
    with TableInfo<$PendingSyncOpsTable, PendingSyncOp> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingSyncOpsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opTypeMeta = const VerificationMeta('opType');
  @override
  late final GeneratedColumn<String> opType = GeneratedColumn<String>(
    'op_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PENDING'),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    rowId,
    entityType,
    entityId,
    opType,
    payloadJson,
    idempotencyKey,
    createdAt,
    status,
    lastError,
    attemptCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_sync_ops';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingSyncOp> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('op_type')) {
      context.handle(
        _opTypeMeta,
        opType.isAcceptableOrUnknown(data['op_type']!, _opTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_opTypeMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  PendingSyncOp map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingSyncOp(
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      opType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op_type'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
    );
  }

  @override
  $PendingSyncOpsTable createAlias(String alias) {
    return $PendingSyncOpsTable(attachedDatabase, alias);
  }
}

class PendingSyncOp extends DataClass implements Insertable<PendingSyncOp> {
  final int rowId;
  final String entityType;
  final String entityId;
  final String opType;
  final String payloadJson;
  final String idempotencyKey;
  final DateTime createdAt;
  final String status;
  final String? lastError;
  final int attemptCount;
  const PendingSyncOp({
    required this.rowId,
    required this.entityType,
    required this.entityId,
    required this.opType,
    required this.payloadJson,
    required this.idempotencyKey,
    required this.createdAt,
    required this.status,
    this.lastError,
    required this.attemptCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['op_type'] = Variable<String>(opType);
    map['payload_json'] = Variable<String>(payloadJson);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['attempt_count'] = Variable<int>(attemptCount);
    return map;
  }

  PendingSyncOpsCompanion toCompanion(bool nullToAbsent) {
    return PendingSyncOpsCompanion(
      rowId: Value(rowId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      opType: Value(opType),
      payloadJson: Value(payloadJson),
      idempotencyKey: Value(idempotencyKey),
      createdAt: Value(createdAt),
      status: Value(status),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      attemptCount: Value(attemptCount),
    );
  }

  factory PendingSyncOp.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingSyncOp(
      rowId: serializer.fromJson<int>(json['rowId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      opType: serializer.fromJson<String>(json['opType']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'opType': serializer.toJson<String>(opType),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
      'lastError': serializer.toJson<String?>(lastError),
      'attemptCount': serializer.toJson<int>(attemptCount),
    };
  }

  PendingSyncOp copyWith({
    int? rowId,
    String? entityType,
    String? entityId,
    String? opType,
    String? payloadJson,
    String? idempotencyKey,
    DateTime? createdAt,
    String? status,
    Value<String?> lastError = const Value.absent(),
    int? attemptCount,
  }) => PendingSyncOp(
    rowId: rowId ?? this.rowId,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    opType: opType ?? this.opType,
    payloadJson: payloadJson ?? this.payloadJson,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    lastError: lastError.present ? lastError.value : this.lastError,
    attemptCount: attemptCount ?? this.attemptCount,
  );
  PendingSyncOp copyWithCompanion(PendingSyncOpsCompanion data) {
    return PendingSyncOp(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      opType: data.opType.present ? data.opType.value : this.opType,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingSyncOp(')
          ..write('rowId: $rowId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('opType: $opType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('lastError: $lastError, ')
          ..write('attemptCount: $attemptCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rowId,
    entityType,
    entityId,
    opType,
    payloadJson,
    idempotencyKey,
    createdAt,
    status,
    lastError,
    attemptCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingSyncOp &&
          other.rowId == this.rowId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.opType == this.opType &&
          other.payloadJson == this.payloadJson &&
          other.idempotencyKey == this.idempotencyKey &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.lastError == this.lastError &&
          other.attemptCount == this.attemptCount);
}

class PendingSyncOpsCompanion extends UpdateCompanion<PendingSyncOp> {
  final Value<int> rowId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> opType;
  final Value<String> payloadJson;
  final Value<String> idempotencyKey;
  final Value<DateTime> createdAt;
  final Value<String> status;
  final Value<String?> lastError;
  final Value<int> attemptCount;
  const PendingSyncOpsCompanion({
    this.rowId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.opType = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.lastError = const Value.absent(),
    this.attemptCount = const Value.absent(),
  });
  PendingSyncOpsCompanion.insert({
    this.rowId = const Value.absent(),
    required String entityType,
    required String entityId,
    required String opType,
    required String payloadJson,
    required String idempotencyKey,
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.lastError = const Value.absent(),
    this.attemptCount = const Value.absent(),
  }) : entityType = Value(entityType),
       entityId = Value(entityId),
       opType = Value(opType),
       payloadJson = Value(payloadJson),
       idempotencyKey = Value(idempotencyKey);
  static Insertable<PendingSyncOp> custom({
    Expression<int>? rowId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? opType,
    Expression<String>? payloadJson,
    Expression<String>? idempotencyKey,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
    Expression<String>? lastError,
    Expression<int>? attemptCount,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (opType != null) 'op_type': opType,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (lastError != null) 'last_error': lastError,
      if (attemptCount != null) 'attempt_count': attemptCount,
    });
  }

  PendingSyncOpsCompanion copyWith({
    Value<int>? rowId,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? opType,
    Value<String>? payloadJson,
    Value<String>? idempotencyKey,
    Value<DateTime>? createdAt,
    Value<String>? status,
    Value<String?>? lastError,
    Value<int>? attemptCount,
  }) {
    return PendingSyncOpsCompanion(
      rowId: rowId ?? this.rowId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      opType: opType ?? this.opType,
      payloadJson: payloadJson ?? this.payloadJson,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      lastError: lastError ?? this.lastError,
      attemptCount: attemptCount ?? this.attemptCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (opType.present) {
      map['op_type'] = Variable<String>(opType.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingSyncOpsCompanion(')
          ..write('rowId: $rowId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('opType: $opType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('lastError: $lastError, ')
          ..write('attemptCount: $attemptCount')
          ..write(')'))
        .toString();
  }
}

class $SyncMetaTable extends SyncMeta
    with TableInfo<$SyncMetaTable, SyncMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastPulledAtMeta = const VerificationMeta(
    'lastPulledAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastPulledAt = GeneratedColumn<DateTime>(
    'last_pulled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, lastPulledAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('last_pulled_at')) {
      context.handle(
        _lastPulledAtMeta,
        lastPulledAt.isAcceptableOrUnknown(
          data['last_pulled_at']!,
          _lastPulledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastPulledAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetaData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      lastPulledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_pulled_at'],
      )!,
    );
  }

  @override
  $SyncMetaTable createAlias(String alias) {
    return $SyncMetaTable(attachedDatabase, alias);
  }
}

class SyncMetaData extends DataClass implements Insertable<SyncMetaData> {
  final String key;
  final DateTime lastPulledAt;
  const SyncMetaData({required this.key, required this.lastPulledAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['last_pulled_at'] = Variable<DateTime>(lastPulledAt);
    return map;
  }

  SyncMetaCompanion toCompanion(bool nullToAbsent) {
    return SyncMetaCompanion(
      key: Value(key),
      lastPulledAt: Value(lastPulledAt),
    );
  }

  factory SyncMetaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetaData(
      key: serializer.fromJson<String>(json['key']),
      lastPulledAt: serializer.fromJson<DateTime>(json['lastPulledAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'lastPulledAt': serializer.toJson<DateTime>(lastPulledAt),
    };
  }

  SyncMetaData copyWith({String? key, DateTime? lastPulledAt}) => SyncMetaData(
    key: key ?? this.key,
    lastPulledAt: lastPulledAt ?? this.lastPulledAt,
  );
  SyncMetaData copyWithCompanion(SyncMetaCompanion data) {
    return SyncMetaData(
      key: data.key.present ? data.key.value : this.key,
      lastPulledAt: data.lastPulledAt.present
          ? data.lastPulledAt.value
          : this.lastPulledAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaData(')
          ..write('key: $key, ')
          ..write('lastPulledAt: $lastPulledAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, lastPulledAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetaData &&
          other.key == this.key &&
          other.lastPulledAt == this.lastPulledAt);
}

class SyncMetaCompanion extends UpdateCompanion<SyncMetaData> {
  final Value<String> key;
  final Value<DateTime> lastPulledAt;
  final Value<int> rowid;
  const SyncMetaCompanion({
    this.key = const Value.absent(),
    this.lastPulledAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetaCompanion.insert({
    required String key,
    required DateTime lastPulledAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       lastPulledAt = Value(lastPulledAt);
  static Insertable<SyncMetaData> custom({
    Expression<String>? key,
    Expression<DateTime>? lastPulledAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (lastPulledAt != null) 'last_pulled_at': lastPulledAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetaCompanion copyWith({
    Value<String>? key,
    Value<DateTime>? lastPulledAt,
    Value<int>? rowid,
  }) {
    return SyncMetaCompanion(
      key: key ?? this.key,
      lastPulledAt: lastPulledAt ?? this.lastPulledAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (lastPulledAt.present) {
      map['last_pulled_at'] = Variable<DateTime>(lastPulledAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaCompanion(')
          ..write('key: $key, ')
          ..write('lastPulledAt: $lastPulledAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalExpenseCategoriesTable extends LocalExpenseCategories
    with TableInfo<$LocalExpenseCategoriesTable, LocalExpenseCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalExpenseCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_expense_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalExpenseCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalExpenseCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalExpenseCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $LocalExpenseCategoriesTable createAlias(String alias) {
    return $LocalExpenseCategoriesTable(attachedDatabase, alias);
  }
}

class LocalExpenseCategory extends DataClass
    implements Insertable<LocalExpenseCategory> {
  final String id;
  final String name;
  const LocalExpenseCategory({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  LocalExpenseCategoriesCompanion toCompanion(bool nullToAbsent) {
    return LocalExpenseCategoriesCompanion(id: Value(id), name: Value(name));
  }

  factory LocalExpenseCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalExpenseCategory(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  LocalExpenseCategory copyWith({String? id, String? name}) =>
      LocalExpenseCategory(id: id ?? this.id, name: name ?? this.name);
  LocalExpenseCategory copyWithCompanion(LocalExpenseCategoriesCompanion data) {
    return LocalExpenseCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalExpenseCategory(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalExpenseCategory &&
          other.id == this.id &&
          other.name == this.name);
}

class LocalExpenseCategoriesCompanion
    extends UpdateCompanion<LocalExpenseCategory> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const LocalExpenseCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalExpenseCategoriesCompanion.insert({
    required String id,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<LocalExpenseCategory> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalExpenseCategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return LocalExpenseCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalExpenseCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalExpensesTable extends LocalExpenses
    with TableInfo<$LocalExpensesTable, LocalExpense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _branchIdMeta = const VerificationMeta(
    'branchId',
  );
  @override
  late final GeneratedColumn<String> branchId = GeneratedColumn<String>(
    'branch_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    branchId,
    categoryId,
    description,
    amount,
    paymentMethod,
    createdAt,
    dirty,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalExpense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('branch_id')) {
      context.handle(
        _branchIdMeta,
        branchId.isAcceptableOrUnknown(data['branch_id']!, _branchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalExpense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalExpense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      branchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
    );
  }

  @override
  $LocalExpensesTable createAlias(String alias) {
    return $LocalExpensesTable(attachedDatabase, alias);
  }
}

class LocalExpense extends DataClass implements Insertable<LocalExpense> {
  final String id;
  final String branchId;
  final String categoryId;
  final String description;
  final int amount;
  final String paymentMethod;
  final DateTime createdAt;
  final bool dirty;
  const LocalExpense({
    required this.id,
    required this.branchId,
    required this.categoryId,
    required this.description,
    required this.amount,
    required this.paymentMethod,
    required this.createdAt,
    required this.dirty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['branch_id'] = Variable<String>(branchId);
    map['category_id'] = Variable<String>(categoryId);
    map['description'] = Variable<String>(description);
    map['amount'] = Variable<int>(amount);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['dirty'] = Variable<bool>(dirty);
    return map;
  }

  LocalExpensesCompanion toCompanion(bool nullToAbsent) {
    return LocalExpensesCompanion(
      id: Value(id),
      branchId: Value(branchId),
      categoryId: Value(categoryId),
      description: Value(description),
      amount: Value(amount),
      paymentMethod: Value(paymentMethod),
      createdAt: Value(createdAt),
      dirty: Value(dirty),
    );
  }

  factory LocalExpense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalExpense(
      id: serializer.fromJson<String>(json['id']),
      branchId: serializer.fromJson<String>(json['branchId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      description: serializer.fromJson<String>(json['description']),
      amount: serializer.fromJson<int>(json['amount']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'branchId': serializer.toJson<String>(branchId),
      'categoryId': serializer.toJson<String>(categoryId),
      'description': serializer.toJson<String>(description),
      'amount': serializer.toJson<int>(amount),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'dirty': serializer.toJson<bool>(dirty),
    };
  }

  LocalExpense copyWith({
    String? id,
    String? branchId,
    String? categoryId,
    String? description,
    int? amount,
    String? paymentMethod,
    DateTime? createdAt,
    bool? dirty,
  }) => LocalExpense(
    id: id ?? this.id,
    branchId: branchId ?? this.branchId,
    categoryId: categoryId ?? this.categoryId,
    description: description ?? this.description,
    amount: amount ?? this.amount,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    createdAt: createdAt ?? this.createdAt,
    dirty: dirty ?? this.dirty,
  );
  LocalExpense copyWithCompanion(LocalExpensesCompanion data) {
    return LocalExpense(
      id: data.id.present ? data.id.value : this.id,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      description: data.description.present
          ? data.description.value
          : this.description,
      amount: data.amount.present ? data.amount.value : this.amount,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalExpense(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('categoryId: $categoryId, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('createdAt: $createdAt, ')
          ..write('dirty: $dirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    branchId,
    categoryId,
    description,
    amount,
    paymentMethod,
    createdAt,
    dirty,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalExpense &&
          other.id == this.id &&
          other.branchId == this.branchId &&
          other.categoryId == this.categoryId &&
          other.description == this.description &&
          other.amount == this.amount &&
          other.paymentMethod == this.paymentMethod &&
          other.createdAt == this.createdAt &&
          other.dirty == this.dirty);
}

class LocalExpensesCompanion extends UpdateCompanion<LocalExpense> {
  final Value<String> id;
  final Value<String> branchId;
  final Value<String> categoryId;
  final Value<String> description;
  final Value<int> amount;
  final Value<String> paymentMethod;
  final Value<DateTime> createdAt;
  final Value<bool> dirty;
  final Value<int> rowid;
  const LocalExpensesCompanion({
    this.id = const Value.absent(),
    this.branchId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.description = const Value.absent(),
    this.amount = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalExpensesCompanion.insert({
    required String id,
    required String branchId,
    required String categoryId,
    required String description,
    required int amount,
    required String paymentMethod,
    required DateTime createdAt,
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       branchId = Value(branchId),
       categoryId = Value(categoryId),
       description = Value(description),
       amount = Value(amount),
       paymentMethod = Value(paymentMethod),
       createdAt = Value(createdAt);
  static Insertable<LocalExpense> custom({
    Expression<String>? id,
    Expression<String>? branchId,
    Expression<String>? categoryId,
    Expression<String>? description,
    Expression<int>? amount,
    Expression<String>? paymentMethod,
    Expression<DateTime>? createdAt,
    Expression<bool>? dirty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (branchId != null) 'branch_id': branchId,
      if (categoryId != null) 'category_id': categoryId,
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (createdAt != null) 'created_at': createdAt,
      if (dirty != null) 'dirty': dirty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalExpensesCompanion copyWith({
    Value<String>? id,
    Value<String>? branchId,
    Value<String>? categoryId,
    Value<String>? description,
    Value<int>? amount,
    Value<String>? paymentMethod,
    Value<DateTime>? createdAt,
    Value<bool>? dirty,
    Value<int>? rowid,
  }) {
    return LocalExpensesCompanion(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      dirty: dirty ?? this.dirty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<String>(branchId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalExpensesCompanion(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('categoryId: $categoryId, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('createdAt: $createdAt, ')
          ..write('dirty: $dirty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalPrepaidPackagesTable extends LocalPrepaidPackages
    with TableInfo<$LocalPrepaidPackagesTable, LocalPrepaidPackage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPrepaidPackagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eligibleTiersMeta = const VerificationMeta(
    'eligibleTiers',
  );
  @override
  late final GeneratedColumn<String> eligibleTiers = GeneratedColumn<String>(
    'eligible_tiers',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _washCountMeta = const VerificationMeta(
    'washCount',
  );
  @override
  late final GeneratedColumn<int> washCount = GeneratedColumn<int>(
    'wash_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int> price = GeneratedColumn<int>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _validityDaysMeta = const VerificationMeta(
    'validityDays',
  );
  @override
  late final GeneratedColumn<int> validityDays = GeneratedColumn<int>(
    'validity_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _applicableScopeMeta = const VerificationMeta(
    'applicableScope',
  );
  @override
  late final GeneratedColumn<String> applicableScope = GeneratedColumn<String>(
    'applicable_scope',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    eligibleTiers,
    washCount,
    price,
    validityDays,
    applicableScope,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_prepaid_packages';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPrepaidPackage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('eligible_tiers')) {
      context.handle(
        _eligibleTiersMeta,
        eligibleTiers.isAcceptableOrUnknown(
          data['eligible_tiers']!,
          _eligibleTiersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_eligibleTiersMeta);
    }
    if (data.containsKey('wash_count')) {
      context.handle(
        _washCountMeta,
        washCount.isAcceptableOrUnknown(data['wash_count']!, _washCountMeta),
      );
    } else if (isInserting) {
      context.missing(_washCountMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('validity_days')) {
      context.handle(
        _validityDaysMeta,
        validityDays.isAcceptableOrUnknown(
          data['validity_days']!,
          _validityDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_validityDaysMeta);
    }
    if (data.containsKey('applicable_scope')) {
      context.handle(
        _applicableScopeMeta,
        applicableScope.isAcceptableOrUnknown(
          data['applicable_scope']!,
          _applicableScopeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_applicableScopeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalPrepaidPackage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPrepaidPackage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      eligibleTiers: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}eligible_tiers'],
      )!,
      washCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wash_count'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price'],
      )!,
      validityDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}validity_days'],
      )!,
      applicableScope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}applicable_scope'],
      )!,
    );
  }

  @override
  $LocalPrepaidPackagesTable createAlias(String alias) {
    return $LocalPrepaidPackagesTable(attachedDatabase, alias);
  }
}

class LocalPrepaidPackage extends DataClass
    implements Insertable<LocalPrepaidPackage> {
  final String id;
  final String name;
  final String eligibleTiers;
  final int washCount;
  final int price;
  final int validityDays;
  final String applicableScope;
  const LocalPrepaidPackage({
    required this.id,
    required this.name,
    required this.eligibleTiers,
    required this.washCount,
    required this.price,
    required this.validityDays,
    required this.applicableScope,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['eligible_tiers'] = Variable<String>(eligibleTiers);
    map['wash_count'] = Variable<int>(washCount);
    map['price'] = Variable<int>(price);
    map['validity_days'] = Variable<int>(validityDays);
    map['applicable_scope'] = Variable<String>(applicableScope);
    return map;
  }

  LocalPrepaidPackagesCompanion toCompanion(bool nullToAbsent) {
    return LocalPrepaidPackagesCompanion(
      id: Value(id),
      name: Value(name),
      eligibleTiers: Value(eligibleTiers),
      washCount: Value(washCount),
      price: Value(price),
      validityDays: Value(validityDays),
      applicableScope: Value(applicableScope),
    );
  }

  factory LocalPrepaidPackage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPrepaidPackage(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      eligibleTiers: serializer.fromJson<String>(json['eligibleTiers']),
      washCount: serializer.fromJson<int>(json['washCount']),
      price: serializer.fromJson<int>(json['price']),
      validityDays: serializer.fromJson<int>(json['validityDays']),
      applicableScope: serializer.fromJson<String>(json['applicableScope']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'eligibleTiers': serializer.toJson<String>(eligibleTiers),
      'washCount': serializer.toJson<int>(washCount),
      'price': serializer.toJson<int>(price),
      'validityDays': serializer.toJson<int>(validityDays),
      'applicableScope': serializer.toJson<String>(applicableScope),
    };
  }

  LocalPrepaidPackage copyWith({
    String? id,
    String? name,
    String? eligibleTiers,
    int? washCount,
    int? price,
    int? validityDays,
    String? applicableScope,
  }) => LocalPrepaidPackage(
    id: id ?? this.id,
    name: name ?? this.name,
    eligibleTiers: eligibleTiers ?? this.eligibleTiers,
    washCount: washCount ?? this.washCount,
    price: price ?? this.price,
    validityDays: validityDays ?? this.validityDays,
    applicableScope: applicableScope ?? this.applicableScope,
  );
  LocalPrepaidPackage copyWithCompanion(LocalPrepaidPackagesCompanion data) {
    return LocalPrepaidPackage(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      eligibleTiers: data.eligibleTiers.present
          ? data.eligibleTiers.value
          : this.eligibleTiers,
      washCount: data.washCount.present ? data.washCount.value : this.washCount,
      price: data.price.present ? data.price.value : this.price,
      validityDays: data.validityDays.present
          ? data.validityDays.value
          : this.validityDays,
      applicableScope: data.applicableScope.present
          ? data.applicableScope.value
          : this.applicableScope,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPrepaidPackage(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('eligibleTiers: $eligibleTiers, ')
          ..write('washCount: $washCount, ')
          ..write('price: $price, ')
          ..write('validityDays: $validityDays, ')
          ..write('applicableScope: $applicableScope')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    eligibleTiers,
    washCount,
    price,
    validityDays,
    applicableScope,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPrepaidPackage &&
          other.id == this.id &&
          other.name == this.name &&
          other.eligibleTiers == this.eligibleTiers &&
          other.washCount == this.washCount &&
          other.price == this.price &&
          other.validityDays == this.validityDays &&
          other.applicableScope == this.applicableScope);
}

class LocalPrepaidPackagesCompanion
    extends UpdateCompanion<LocalPrepaidPackage> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> eligibleTiers;
  final Value<int> washCount;
  final Value<int> price;
  final Value<int> validityDays;
  final Value<String> applicableScope;
  final Value<int> rowid;
  const LocalPrepaidPackagesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.eligibleTiers = const Value.absent(),
    this.washCount = const Value.absent(),
    this.price = const Value.absent(),
    this.validityDays = const Value.absent(),
    this.applicableScope = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalPrepaidPackagesCompanion.insert({
    required String id,
    required String name,
    required String eligibleTiers,
    required int washCount,
    required int price,
    required int validityDays,
    required String applicableScope,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       eligibleTiers = Value(eligibleTiers),
       washCount = Value(washCount),
       price = Value(price),
       validityDays = Value(validityDays),
       applicableScope = Value(applicableScope);
  static Insertable<LocalPrepaidPackage> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? eligibleTiers,
    Expression<int>? washCount,
    Expression<int>? price,
    Expression<int>? validityDays,
    Expression<String>? applicableScope,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (eligibleTiers != null) 'eligible_tiers': eligibleTiers,
      if (washCount != null) 'wash_count': washCount,
      if (price != null) 'price': price,
      if (validityDays != null) 'validity_days': validityDays,
      if (applicableScope != null) 'applicable_scope': applicableScope,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalPrepaidPackagesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? eligibleTiers,
    Value<int>? washCount,
    Value<int>? price,
    Value<int>? validityDays,
    Value<String>? applicableScope,
    Value<int>? rowid,
  }) {
    return LocalPrepaidPackagesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      eligibleTiers: eligibleTiers ?? this.eligibleTiers,
      washCount: washCount ?? this.washCount,
      price: price ?? this.price,
      validityDays: validityDays ?? this.validityDays,
      applicableScope: applicableScope ?? this.applicableScope,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (eligibleTiers.present) {
      map['eligible_tiers'] = Variable<String>(eligibleTiers.value);
    }
    if (washCount.present) {
      map['wash_count'] = Variable<int>(washCount.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (validityDays.present) {
      map['validity_days'] = Variable<int>(validityDays.value);
    }
    if (applicableScope.present) {
      map['applicable_scope'] = Variable<String>(applicableScope.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPrepaidPackagesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('eligibleTiers: $eligibleTiers, ')
          ..write('washCount: $washCount, ')
          ..write('price: $price, ')
          ..write('validityDays: $validityDays, ')
          ..write('applicableScope: $applicableScope, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalPrepaidWalletsTable extends LocalPrepaidWallets
    with TableInfo<$LocalPrepaidWalletsTable, LocalPrepaidWallet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPrepaidWalletsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balanceMeta = const VerificationMeta(
    'balance',
  );
  @override
  late final GeneratedColumn<int> balance = GeneratedColumn<int>(
    'balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _asOfMeta = const VerificationMeta('asOf');
  @override
  late final GeneratedColumn<DateTime> asOf = GeneratedColumn<DateTime>(
    'as_of',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [customerId, balance, asOf];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_prepaid_wallets';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPrepaidWallet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('balance')) {
      context.handle(
        _balanceMeta,
        balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta),
      );
    } else if (isInserting) {
      context.missing(_balanceMeta);
    }
    if (data.containsKey('as_of')) {
      context.handle(
        _asOfMeta,
        asOf.isAcceptableOrUnknown(data['as_of']!, _asOfMeta),
      );
    } else if (isInserting) {
      context.missing(_asOfMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {customerId};
  @override
  LocalPrepaidWallet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPrepaidWallet(
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      balance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance'],
      )!,
      asOf: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}as_of'],
      )!,
    );
  }

  @override
  $LocalPrepaidWalletsTable createAlias(String alias) {
    return $LocalPrepaidWalletsTable(attachedDatabase, alias);
  }
}

class LocalPrepaidWallet extends DataClass
    implements Insertable<LocalPrepaidWallet> {
  final String customerId;
  final int balance;
  final DateTime asOf;
  const LocalPrepaidWallet({
    required this.customerId,
    required this.balance,
    required this.asOf,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['customer_id'] = Variable<String>(customerId);
    map['balance'] = Variable<int>(balance);
    map['as_of'] = Variable<DateTime>(asOf);
    return map;
  }

  LocalPrepaidWalletsCompanion toCompanion(bool nullToAbsent) {
    return LocalPrepaidWalletsCompanion(
      customerId: Value(customerId),
      balance: Value(balance),
      asOf: Value(asOf),
    );
  }

  factory LocalPrepaidWallet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPrepaidWallet(
      customerId: serializer.fromJson<String>(json['customerId']),
      balance: serializer.fromJson<int>(json['balance']),
      asOf: serializer.fromJson<DateTime>(json['asOf']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'customerId': serializer.toJson<String>(customerId),
      'balance': serializer.toJson<int>(balance),
      'asOf': serializer.toJson<DateTime>(asOf),
    };
  }

  LocalPrepaidWallet copyWith({
    String? customerId,
    int? balance,
    DateTime? asOf,
  }) => LocalPrepaidWallet(
    customerId: customerId ?? this.customerId,
    balance: balance ?? this.balance,
    asOf: asOf ?? this.asOf,
  );
  LocalPrepaidWallet copyWithCompanion(LocalPrepaidWalletsCompanion data) {
    return LocalPrepaidWallet(
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      balance: data.balance.present ? data.balance.value : this.balance,
      asOf: data.asOf.present ? data.asOf.value : this.asOf,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPrepaidWallet(')
          ..write('customerId: $customerId, ')
          ..write('balance: $balance, ')
          ..write('asOf: $asOf')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(customerId, balance, asOf);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPrepaidWallet &&
          other.customerId == this.customerId &&
          other.balance == this.balance &&
          other.asOf == this.asOf);
}

class LocalPrepaidWalletsCompanion extends UpdateCompanion<LocalPrepaidWallet> {
  final Value<String> customerId;
  final Value<int> balance;
  final Value<DateTime> asOf;
  final Value<int> rowid;
  const LocalPrepaidWalletsCompanion({
    this.customerId = const Value.absent(),
    this.balance = const Value.absent(),
    this.asOf = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalPrepaidWalletsCompanion.insert({
    required String customerId,
    required int balance,
    required DateTime asOf,
    this.rowid = const Value.absent(),
  }) : customerId = Value(customerId),
       balance = Value(balance),
       asOf = Value(asOf);
  static Insertable<LocalPrepaidWallet> custom({
    Expression<String>? customerId,
    Expression<int>? balance,
    Expression<DateTime>? asOf,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (customerId != null) 'customer_id': customerId,
      if (balance != null) 'balance': balance,
      if (asOf != null) 'as_of': asOf,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalPrepaidWalletsCompanion copyWith({
    Value<String>? customerId,
    Value<int>? balance,
    Value<DateTime>? asOf,
    Value<int>? rowid,
  }) {
    return LocalPrepaidWalletsCompanion(
      customerId: customerId ?? this.customerId,
      balance: balance ?? this.balance,
      asOf: asOf ?? this.asOf,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (balance.present) {
      map['balance'] = Variable<int>(balance.value);
    }
    if (asOf.present) {
      map['as_of'] = Variable<DateTime>(asOf.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPrepaidWalletsCompanion(')
          ..write('customerId: $customerId, ')
          ..write('balance: $balance, ')
          ..write('asOf: $asOf, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalPrepaidWalletLedgerTable extends LocalPrepaidWalletLedger
    with
        TableInfo<
          $LocalPrepaidWalletLedgerTable,
          LocalPrepaidWalletLedgerData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPrepaidWalletLedgerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entryTypeMeta = const VerificationMeta(
    'entryType',
  );
  @override
  late final GeneratedColumn<String> entryType = GeneratedColumn<String>(
    'entry_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balanceAfterMeta = const VerificationMeta(
    'balanceAfter',
  );
  @override
  late final GeneratedColumn<int> balanceAfter = GeneratedColumn<int>(
    'balance_after',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _createdByIdMeta = const VerificationMeta(
    'createdById',
  );
  @override
  late final GeneratedColumn<String> createdById = GeneratedColumn<String>(
    'created_by_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientEntryIdMeta = const VerificationMeta(
    'clientEntryId',
  );
  @override
  late final GeneratedColumn<String> clientEntryId = GeneratedColumn<String>(
    'client_entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerId,
    entryType,
    amount,
    balanceAfter,
    method,
    reference,
    createdAt,
    createdById,
    clientEntryId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_prepaid_wallet_ledger';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPrepaidWalletLedgerData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('entry_type')) {
      context.handle(
        _entryTypeMeta,
        entryType.isAcceptableOrUnknown(data['entry_type']!, _entryTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entryTypeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('balance_after')) {
      context.handle(
        _balanceAfterMeta,
        balanceAfter.isAcceptableOrUnknown(
          data['balance_after']!,
          _balanceAfterMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_balanceAfterMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('created_by_id')) {
      context.handle(
        _createdByIdMeta,
        createdById.isAcceptableOrUnknown(
          data['created_by_id']!,
          _createdByIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdByIdMeta);
    }
    if (data.containsKey('client_entry_id')) {
      context.handle(
        _clientEntryIdMeta,
        clientEntryId.isAcceptableOrUnknown(
          data['client_entry_id']!,
          _clientEntryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientEntryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalPrepaidWalletLedgerData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPrepaidWalletLedgerData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      entryType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_type'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      balanceAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance_after'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      ),
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdById: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by_id'],
      )!,
      clientEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_entry_id'],
      )!,
    );
  }

  @override
  $LocalPrepaidWalletLedgerTable createAlias(String alias) {
    return $LocalPrepaidWalletLedgerTable(attachedDatabase, alias);
  }
}

class LocalPrepaidWalletLedgerData extends DataClass
    implements Insertable<LocalPrepaidWalletLedgerData> {
  final String id;
  final String customerId;
  final String entryType;
  final int amount;
  final int balanceAfter;
  final String? method;
  final String? reference;
  final DateTime createdAt;
  final String createdById;
  final String clientEntryId;
  const LocalPrepaidWalletLedgerData({
    required this.id,
    required this.customerId,
    required this.entryType,
    required this.amount,
    required this.balanceAfter,
    this.method,
    this.reference,
    required this.createdAt,
    required this.createdById,
    required this.clientEntryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['customer_id'] = Variable<String>(customerId);
    map['entry_type'] = Variable<String>(entryType);
    map['amount'] = Variable<int>(amount);
    map['balance_after'] = Variable<int>(balanceAfter);
    if (!nullToAbsent || method != null) {
      map['method'] = Variable<String>(method);
    }
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by_id'] = Variable<String>(createdById);
    map['client_entry_id'] = Variable<String>(clientEntryId);
    return map;
  }

  LocalPrepaidWalletLedgerCompanion toCompanion(bool nullToAbsent) {
    return LocalPrepaidWalletLedgerCompanion(
      id: Value(id),
      customerId: Value(customerId),
      entryType: Value(entryType),
      amount: Value(amount),
      balanceAfter: Value(balanceAfter),
      method: method == null && nullToAbsent
          ? const Value.absent()
          : Value(method),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      createdAt: Value(createdAt),
      createdById: Value(createdById),
      clientEntryId: Value(clientEntryId),
    );
  }

  factory LocalPrepaidWalletLedgerData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPrepaidWalletLedgerData(
      id: serializer.fromJson<String>(json['id']),
      customerId: serializer.fromJson<String>(json['customerId']),
      entryType: serializer.fromJson<String>(json['entryType']),
      amount: serializer.fromJson<int>(json['amount']),
      balanceAfter: serializer.fromJson<int>(json['balanceAfter']),
      method: serializer.fromJson<String?>(json['method']),
      reference: serializer.fromJson<String?>(json['reference']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdById: serializer.fromJson<String>(json['createdById']),
      clientEntryId: serializer.fromJson<String>(json['clientEntryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerId': serializer.toJson<String>(customerId),
      'entryType': serializer.toJson<String>(entryType),
      'amount': serializer.toJson<int>(amount),
      'balanceAfter': serializer.toJson<int>(balanceAfter),
      'method': serializer.toJson<String?>(method),
      'reference': serializer.toJson<String?>(reference),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdById': serializer.toJson<String>(createdById),
      'clientEntryId': serializer.toJson<String>(clientEntryId),
    };
  }

  LocalPrepaidWalletLedgerData copyWith({
    String? id,
    String? customerId,
    String? entryType,
    int? amount,
    int? balanceAfter,
    Value<String?> method = const Value.absent(),
    Value<String?> reference = const Value.absent(),
    DateTime? createdAt,
    String? createdById,
    String? clientEntryId,
  }) => LocalPrepaidWalletLedgerData(
    id: id ?? this.id,
    customerId: customerId ?? this.customerId,
    entryType: entryType ?? this.entryType,
    amount: amount ?? this.amount,
    balanceAfter: balanceAfter ?? this.balanceAfter,
    method: method.present ? method.value : this.method,
    reference: reference.present ? reference.value : this.reference,
    createdAt: createdAt ?? this.createdAt,
    createdById: createdById ?? this.createdById,
    clientEntryId: clientEntryId ?? this.clientEntryId,
  );
  LocalPrepaidWalletLedgerData copyWithCompanion(
    LocalPrepaidWalletLedgerCompanion data,
  ) {
    return LocalPrepaidWalletLedgerData(
      id: data.id.present ? data.id.value : this.id,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      entryType: data.entryType.present ? data.entryType.value : this.entryType,
      amount: data.amount.present ? data.amount.value : this.amount,
      balanceAfter: data.balanceAfter.present
          ? data.balanceAfter.value
          : this.balanceAfter,
      method: data.method.present ? data.method.value : this.method,
      reference: data.reference.present ? data.reference.value : this.reference,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdById: data.createdById.present
          ? data.createdById.value
          : this.createdById,
      clientEntryId: data.clientEntryId.present
          ? data.clientEntryId.value
          : this.clientEntryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPrepaidWalletLedgerData(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('entryType: $entryType, ')
          ..write('amount: $amount, ')
          ..write('balanceAfter: $balanceAfter, ')
          ..write('method: $method, ')
          ..write('reference: $reference, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdById: $createdById, ')
          ..write('clientEntryId: $clientEntryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerId,
    entryType,
    amount,
    balanceAfter,
    method,
    reference,
    createdAt,
    createdById,
    clientEntryId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPrepaidWalletLedgerData &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.entryType == this.entryType &&
          other.amount == this.amount &&
          other.balanceAfter == this.balanceAfter &&
          other.method == this.method &&
          other.reference == this.reference &&
          other.createdAt == this.createdAt &&
          other.createdById == this.createdById &&
          other.clientEntryId == this.clientEntryId);
}

class LocalPrepaidWalletLedgerCompanion
    extends UpdateCompanion<LocalPrepaidWalletLedgerData> {
  final Value<String> id;
  final Value<String> customerId;
  final Value<String> entryType;
  final Value<int> amount;
  final Value<int> balanceAfter;
  final Value<String?> method;
  final Value<String?> reference;
  final Value<DateTime> createdAt;
  final Value<String> createdById;
  final Value<String> clientEntryId;
  final Value<int> rowid;
  const LocalPrepaidWalletLedgerCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.entryType = const Value.absent(),
    this.amount = const Value.absent(),
    this.balanceAfter = const Value.absent(),
    this.method = const Value.absent(),
    this.reference = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdById = const Value.absent(),
    this.clientEntryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalPrepaidWalletLedgerCompanion.insert({
    required String id,
    required String customerId,
    required String entryType,
    required int amount,
    required int balanceAfter,
    this.method = const Value.absent(),
    this.reference = const Value.absent(),
    this.createdAt = const Value.absent(),
    required String createdById,
    required String clientEntryId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       customerId = Value(customerId),
       entryType = Value(entryType),
       amount = Value(amount),
       balanceAfter = Value(balanceAfter),
       createdById = Value(createdById),
       clientEntryId = Value(clientEntryId);
  static Insertable<LocalPrepaidWalletLedgerData> custom({
    Expression<String>? id,
    Expression<String>? customerId,
    Expression<String>? entryType,
    Expression<int>? amount,
    Expression<int>? balanceAfter,
    Expression<String>? method,
    Expression<String>? reference,
    Expression<DateTime>? createdAt,
    Expression<String>? createdById,
    Expression<String>? clientEntryId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (entryType != null) 'entry_type': entryType,
      if (amount != null) 'amount': amount,
      if (balanceAfter != null) 'balance_after': balanceAfter,
      if (method != null) 'method': method,
      if (reference != null) 'reference': reference,
      if (createdAt != null) 'created_at': createdAt,
      if (createdById != null) 'created_by_id': createdById,
      if (clientEntryId != null) 'client_entry_id': clientEntryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalPrepaidWalletLedgerCompanion copyWith({
    Value<String>? id,
    Value<String>? customerId,
    Value<String>? entryType,
    Value<int>? amount,
    Value<int>? balanceAfter,
    Value<String?>? method,
    Value<String?>? reference,
    Value<DateTime>? createdAt,
    Value<String>? createdById,
    Value<String>? clientEntryId,
    Value<int>? rowid,
  }) {
    return LocalPrepaidWalletLedgerCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      entryType: entryType ?? this.entryType,
      amount: amount ?? this.amount,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      method: method ?? this.method,
      reference: reference ?? this.reference,
      createdAt: createdAt ?? this.createdAt,
      createdById: createdById ?? this.createdById,
      clientEntryId: clientEntryId ?? this.clientEntryId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (entryType.present) {
      map['entry_type'] = Variable<String>(entryType.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (balanceAfter.present) {
      map['balance_after'] = Variable<int>(balanceAfter.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdById.present) {
      map['created_by_id'] = Variable<String>(createdById.value);
    }
    if (clientEntryId.present) {
      map['client_entry_id'] = Variable<String>(clientEntryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPrepaidWalletLedgerCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('entryType: $entryType, ')
          ..write('amount: $amount, ')
          ..write('balanceAfter: $balanceAfter, ')
          ..write('method: $method, ')
          ..write('reference: $reference, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdById: $createdById, ')
          ..write('clientEntryId: $clientEntryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalPrepaidPackagePurchasesTable extends LocalPrepaidPackagePurchases
    with
        TableInfo<
          $LocalPrepaidPackagePurchasesTable,
          LocalPrepaidPackagePurchase
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPrepaidPackagePurchasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packageIdMeta = const VerificationMeta(
    'packageId',
  );
  @override
  late final GeneratedColumn<String> packageId = GeneratedColumn<String>(
    'package_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchasedAtMeta = const VerificationMeta(
    'purchasedAt',
  );
  @override
  late final GeneratedColumn<DateTime> purchasedAt = GeneratedColumn<DateTime>(
    'purchased_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remainingCountMeta = const VerificationMeta(
    'remainingCount',
  );
  @override
  late final GeneratedColumn<int> remainingCount = GeneratedColumn<int>(
    'remaining_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packageId,
    customerId,
    vehicleId,
    purchasedAt,
    expiresAt,
    remainingCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_prepaid_package_purchases';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPrepaidPackagePurchase> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('package_id')) {
      context.handle(
        _packageIdMeta,
        packageId.isAcceptableOrUnknown(data['package_id']!, _packageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packageIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    }
    if (data.containsKey('purchased_at')) {
      context.handle(
        _purchasedAtMeta,
        purchasedAt.isAcceptableOrUnknown(
          data['purchased_at']!,
          _purchasedAtMeta,
        ),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    if (data.containsKey('remaining_count')) {
      context.handle(
        _remainingCountMeta,
        remainingCount.isAcceptableOrUnknown(
          data['remaining_count']!,
          _remainingCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remainingCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalPrepaidPackagePurchase map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPrepaidPackagePurchase(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      ),
      purchasedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchased_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      )!,
      remainingCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remaining_count'],
      )!,
    );
  }

  @override
  $LocalPrepaidPackagePurchasesTable createAlias(String alias) {
    return $LocalPrepaidPackagePurchasesTable(attachedDatabase, alias);
  }
}

class LocalPrepaidPackagePurchase extends DataClass
    implements Insertable<LocalPrepaidPackagePurchase> {
  final String id;
  final String packageId;
  final String customerId;
  final String? vehicleId;
  final DateTime purchasedAt;
  final DateTime expiresAt;
  final int remainingCount;
  const LocalPrepaidPackagePurchase({
    required this.id,
    required this.packageId,
    required this.customerId,
    this.vehicleId,
    required this.purchasedAt,
    required this.expiresAt,
    required this.remainingCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['package_id'] = Variable<String>(packageId);
    map['customer_id'] = Variable<String>(customerId);
    if (!nullToAbsent || vehicleId != null) {
      map['vehicle_id'] = Variable<String>(vehicleId);
    }
    map['purchased_at'] = Variable<DateTime>(purchasedAt);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    map['remaining_count'] = Variable<int>(remainingCount);
    return map;
  }

  LocalPrepaidPackagePurchasesCompanion toCompanion(bool nullToAbsent) {
    return LocalPrepaidPackagePurchasesCompanion(
      id: Value(id),
      packageId: Value(packageId),
      customerId: Value(customerId),
      vehicleId: vehicleId == null && nullToAbsent
          ? const Value.absent()
          : Value(vehicleId),
      purchasedAt: Value(purchasedAt),
      expiresAt: Value(expiresAt),
      remainingCount: Value(remainingCount),
    );
  }

  factory LocalPrepaidPackagePurchase.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPrepaidPackagePurchase(
      id: serializer.fromJson<String>(json['id']),
      packageId: serializer.fromJson<String>(json['packageId']),
      customerId: serializer.fromJson<String>(json['customerId']),
      vehicleId: serializer.fromJson<String?>(json['vehicleId']),
      purchasedAt: serializer.fromJson<DateTime>(json['purchasedAt']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
      remainingCount: serializer.fromJson<int>(json['remainingCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packageId': serializer.toJson<String>(packageId),
      'customerId': serializer.toJson<String>(customerId),
      'vehicleId': serializer.toJson<String?>(vehicleId),
      'purchasedAt': serializer.toJson<DateTime>(purchasedAt),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
      'remainingCount': serializer.toJson<int>(remainingCount),
    };
  }

  LocalPrepaidPackagePurchase copyWith({
    String? id,
    String? packageId,
    String? customerId,
    Value<String?> vehicleId = const Value.absent(),
    DateTime? purchasedAt,
    DateTime? expiresAt,
    int? remainingCount,
  }) => LocalPrepaidPackagePurchase(
    id: id ?? this.id,
    packageId: packageId ?? this.packageId,
    customerId: customerId ?? this.customerId,
    vehicleId: vehicleId.present ? vehicleId.value : this.vehicleId,
    purchasedAt: purchasedAt ?? this.purchasedAt,
    expiresAt: expiresAt ?? this.expiresAt,
    remainingCount: remainingCount ?? this.remainingCount,
  );
  LocalPrepaidPackagePurchase copyWithCompanion(
    LocalPrepaidPackagePurchasesCompanion data,
  ) {
    return LocalPrepaidPackagePurchase(
      id: data.id.present ? data.id.value : this.id,
      packageId: data.packageId.present ? data.packageId.value : this.packageId,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      purchasedAt: data.purchasedAt.present
          ? data.purchasedAt.value
          : this.purchasedAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      remainingCount: data.remainingCount.present
          ? data.remainingCount.value
          : this.remainingCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPrepaidPackagePurchase(')
          ..write('id: $id, ')
          ..write('packageId: $packageId, ')
          ..write('customerId: $customerId, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('remainingCount: $remainingCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    packageId,
    customerId,
    vehicleId,
    purchasedAt,
    expiresAt,
    remainingCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPrepaidPackagePurchase &&
          other.id == this.id &&
          other.packageId == this.packageId &&
          other.customerId == this.customerId &&
          other.vehicleId == this.vehicleId &&
          other.purchasedAt == this.purchasedAt &&
          other.expiresAt == this.expiresAt &&
          other.remainingCount == this.remainingCount);
}

class LocalPrepaidPackagePurchasesCompanion
    extends UpdateCompanion<LocalPrepaidPackagePurchase> {
  final Value<String> id;
  final Value<String> packageId;
  final Value<String> customerId;
  final Value<String?> vehicleId;
  final Value<DateTime> purchasedAt;
  final Value<DateTime> expiresAt;
  final Value<int> remainingCount;
  final Value<int> rowid;
  const LocalPrepaidPackagePurchasesCompanion({
    this.id = const Value.absent(),
    this.packageId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.remainingCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalPrepaidPackagePurchasesCompanion.insert({
    required String id,
    required String packageId,
    required String customerId,
    this.vehicleId = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    required DateTime expiresAt,
    required int remainingCount,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packageId = Value(packageId),
       customerId = Value(customerId),
       expiresAt = Value(expiresAt),
       remainingCount = Value(remainingCount);
  static Insertable<LocalPrepaidPackagePurchase> custom({
    Expression<String>? id,
    Expression<String>? packageId,
    Expression<String>? customerId,
    Expression<String>? vehicleId,
    Expression<DateTime>? purchasedAt,
    Expression<DateTime>? expiresAt,
    Expression<int>? remainingCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packageId != null) 'package_id': packageId,
      if (customerId != null) 'customer_id': customerId,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (purchasedAt != null) 'purchased_at': purchasedAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (remainingCount != null) 'remaining_count': remainingCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalPrepaidPackagePurchasesCompanion copyWith({
    Value<String>? id,
    Value<String>? packageId,
    Value<String>? customerId,
    Value<String?>? vehicleId,
    Value<DateTime>? purchasedAt,
    Value<DateTime>? expiresAt,
    Value<int>? remainingCount,
    Value<int>? rowid,
  }) {
    return LocalPrepaidPackagePurchasesCompanion(
      id: id ?? this.id,
      packageId: packageId ?? this.packageId,
      customerId: customerId ?? this.customerId,
      vehicleId: vehicleId ?? this.vehicleId,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      remainingCount: remainingCount ?? this.remainingCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packageId.present) {
      map['package_id'] = Variable<String>(packageId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (purchasedAt.present) {
      map['purchased_at'] = Variable<DateTime>(purchasedAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (remainingCount.present) {
      map['remaining_count'] = Variable<int>(remainingCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPrepaidPackagePurchasesCompanion(')
          ..write('id: $id, ')
          ..write('packageId: $packageId, ')
          ..write('customerId: $customerId, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('remainingCount: $remainingCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalPrepaidPackageUsageTable extends LocalPrepaidPackageUsage
    with
        TableInfo<
          $LocalPrepaidPackageUsageTable,
          LocalPrepaidPackageUsageData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPrepaidPackageUsageTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchaseIdMeta = const VerificationMeta(
    'purchaseId',
  );
  @override
  late final GeneratedColumn<String> purchaseId = GeneratedColumn<String>(
    'purchase_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _washOrderIdMeta = const VerificationMeta(
    'washOrderId',
  );
  @override
  late final GeneratedColumn<String> washOrderId = GeneratedColumn<String>(
    'wash_order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usedAtMeta = const VerificationMeta('usedAt');
  @override
  late final GeneratedColumn<DateTime> usedAt = GeneratedColumn<DateTime>(
    'used_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _usedByIdMeta = const VerificationMeta(
    'usedById',
  );
  @override
  late final GeneratedColumn<String> usedById = GeneratedColumn<String>(
    'used_by_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientEntryIdMeta = const VerificationMeta(
    'clientEntryId',
  );
  @override
  late final GeneratedColumn<String> clientEntryId = GeneratedColumn<String>(
    'client_entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    purchaseId,
    washOrderId,
    vehicleId,
    usedAt,
    usedById,
    clientEntryId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_prepaid_package_usage';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPrepaidPackageUsageData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
        _purchaseIdMeta,
        purchaseId.isAcceptableOrUnknown(data['purchase_id']!, _purchaseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_purchaseIdMeta);
    }
    if (data.containsKey('wash_order_id')) {
      context.handle(
        _washOrderIdMeta,
        washOrderId.isAcceptableOrUnknown(
          data['wash_order_id']!,
          _washOrderIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_washOrderIdMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('used_at')) {
      context.handle(
        _usedAtMeta,
        usedAt.isAcceptableOrUnknown(data['used_at']!, _usedAtMeta),
      );
    }
    if (data.containsKey('used_by_id')) {
      context.handle(
        _usedByIdMeta,
        usedById.isAcceptableOrUnknown(data['used_by_id']!, _usedByIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usedByIdMeta);
    }
    if (data.containsKey('client_entry_id')) {
      context.handle(
        _clientEntryIdMeta,
        clientEntryId.isAcceptableOrUnknown(
          data['client_entry_id']!,
          _clientEntryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientEntryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalPrepaidPackageUsageData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPrepaidPackageUsageData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      purchaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_id'],
      )!,
      washOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wash_order_id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      usedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}used_at'],
      )!,
      usedById: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}used_by_id'],
      )!,
      clientEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_entry_id'],
      )!,
    );
  }

  @override
  $LocalPrepaidPackageUsageTable createAlias(String alias) {
    return $LocalPrepaidPackageUsageTable(attachedDatabase, alias);
  }
}

class LocalPrepaidPackageUsageData extends DataClass
    implements Insertable<LocalPrepaidPackageUsageData> {
  final String id;
  final String purchaseId;
  final String washOrderId;
  final String vehicleId;
  final DateTime usedAt;
  final String usedById;
  final String clientEntryId;
  const LocalPrepaidPackageUsageData({
    required this.id,
    required this.purchaseId,
    required this.washOrderId,
    required this.vehicleId,
    required this.usedAt,
    required this.usedById,
    required this.clientEntryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['purchase_id'] = Variable<String>(purchaseId);
    map['wash_order_id'] = Variable<String>(washOrderId);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['used_at'] = Variable<DateTime>(usedAt);
    map['used_by_id'] = Variable<String>(usedById);
    map['client_entry_id'] = Variable<String>(clientEntryId);
    return map;
  }

  LocalPrepaidPackageUsageCompanion toCompanion(bool nullToAbsent) {
    return LocalPrepaidPackageUsageCompanion(
      id: Value(id),
      purchaseId: Value(purchaseId),
      washOrderId: Value(washOrderId),
      vehicleId: Value(vehicleId),
      usedAt: Value(usedAt),
      usedById: Value(usedById),
      clientEntryId: Value(clientEntryId),
    );
  }

  factory LocalPrepaidPackageUsageData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPrepaidPackageUsageData(
      id: serializer.fromJson<String>(json['id']),
      purchaseId: serializer.fromJson<String>(json['purchaseId']),
      washOrderId: serializer.fromJson<String>(json['washOrderId']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      usedAt: serializer.fromJson<DateTime>(json['usedAt']),
      usedById: serializer.fromJson<String>(json['usedById']),
      clientEntryId: serializer.fromJson<String>(json['clientEntryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'purchaseId': serializer.toJson<String>(purchaseId),
      'washOrderId': serializer.toJson<String>(washOrderId),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'usedAt': serializer.toJson<DateTime>(usedAt),
      'usedById': serializer.toJson<String>(usedById),
      'clientEntryId': serializer.toJson<String>(clientEntryId),
    };
  }

  LocalPrepaidPackageUsageData copyWith({
    String? id,
    String? purchaseId,
    String? washOrderId,
    String? vehicleId,
    DateTime? usedAt,
    String? usedById,
    String? clientEntryId,
  }) => LocalPrepaidPackageUsageData(
    id: id ?? this.id,
    purchaseId: purchaseId ?? this.purchaseId,
    washOrderId: washOrderId ?? this.washOrderId,
    vehicleId: vehicleId ?? this.vehicleId,
    usedAt: usedAt ?? this.usedAt,
    usedById: usedById ?? this.usedById,
    clientEntryId: clientEntryId ?? this.clientEntryId,
  );
  LocalPrepaidPackageUsageData copyWithCompanion(
    LocalPrepaidPackageUsageCompanion data,
  ) {
    return LocalPrepaidPackageUsageData(
      id: data.id.present ? data.id.value : this.id,
      purchaseId: data.purchaseId.present
          ? data.purchaseId.value
          : this.purchaseId,
      washOrderId: data.washOrderId.present
          ? data.washOrderId.value
          : this.washOrderId,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      usedAt: data.usedAt.present ? data.usedAt.value : this.usedAt,
      usedById: data.usedById.present ? data.usedById.value : this.usedById,
      clientEntryId: data.clientEntryId.present
          ? data.clientEntryId.value
          : this.clientEntryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPrepaidPackageUsageData(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('washOrderId: $washOrderId, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('usedAt: $usedAt, ')
          ..write('usedById: $usedById, ')
          ..write('clientEntryId: $clientEntryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    purchaseId,
    washOrderId,
    vehicleId,
    usedAt,
    usedById,
    clientEntryId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPrepaidPackageUsageData &&
          other.id == this.id &&
          other.purchaseId == this.purchaseId &&
          other.washOrderId == this.washOrderId &&
          other.vehicleId == this.vehicleId &&
          other.usedAt == this.usedAt &&
          other.usedById == this.usedById &&
          other.clientEntryId == this.clientEntryId);
}

class LocalPrepaidPackageUsageCompanion
    extends UpdateCompanion<LocalPrepaidPackageUsageData> {
  final Value<String> id;
  final Value<String> purchaseId;
  final Value<String> washOrderId;
  final Value<String> vehicleId;
  final Value<DateTime> usedAt;
  final Value<String> usedById;
  final Value<String> clientEntryId;
  final Value<int> rowid;
  const LocalPrepaidPackageUsageCompanion({
    this.id = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.washOrderId = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.usedAt = const Value.absent(),
    this.usedById = const Value.absent(),
    this.clientEntryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalPrepaidPackageUsageCompanion.insert({
    required String id,
    required String purchaseId,
    required String washOrderId,
    required String vehicleId,
    this.usedAt = const Value.absent(),
    required String usedById,
    required String clientEntryId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       purchaseId = Value(purchaseId),
       washOrderId = Value(washOrderId),
       vehicleId = Value(vehicleId),
       usedById = Value(usedById),
       clientEntryId = Value(clientEntryId);
  static Insertable<LocalPrepaidPackageUsageData> custom({
    Expression<String>? id,
    Expression<String>? purchaseId,
    Expression<String>? washOrderId,
    Expression<String>? vehicleId,
    Expression<DateTime>? usedAt,
    Expression<String>? usedById,
    Expression<String>? clientEntryId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (washOrderId != null) 'wash_order_id': washOrderId,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (usedAt != null) 'used_at': usedAt,
      if (usedById != null) 'used_by_id': usedById,
      if (clientEntryId != null) 'client_entry_id': clientEntryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalPrepaidPackageUsageCompanion copyWith({
    Value<String>? id,
    Value<String>? purchaseId,
    Value<String>? washOrderId,
    Value<String>? vehicleId,
    Value<DateTime>? usedAt,
    Value<String>? usedById,
    Value<String>? clientEntryId,
    Value<int>? rowid,
  }) {
    return LocalPrepaidPackageUsageCompanion(
      id: id ?? this.id,
      purchaseId: purchaseId ?? this.purchaseId,
      washOrderId: washOrderId ?? this.washOrderId,
      vehicleId: vehicleId ?? this.vehicleId,
      usedAt: usedAt ?? this.usedAt,
      usedById: usedById ?? this.usedById,
      clientEntryId: clientEntryId ?? this.clientEntryId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<String>(purchaseId.value);
    }
    if (washOrderId.present) {
      map['wash_order_id'] = Variable<String>(washOrderId.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (usedAt.present) {
      map['used_at'] = Variable<DateTime>(usedAt.value);
    }
    if (usedById.present) {
      map['used_by_id'] = Variable<String>(usedById.value);
    }
    if (clientEntryId.present) {
      map['client_entry_id'] = Variable<String>(clientEntryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPrepaidPackageUsageCompanion(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('washOrderId: $washOrderId, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('usedAt: $usedAt, ')
          ..write('usedById: $usedById, ')
          ..write('clientEntryId: $clientEntryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalCashCollectionsTable extends LocalCashCollections
    with TableInfo<$LocalCashCollectionsTable, LocalCashCollection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalCashCollectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _branchIdMeta = const VerificationMeta(
    'branchId',
  );
  @override
  late final GeneratedColumn<String> branchId = GeneratedColumn<String>(
    'branch_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countedCashMeta = const VerificationMeta(
    'countedCash',
  );
  @override
  late final GeneratedColumn<int> countedCash = GeneratedColumn<int>(
    'counted_cash',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _varianceReasonMeta = const VerificationMeta(
    'varianceReason',
  );
  @override
  late final GeneratedColumn<String> varianceReason = GeneratedColumn<String>(
    'variance_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _witnessMeta = const VerificationMeta(
    'witness',
  );
  @override
  late final GeneratedColumn<String> witness = GeneratedColumn<String>(
    'witness',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countedAtMeta = const VerificationMeta(
    'countedAt',
  );
  @override
  late final GeneratedColumn<DateTime> countedAt = GeneratedColumn<DateTime>(
    'counted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    branchId,
    countedCash,
    varianceReason,
    witness,
    notes,
    countedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_cash_collections';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalCashCollection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('branch_id')) {
      context.handle(
        _branchIdMeta,
        branchId.isAcceptableOrUnknown(data['branch_id']!, _branchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    if (data.containsKey('counted_cash')) {
      context.handle(
        _countedCashMeta,
        countedCash.isAcceptableOrUnknown(
          data['counted_cash']!,
          _countedCashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_countedCashMeta);
    }
    if (data.containsKey('variance_reason')) {
      context.handle(
        _varianceReasonMeta,
        varianceReason.isAcceptableOrUnknown(
          data['variance_reason']!,
          _varianceReasonMeta,
        ),
      );
    }
    if (data.containsKey('witness')) {
      context.handle(
        _witnessMeta,
        witness.isAcceptableOrUnknown(data['witness']!, _witnessMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('counted_at')) {
      context.handle(
        _countedAtMeta,
        countedAt.isAcceptableOrUnknown(data['counted_at']!, _countedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_countedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalCashCollection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalCashCollection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      branchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch_id'],
      )!,
      countedCash: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}counted_cash'],
      )!,
      varianceReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variance_reason'],
      ),
      witness: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}witness'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      countedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}counted_at'],
      )!,
    );
  }

  @override
  $LocalCashCollectionsTable createAlias(String alias) {
    return $LocalCashCollectionsTable(attachedDatabase, alias);
  }
}

class LocalCashCollection extends DataClass
    implements Insertable<LocalCashCollection> {
  final String id;
  final String branchId;
  final int countedCash;
  final String? varianceReason;
  final String? witness;
  final String? notes;
  final DateTime countedAt;
  const LocalCashCollection({
    required this.id,
    required this.branchId,
    required this.countedCash,
    this.varianceReason,
    this.witness,
    this.notes,
    required this.countedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['branch_id'] = Variable<String>(branchId);
    map['counted_cash'] = Variable<int>(countedCash);
    if (!nullToAbsent || varianceReason != null) {
      map['variance_reason'] = Variable<String>(varianceReason);
    }
    if (!nullToAbsent || witness != null) {
      map['witness'] = Variable<String>(witness);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['counted_at'] = Variable<DateTime>(countedAt);
    return map;
  }

  LocalCashCollectionsCompanion toCompanion(bool nullToAbsent) {
    return LocalCashCollectionsCompanion(
      id: Value(id),
      branchId: Value(branchId),
      countedCash: Value(countedCash),
      varianceReason: varianceReason == null && nullToAbsent
          ? const Value.absent()
          : Value(varianceReason),
      witness: witness == null && nullToAbsent
          ? const Value.absent()
          : Value(witness),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      countedAt: Value(countedAt),
    );
  }

  factory LocalCashCollection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalCashCollection(
      id: serializer.fromJson<String>(json['id']),
      branchId: serializer.fromJson<String>(json['branchId']),
      countedCash: serializer.fromJson<int>(json['countedCash']),
      varianceReason: serializer.fromJson<String?>(json['varianceReason']),
      witness: serializer.fromJson<String?>(json['witness']),
      notes: serializer.fromJson<String?>(json['notes']),
      countedAt: serializer.fromJson<DateTime>(json['countedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'branchId': serializer.toJson<String>(branchId),
      'countedCash': serializer.toJson<int>(countedCash),
      'varianceReason': serializer.toJson<String?>(varianceReason),
      'witness': serializer.toJson<String?>(witness),
      'notes': serializer.toJson<String?>(notes),
      'countedAt': serializer.toJson<DateTime>(countedAt),
    };
  }

  LocalCashCollection copyWith({
    String? id,
    String? branchId,
    int? countedCash,
    Value<String?> varianceReason = const Value.absent(),
    Value<String?> witness = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? countedAt,
  }) => LocalCashCollection(
    id: id ?? this.id,
    branchId: branchId ?? this.branchId,
    countedCash: countedCash ?? this.countedCash,
    varianceReason: varianceReason.present
        ? varianceReason.value
        : this.varianceReason,
    witness: witness.present ? witness.value : this.witness,
    notes: notes.present ? notes.value : this.notes,
    countedAt: countedAt ?? this.countedAt,
  );
  LocalCashCollection copyWithCompanion(LocalCashCollectionsCompanion data) {
    return LocalCashCollection(
      id: data.id.present ? data.id.value : this.id,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      countedCash: data.countedCash.present
          ? data.countedCash.value
          : this.countedCash,
      varianceReason: data.varianceReason.present
          ? data.varianceReason.value
          : this.varianceReason,
      witness: data.witness.present ? data.witness.value : this.witness,
      notes: data.notes.present ? data.notes.value : this.notes,
      countedAt: data.countedAt.present ? data.countedAt.value : this.countedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalCashCollection(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('countedCash: $countedCash, ')
          ..write('varianceReason: $varianceReason, ')
          ..write('witness: $witness, ')
          ..write('notes: $notes, ')
          ..write('countedAt: $countedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    branchId,
    countedCash,
    varianceReason,
    witness,
    notes,
    countedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalCashCollection &&
          other.id == this.id &&
          other.branchId == this.branchId &&
          other.countedCash == this.countedCash &&
          other.varianceReason == this.varianceReason &&
          other.witness == this.witness &&
          other.notes == this.notes &&
          other.countedAt == this.countedAt);
}

class LocalCashCollectionsCompanion
    extends UpdateCompanion<LocalCashCollection> {
  final Value<String> id;
  final Value<String> branchId;
  final Value<int> countedCash;
  final Value<String?> varianceReason;
  final Value<String?> witness;
  final Value<String?> notes;
  final Value<DateTime> countedAt;
  final Value<int> rowid;
  const LocalCashCollectionsCompanion({
    this.id = const Value.absent(),
    this.branchId = const Value.absent(),
    this.countedCash = const Value.absent(),
    this.varianceReason = const Value.absent(),
    this.witness = const Value.absent(),
    this.notes = const Value.absent(),
    this.countedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalCashCollectionsCompanion.insert({
    required String id,
    required String branchId,
    required int countedCash,
    this.varianceReason = const Value.absent(),
    this.witness = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime countedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       branchId = Value(branchId),
       countedCash = Value(countedCash),
       countedAt = Value(countedAt);
  static Insertable<LocalCashCollection> custom({
    Expression<String>? id,
    Expression<String>? branchId,
    Expression<int>? countedCash,
    Expression<String>? varianceReason,
    Expression<String>? witness,
    Expression<String>? notes,
    Expression<DateTime>? countedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (branchId != null) 'branch_id': branchId,
      if (countedCash != null) 'counted_cash': countedCash,
      if (varianceReason != null) 'variance_reason': varianceReason,
      if (witness != null) 'witness': witness,
      if (notes != null) 'notes': notes,
      if (countedAt != null) 'counted_at': countedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalCashCollectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? branchId,
    Value<int>? countedCash,
    Value<String?>? varianceReason,
    Value<String?>? witness,
    Value<String?>? notes,
    Value<DateTime>? countedAt,
    Value<int>? rowid,
  }) {
    return LocalCashCollectionsCompanion(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      countedCash: countedCash ?? this.countedCash,
      varianceReason: varianceReason ?? this.varianceReason,
      witness: witness ?? this.witness,
      notes: notes ?? this.notes,
      countedAt: countedAt ?? this.countedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<String>(branchId.value);
    }
    if (countedCash.present) {
      map['counted_cash'] = Variable<int>(countedCash.value);
    }
    if (varianceReason.present) {
      map['variance_reason'] = Variable<String>(varianceReason.value);
    }
    if (witness.present) {
      map['witness'] = Variable<String>(witness.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (countedAt.present) {
      map['counted_at'] = Variable<DateTime>(countedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalCashCollectionsCompanion(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('countedCash: $countedCash, ')
          ..write('varianceReason: $varianceReason, ')
          ..write('witness: $witness, ')
          ..write('notes: $notes, ')
          ..write('countedAt: $countedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalPendingUsersTable extends LocalPendingUsers
    with TableInfo<$LocalPendingUsersTable, LocalPendingUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPendingUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _branchIdMeta = const VerificationMeta(
    'branchId',
  );
  @override
  late final GeneratedColumn<String> branchId = GeneratedColumn<String>(
    'branch_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinMeta = const VerificationMeta('pin');
  @override
  late final GeneratedColumn<String> pin = GeneratedColumn<String>(
    'pin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    branchId,
    fullName,
    username,
    password,
    role,
    pin,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_pending_users';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPendingUser> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('branch_id')) {
      context.handle(
        _branchIdMeta,
        branchId.isAcceptableOrUnknown(data['branch_id']!, _branchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('pin')) {
      context.handle(
        _pinMeta,
        pin.isAcceptableOrUnknown(data['pin']!, _pinMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalPendingUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPendingUser(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      branchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch_id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      pin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LocalPendingUsersTable createAlias(String alias) {
    return $LocalPendingUsersTable(attachedDatabase, alias);
  }
}

class LocalPendingUser extends DataClass
    implements Insertable<LocalPendingUser> {
  final String id;
  final String branchId;
  final String fullName;
  final String username;
  final String password;
  final String role;
  final String? pin;
  final DateTime createdAt;
  const LocalPendingUser({
    required this.id,
    required this.branchId,
    required this.fullName,
    required this.username,
    required this.password,
    required this.role,
    this.pin,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['branch_id'] = Variable<String>(branchId);
    map['full_name'] = Variable<String>(fullName);
    map['username'] = Variable<String>(username);
    map['password'] = Variable<String>(password);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || pin != null) {
      map['pin'] = Variable<String>(pin);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LocalPendingUsersCompanion toCompanion(bool nullToAbsent) {
    return LocalPendingUsersCompanion(
      id: Value(id),
      branchId: Value(branchId),
      fullName: Value(fullName),
      username: Value(username),
      password: Value(password),
      role: Value(role),
      pin: pin == null && nullToAbsent ? const Value.absent() : Value(pin),
      createdAt: Value(createdAt),
    );
  }

  factory LocalPendingUser.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPendingUser(
      id: serializer.fromJson<String>(json['id']),
      branchId: serializer.fromJson<String>(json['branchId']),
      fullName: serializer.fromJson<String>(json['fullName']),
      username: serializer.fromJson<String>(json['username']),
      password: serializer.fromJson<String>(json['password']),
      role: serializer.fromJson<String>(json['role']),
      pin: serializer.fromJson<String?>(json['pin']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'branchId': serializer.toJson<String>(branchId),
      'fullName': serializer.toJson<String>(fullName),
      'username': serializer.toJson<String>(username),
      'password': serializer.toJson<String>(password),
      'role': serializer.toJson<String>(role),
      'pin': serializer.toJson<String?>(pin),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocalPendingUser copyWith({
    String? id,
    String? branchId,
    String? fullName,
    String? username,
    String? password,
    String? role,
    Value<String?> pin = const Value.absent(),
    DateTime? createdAt,
  }) => LocalPendingUser(
    id: id ?? this.id,
    branchId: branchId ?? this.branchId,
    fullName: fullName ?? this.fullName,
    username: username ?? this.username,
    password: password ?? this.password,
    role: role ?? this.role,
    pin: pin.present ? pin.value : this.pin,
    createdAt: createdAt ?? this.createdAt,
  );
  LocalPendingUser copyWithCompanion(LocalPendingUsersCompanion data) {
    return LocalPendingUser(
      id: data.id.present ? data.id.value : this.id,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      username: data.username.present ? data.username.value : this.username,
      password: data.password.present ? data.password.value : this.password,
      role: data.role.present ? data.role.value : this.role,
      pin: data.pin.present ? data.pin.value : this.pin,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPendingUser(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('fullName: $fullName, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('role: $role, ')
          ..write('pin: $pin, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    branchId,
    fullName,
    username,
    password,
    role,
    pin,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPendingUser &&
          other.id == this.id &&
          other.branchId == this.branchId &&
          other.fullName == this.fullName &&
          other.username == this.username &&
          other.password == this.password &&
          other.role == this.role &&
          other.pin == this.pin &&
          other.createdAt == this.createdAt);
}

class LocalPendingUsersCompanion extends UpdateCompanion<LocalPendingUser> {
  final Value<String> id;
  final Value<String> branchId;
  final Value<String> fullName;
  final Value<String> username;
  final Value<String> password;
  final Value<String> role;
  final Value<String?> pin;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LocalPendingUsersCompanion({
    this.id = const Value.absent(),
    this.branchId = const Value.absent(),
    this.fullName = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.role = const Value.absent(),
    this.pin = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalPendingUsersCompanion.insert({
    required String id,
    required String branchId,
    required String fullName,
    required String username,
    required String password,
    required String role,
    this.pin = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       branchId = Value(branchId),
       fullName = Value(fullName),
       username = Value(username),
       password = Value(password),
       role = Value(role),
       createdAt = Value(createdAt);
  static Insertable<LocalPendingUser> custom({
    Expression<String>? id,
    Expression<String>? branchId,
    Expression<String>? fullName,
    Expression<String>? username,
    Expression<String>? password,
    Expression<String>? role,
    Expression<String>? pin,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (branchId != null) 'branch_id': branchId,
      if (fullName != null) 'full_name': fullName,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (role != null) 'role': role,
      if (pin != null) 'pin': pin,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalPendingUsersCompanion copyWith({
    Value<String>? id,
    Value<String>? branchId,
    Value<String>? fullName,
    Value<String>? username,
    Value<String>? password,
    Value<String>? role,
    Value<String?>? pin,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalPendingUsersCompanion(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
      pin: pin ?? this.pin,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<String>(branchId.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (pin.present) {
      map['pin'] = Variable<String>(pin.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPendingUsersCompanion(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('fullName: $fullName, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('role: $role, ')
          ..write('pin: $pin, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalUsersTable extends LocalUsers
    with TableInfo<$LocalUsersTable, LocalUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinHashMeta = const VerificationMeta(
    'pinHash',
  );
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
    'pin_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastLoginAtMeta = const VerificationMeta(
    'lastLoginAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastLoginAt = GeneratedColumn<DateTime>(
    'last_login_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fullName,
    username,
    passwordHash,
    pinHash,
    role,
    active,
    lastLoginAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_users';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalUser> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(
        _pinHashMeta,
        pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('last_login_at')) {
      context.handle(
        _lastLoginAtMeta,
        lastLoginAt.isAcceptableOrUnknown(
          data['last_login_at']!,
          _lastLoginAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalUser(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      )!,
      pinHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_hash'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      lastLoginAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_login_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LocalUsersTable createAlias(String alias) {
    return $LocalUsersTable(attachedDatabase, alias);
  }
}

class LocalUser extends DataClass implements Insertable<LocalUser> {
  final String id;
  final String fullName;
  final String username;
  final String passwordHash;
  final String? pinHash;
  final String role;
  final bool active;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  const LocalUser({
    required this.id,
    required this.fullName,
    required this.username,
    required this.passwordHash,
    this.pinHash,
    required this.role,
    required this.active,
    this.lastLoginAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['full_name'] = Variable<String>(fullName);
    map['username'] = Variable<String>(username);
    map['password_hash'] = Variable<String>(passwordHash);
    if (!nullToAbsent || pinHash != null) {
      map['pin_hash'] = Variable<String>(pinHash);
    }
    map['role'] = Variable<String>(role);
    map['active'] = Variable<bool>(active);
    if (!nullToAbsent || lastLoginAt != null) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LocalUsersCompanion toCompanion(bool nullToAbsent) {
    return LocalUsersCompanion(
      id: Value(id),
      fullName: Value(fullName),
      username: Value(username),
      passwordHash: Value(passwordHash),
      pinHash: pinHash == null && nullToAbsent
          ? const Value.absent()
          : Value(pinHash),
      role: Value(role),
      active: Value(active),
      lastLoginAt: lastLoginAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLoginAt),
      createdAt: Value(createdAt),
    );
  }

  factory LocalUser.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalUser(
      id: serializer.fromJson<String>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      username: serializer.fromJson<String>(json['username']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      pinHash: serializer.fromJson<String?>(json['pinHash']),
      role: serializer.fromJson<String>(json['role']),
      active: serializer.fromJson<bool>(json['active']),
      lastLoginAt: serializer.fromJson<DateTime?>(json['lastLoginAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fullName': serializer.toJson<String>(fullName),
      'username': serializer.toJson<String>(username),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'pinHash': serializer.toJson<String?>(pinHash),
      'role': serializer.toJson<String>(role),
      'active': serializer.toJson<bool>(active),
      'lastLoginAt': serializer.toJson<DateTime?>(lastLoginAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocalUser copyWith({
    String? id,
    String? fullName,
    String? username,
    String? passwordHash,
    Value<String?> pinHash = const Value.absent(),
    String? role,
    bool? active,
    Value<DateTime?> lastLoginAt = const Value.absent(),
    DateTime? createdAt,
  }) => LocalUser(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    username: username ?? this.username,
    passwordHash: passwordHash ?? this.passwordHash,
    pinHash: pinHash.present ? pinHash.value : this.pinHash,
    role: role ?? this.role,
    active: active ?? this.active,
    lastLoginAt: lastLoginAt.present ? lastLoginAt.value : this.lastLoginAt,
    createdAt: createdAt ?? this.createdAt,
  );
  LocalUser copyWithCompanion(LocalUsersCompanion data) {
    return LocalUser(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      username: data.username.present ? data.username.value : this.username,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      role: data.role.present ? data.role.value : this.role,
      active: data.active.present ? data.active.value : this.active,
      lastLoginAt: data.lastLoginAt.present
          ? data.lastLoginAt.value
          : this.lastLoginAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalUser(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('pinHash: $pinHash, ')
          ..write('role: $role, ')
          ..write('active: $active, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fullName,
    username,
    passwordHash,
    pinHash,
    role,
    active,
    lastLoginAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalUser &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.username == this.username &&
          other.passwordHash == this.passwordHash &&
          other.pinHash == this.pinHash &&
          other.role == this.role &&
          other.active == this.active &&
          other.lastLoginAt == this.lastLoginAt &&
          other.createdAt == this.createdAt);
}

class LocalUsersCompanion extends UpdateCompanion<LocalUser> {
  final Value<String> id;
  final Value<String> fullName;
  final Value<String> username;
  final Value<String> passwordHash;
  final Value<String?> pinHash;
  final Value<String> role;
  final Value<bool> active;
  final Value<DateTime?> lastLoginAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LocalUsersCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.username = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.role = const Value.absent(),
    this.active = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalUsersCompanion.insert({
    required String id,
    required String fullName,
    required String username,
    required String passwordHash,
    this.pinHash = const Value.absent(),
    required String role,
    this.active = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fullName = Value(fullName),
       username = Value(username),
       passwordHash = Value(passwordHash),
       role = Value(role);
  static Insertable<LocalUser> custom({
    Expression<String>? id,
    Expression<String>? fullName,
    Expression<String>? username,
    Expression<String>? passwordHash,
    Expression<String>? pinHash,
    Expression<String>? role,
    Expression<bool>? active,
    Expression<DateTime>? lastLoginAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (username != null) 'username': username,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (pinHash != null) 'pin_hash': pinHash,
      if (role != null) 'role': role,
      if (active != null) 'active': active,
      if (lastLoginAt != null) 'last_login_at': lastLoginAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalUsersCompanion copyWith({
    Value<String>? id,
    Value<String>? fullName,
    Value<String>? username,
    Value<String>? passwordHash,
    Value<String?>? pinHash,
    Value<String>? role,
    Value<bool>? active,
    Value<DateTime?>? lastLoginAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalUsersCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      pinHash: pinHash ?? this.pinHash,
      role: role ?? this.role,
      active: active ?? this.active,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (lastLoginAt.present) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalUsersCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('pinHash: $pinHash, ')
          ..write('role: $role, ')
          ..write('active: $active, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalWashServicesTable localWashServices =
      $LocalWashServicesTable(this);
  late final $LocalWashExtrasTable localWashExtras = $LocalWashExtrasTable(
    this,
  );
  late final $LocalCustomersTable localCustomers = $LocalCustomersTable(this);
  late final $LocalVehiclesTable localVehicles = $LocalVehiclesTable(this);
  late final $LocalLoyaltySummariesTable localLoyaltySummaries =
      $LocalLoyaltySummariesTable(this);
  late final $LocalLoyaltyLedgerTable localLoyaltyLedger =
      $LocalLoyaltyLedgerTable(this);
  late final $LocalLoyaltyRewardsTable localLoyaltyRewards =
      $LocalLoyaltyRewardsTable(this);
  late final $LocalWashOrdersTable localWashOrders = $LocalWashOrdersTable(
    this,
  );
  late final $LocalWashOrderItemsTable localWashOrderItems =
      $LocalWashOrderItemsTable(this);
  late final $LocalPaymentsTable localPayments = $LocalPaymentsTable(this);
  late final $LocalPaymentComponentsTable localPaymentComponents =
      $LocalPaymentComponentsTable(this);
  late final $PendingSyncOpsTable pendingSyncOps = $PendingSyncOpsTable(this);
  late final $SyncMetaTable syncMeta = $SyncMetaTable(this);
  late final $LocalExpenseCategoriesTable localExpenseCategories =
      $LocalExpenseCategoriesTable(this);
  late final $LocalExpensesTable localExpenses = $LocalExpensesTable(this);
  late final $LocalPrepaidPackagesTable localPrepaidPackages =
      $LocalPrepaidPackagesTable(this);
  late final $LocalPrepaidWalletsTable localPrepaidWallets =
      $LocalPrepaidWalletsTable(this);
  late final $LocalPrepaidWalletLedgerTable localPrepaidWalletLedger =
      $LocalPrepaidWalletLedgerTable(this);
  late final $LocalPrepaidPackagePurchasesTable localPrepaidPackagePurchases =
      $LocalPrepaidPackagePurchasesTable(this);
  late final $LocalPrepaidPackageUsageTable localPrepaidPackageUsage =
      $LocalPrepaidPackageUsageTable(this);
  late final $LocalCashCollectionsTable localCashCollections =
      $LocalCashCollectionsTable(this);
  late final $LocalPendingUsersTable localPendingUsers =
      $LocalPendingUsersTable(this);
  late final $LocalUsersTable localUsers = $LocalUsersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localWashServices,
    localWashExtras,
    localCustomers,
    localVehicles,
    localLoyaltySummaries,
    localLoyaltyLedger,
    localLoyaltyRewards,
    localWashOrders,
    localWashOrderItems,
    localPayments,
    localPaymentComponents,
    pendingSyncOps,
    syncMeta,
    localExpenseCategories,
    localExpenses,
    localPrepaidPackages,
    localPrepaidWallets,
    localPrepaidWalletLedger,
    localPrepaidPackagePurchases,
    localPrepaidPackageUsage,
    localCashCollections,
    localPendingUsers,
    localUsers,
  ];
}

typedef $$LocalWashServicesTableCreateCompanionBuilder =
    LocalWashServicesCompanion Function({
      required String id,
      required String name,
      required String tier,
      required int basePrice,
      required int durationMinutes,
      Value<int> rowid,
    });
typedef $$LocalWashServicesTableUpdateCompanionBuilder =
    LocalWashServicesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> tier,
      Value<int> basePrice,
      Value<int> durationMinutes,
      Value<int> rowid,
    });

class $$LocalWashServicesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalWashServicesTable> {
  $$LocalWashServicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get basePrice => $composableBuilder(
    column: $table.basePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalWashServicesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalWashServicesTable> {
  $$LocalWashServicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get basePrice => $composableBuilder(
    column: $table.basePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalWashServicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalWashServicesTable> {
  $$LocalWashServicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get tier =>
      $composableBuilder(column: $table.tier, builder: (column) => column);

  GeneratedColumn<int> get basePrice =>
      $composableBuilder(column: $table.basePrice, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );
}

class $$LocalWashServicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalWashServicesTable,
          LocalWashService,
          $$LocalWashServicesTableFilterComposer,
          $$LocalWashServicesTableOrderingComposer,
          $$LocalWashServicesTableAnnotationComposer,
          $$LocalWashServicesTableCreateCompanionBuilder,
          $$LocalWashServicesTableUpdateCompanionBuilder,
          (
            LocalWashService,
            BaseReferences<
              _$AppDatabase,
              $LocalWashServicesTable,
              LocalWashService
            >,
          ),
          LocalWashService,
          PrefetchHooks Function()
        > {
  $$LocalWashServicesTableTableManager(
    _$AppDatabase db,
    $LocalWashServicesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalWashServicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalWashServicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalWashServicesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> tier = const Value.absent(),
                Value<int> basePrice = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalWashServicesCompanion(
                id: id,
                name: name,
                tier: tier,
                basePrice: basePrice,
                durationMinutes: durationMinutes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String tier,
                required int basePrice,
                required int durationMinutes,
                Value<int> rowid = const Value.absent(),
              }) => LocalWashServicesCompanion.insert(
                id: id,
                name: name,
                tier: tier,
                basePrice: basePrice,
                durationMinutes: durationMinutes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalWashServicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalWashServicesTable,
      LocalWashService,
      $$LocalWashServicesTableFilterComposer,
      $$LocalWashServicesTableOrderingComposer,
      $$LocalWashServicesTableAnnotationComposer,
      $$LocalWashServicesTableCreateCompanionBuilder,
      $$LocalWashServicesTableUpdateCompanionBuilder,
      (
        LocalWashService,
        BaseReferences<
          _$AppDatabase,
          $LocalWashServicesTable,
          LocalWashService
        >,
      ),
      LocalWashService,
      PrefetchHooks Function()
    >;
typedef $$LocalWashExtrasTableCreateCompanionBuilder =
    LocalWashExtrasCompanion Function({
      required String id,
      required String name,
      required int price,
      Value<int> rowid,
    });
typedef $$LocalWashExtrasTableUpdateCompanionBuilder =
    LocalWashExtrasCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> price,
      Value<int> rowid,
    });

class $$LocalWashExtrasTableFilterComposer
    extends Composer<_$AppDatabase, $LocalWashExtrasTable> {
  $$LocalWashExtrasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalWashExtrasTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalWashExtrasTable> {
  $$LocalWashExtrasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalWashExtrasTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalWashExtrasTable> {
  $$LocalWashExtrasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);
}

class $$LocalWashExtrasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalWashExtrasTable,
          LocalWashExtra,
          $$LocalWashExtrasTableFilterComposer,
          $$LocalWashExtrasTableOrderingComposer,
          $$LocalWashExtrasTableAnnotationComposer,
          $$LocalWashExtrasTableCreateCompanionBuilder,
          $$LocalWashExtrasTableUpdateCompanionBuilder,
          (
            LocalWashExtra,
            BaseReferences<
              _$AppDatabase,
              $LocalWashExtrasTable,
              LocalWashExtra
            >,
          ),
          LocalWashExtra,
          PrefetchHooks Function()
        > {
  $$LocalWashExtrasTableTableManager(
    _$AppDatabase db,
    $LocalWashExtrasTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalWashExtrasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalWashExtrasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalWashExtrasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> price = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalWashExtrasCompanion(
                id: id,
                name: name,
                price: price,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int price,
                Value<int> rowid = const Value.absent(),
              }) => LocalWashExtrasCompanion.insert(
                id: id,
                name: name,
                price: price,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalWashExtrasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalWashExtrasTable,
      LocalWashExtra,
      $$LocalWashExtrasTableFilterComposer,
      $$LocalWashExtrasTableOrderingComposer,
      $$LocalWashExtrasTableAnnotationComposer,
      $$LocalWashExtrasTableCreateCompanionBuilder,
      $$LocalWashExtrasTableUpdateCompanionBuilder,
      (
        LocalWashExtra,
        BaseReferences<_$AppDatabase, $LocalWashExtrasTable, LocalWashExtra>,
      ),
      LocalWashExtra,
      PrefetchHooks Function()
    >;
typedef $$LocalCustomersTableCreateCompanionBuilder =
    LocalCustomersCompanion Function({
      required String id,
      required String branchId,
      required String fullName,
      required String phone,
      Value<String?> altPhone,
      Value<String?> notes,
      Value<bool> dirty,
      Value<int> rowid,
    });
typedef $$LocalCustomersTableUpdateCompanionBuilder =
    LocalCustomersCompanion Function({
      Value<String> id,
      Value<String> branchId,
      Value<String> fullName,
      Value<String> phone,
      Value<String?> altPhone,
      Value<String?> notes,
      Value<bool> dirty,
      Value<int> rowid,
    });

class $$LocalCustomersTableFilterComposer
    extends Composer<_$AppDatabase, $LocalCustomersTable> {
  $$LocalCustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get altPhone => $composableBuilder(
    column: $table.altPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalCustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalCustomersTable> {
  $$LocalCustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get altPhone => $composableBuilder(
    column: $table.altPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalCustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalCustomersTable> {
  $$LocalCustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get branchId =>
      $composableBuilder(column: $table.branchId, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get altPhone =>
      $composableBuilder(column: $table.altPhone, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);
}

class $$LocalCustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalCustomersTable,
          LocalCustomer,
          $$LocalCustomersTableFilterComposer,
          $$LocalCustomersTableOrderingComposer,
          $$LocalCustomersTableAnnotationComposer,
          $$LocalCustomersTableCreateCompanionBuilder,
          $$LocalCustomersTableUpdateCompanionBuilder,
          (
            LocalCustomer,
            BaseReferences<_$AppDatabase, $LocalCustomersTable, LocalCustomer>,
          ),
          LocalCustomer,
          PrefetchHooks Function()
        > {
  $$LocalCustomersTableTableManager(
    _$AppDatabase db,
    $LocalCustomersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalCustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalCustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalCustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> branchId = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String?> altPhone = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalCustomersCompanion(
                id: id,
                branchId: branchId,
                fullName: fullName,
                phone: phone,
                altPhone: altPhone,
                notes: notes,
                dirty: dirty,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String branchId,
                required String fullName,
                required String phone,
                Value<String?> altPhone = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalCustomersCompanion.insert(
                id: id,
                branchId: branchId,
                fullName: fullName,
                phone: phone,
                altPhone: altPhone,
                notes: notes,
                dirty: dirty,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalCustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalCustomersTable,
      LocalCustomer,
      $$LocalCustomersTableFilterComposer,
      $$LocalCustomersTableOrderingComposer,
      $$LocalCustomersTableAnnotationComposer,
      $$LocalCustomersTableCreateCompanionBuilder,
      $$LocalCustomersTableUpdateCompanionBuilder,
      (
        LocalCustomer,
        BaseReferences<_$AppDatabase, $LocalCustomersTable, LocalCustomer>,
      ),
      LocalCustomer,
      PrefetchHooks Function()
    >;
typedef $$LocalVehiclesTableCreateCompanionBuilder =
    LocalVehiclesCompanion Function({
      required String id,
      required String customerId,
      required String regNumberNormalized,
      required String regNumberDisplay,
      Value<String?> make,
      Value<String?> model,
      Value<String?> colour,
      Value<String> vehicleType,
      Value<bool> dirty,
      Value<int> rowid,
    });
typedef $$LocalVehiclesTableUpdateCompanionBuilder =
    LocalVehiclesCompanion Function({
      Value<String> id,
      Value<String> customerId,
      Value<String> regNumberNormalized,
      Value<String> regNumberDisplay,
      Value<String?> make,
      Value<String?> model,
      Value<String?> colour,
      Value<String> vehicleType,
      Value<bool> dirty,
      Value<int> rowid,
    });

class $$LocalVehiclesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalVehiclesTable> {
  $$LocalVehiclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get regNumberNormalized => $composableBuilder(
    column: $table.regNumberNormalized,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get regNumberDisplay => $composableBuilder(
    column: $table.regNumberDisplay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get make => $composableBuilder(
    column: $table.make,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colour => $composableBuilder(
    column: $table.colour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleType => $composableBuilder(
    column: $table.vehicleType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalVehiclesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalVehiclesTable> {
  $$LocalVehiclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get regNumberNormalized => $composableBuilder(
    column: $table.regNumberNormalized,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get regNumberDisplay => $composableBuilder(
    column: $table.regNumberDisplay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get make => $composableBuilder(
    column: $table.make,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colour => $composableBuilder(
    column: $table.colour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleType => $composableBuilder(
    column: $table.vehicleType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalVehiclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalVehiclesTable> {
  $$LocalVehiclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get regNumberNormalized => $composableBuilder(
    column: $table.regNumberNormalized,
    builder: (column) => column,
  );

  GeneratedColumn<String> get regNumberDisplay => $composableBuilder(
    column: $table.regNumberDisplay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get make =>
      $composableBuilder(column: $table.make, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get colour =>
      $composableBuilder(column: $table.colour, builder: (column) => column);

  GeneratedColumn<String> get vehicleType => $composableBuilder(
    column: $table.vehicleType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);
}

class $$LocalVehiclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalVehiclesTable,
          LocalVehicle,
          $$LocalVehiclesTableFilterComposer,
          $$LocalVehiclesTableOrderingComposer,
          $$LocalVehiclesTableAnnotationComposer,
          $$LocalVehiclesTableCreateCompanionBuilder,
          $$LocalVehiclesTableUpdateCompanionBuilder,
          (
            LocalVehicle,
            BaseReferences<_$AppDatabase, $LocalVehiclesTable, LocalVehicle>,
          ),
          LocalVehicle,
          PrefetchHooks Function()
        > {
  $$LocalVehiclesTableTableManager(_$AppDatabase db, $LocalVehiclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalVehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalVehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalVehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> customerId = const Value.absent(),
                Value<String> regNumberNormalized = const Value.absent(),
                Value<String> regNumberDisplay = const Value.absent(),
                Value<String?> make = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<String?> colour = const Value.absent(),
                Value<String> vehicleType = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalVehiclesCompanion(
                id: id,
                customerId: customerId,
                regNumberNormalized: regNumberNormalized,
                regNumberDisplay: regNumberDisplay,
                make: make,
                model: model,
                colour: colour,
                vehicleType: vehicleType,
                dirty: dirty,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String customerId,
                required String regNumberNormalized,
                required String regNumberDisplay,
                Value<String?> make = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<String?> colour = const Value.absent(),
                Value<String> vehicleType = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalVehiclesCompanion.insert(
                id: id,
                customerId: customerId,
                regNumberNormalized: regNumberNormalized,
                regNumberDisplay: regNumberDisplay,
                make: make,
                model: model,
                colour: colour,
                vehicleType: vehicleType,
                dirty: dirty,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalVehiclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalVehiclesTable,
      LocalVehicle,
      $$LocalVehiclesTableFilterComposer,
      $$LocalVehiclesTableOrderingComposer,
      $$LocalVehiclesTableAnnotationComposer,
      $$LocalVehiclesTableCreateCompanionBuilder,
      $$LocalVehiclesTableUpdateCompanionBuilder,
      (
        LocalVehicle,
        BaseReferences<_$AppDatabase, $LocalVehiclesTable, LocalVehicle>,
      ),
      LocalVehicle,
      PrefetchHooks Function()
    >;
typedef $$LocalLoyaltySummariesTableCreateCompanionBuilder =
    LocalLoyaltySummariesCompanion Function({
      required String vehicleId,
      required int qualifyingCount,
      required bool hasAvailableReward,
      required DateTime asOf,
      Value<int> rowid,
    });
typedef $$LocalLoyaltySummariesTableUpdateCompanionBuilder =
    LocalLoyaltySummariesCompanion Function({
      Value<String> vehicleId,
      Value<int> qualifyingCount,
      Value<bool> hasAvailableReward,
      Value<DateTime> asOf,
      Value<int> rowid,
    });

class $$LocalLoyaltySummariesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalLoyaltySummariesTable> {
  $$LocalLoyaltySummariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qualifyingCount => $composableBuilder(
    column: $table.qualifyingCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasAvailableReward => $composableBuilder(
    column: $table.hasAvailableReward,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get asOf => $composableBuilder(
    column: $table.asOf,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalLoyaltySummariesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalLoyaltySummariesTable> {
  $$LocalLoyaltySummariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qualifyingCount => $composableBuilder(
    column: $table.qualifyingCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasAvailableReward => $composableBuilder(
    column: $table.hasAvailableReward,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get asOf => $composableBuilder(
    column: $table.asOf,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalLoyaltySummariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalLoyaltySummariesTable> {
  $$LocalLoyaltySummariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get vehicleId =>
      $composableBuilder(column: $table.vehicleId, builder: (column) => column);

  GeneratedColumn<int> get qualifyingCount => $composableBuilder(
    column: $table.qualifyingCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasAvailableReward => $composableBuilder(
    column: $table.hasAvailableReward,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get asOf =>
      $composableBuilder(column: $table.asOf, builder: (column) => column);
}

class $$LocalLoyaltySummariesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalLoyaltySummariesTable,
          LocalLoyaltySummary,
          $$LocalLoyaltySummariesTableFilterComposer,
          $$LocalLoyaltySummariesTableOrderingComposer,
          $$LocalLoyaltySummariesTableAnnotationComposer,
          $$LocalLoyaltySummariesTableCreateCompanionBuilder,
          $$LocalLoyaltySummariesTableUpdateCompanionBuilder,
          (
            LocalLoyaltySummary,
            BaseReferences<
              _$AppDatabase,
              $LocalLoyaltySummariesTable,
              LocalLoyaltySummary
            >,
          ),
          LocalLoyaltySummary,
          PrefetchHooks Function()
        > {
  $$LocalLoyaltySummariesTableTableManager(
    _$AppDatabase db,
    $LocalLoyaltySummariesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalLoyaltySummariesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalLoyaltySummariesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalLoyaltySummariesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> vehicleId = const Value.absent(),
                Value<int> qualifyingCount = const Value.absent(),
                Value<bool> hasAvailableReward = const Value.absent(),
                Value<DateTime> asOf = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalLoyaltySummariesCompanion(
                vehicleId: vehicleId,
                qualifyingCount: qualifyingCount,
                hasAvailableReward: hasAvailableReward,
                asOf: asOf,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String vehicleId,
                required int qualifyingCount,
                required bool hasAvailableReward,
                required DateTime asOf,
                Value<int> rowid = const Value.absent(),
              }) => LocalLoyaltySummariesCompanion.insert(
                vehicleId: vehicleId,
                qualifyingCount: qualifyingCount,
                hasAvailableReward: hasAvailableReward,
                asOf: asOf,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalLoyaltySummariesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalLoyaltySummariesTable,
      LocalLoyaltySummary,
      $$LocalLoyaltySummariesTableFilterComposer,
      $$LocalLoyaltySummariesTableOrderingComposer,
      $$LocalLoyaltySummariesTableAnnotationComposer,
      $$LocalLoyaltySummariesTableCreateCompanionBuilder,
      $$LocalLoyaltySummariesTableUpdateCompanionBuilder,
      (
        LocalLoyaltySummary,
        BaseReferences<
          _$AppDatabase,
          $LocalLoyaltySummariesTable,
          LocalLoyaltySummary
        >,
      ),
      LocalLoyaltySummary,
      PrefetchHooks Function()
    >;
typedef $$LocalLoyaltyLedgerTableCreateCompanionBuilder =
    LocalLoyaltyLedgerCompanion Function({
      required String id,
      required String vehicleId,
      Value<String?> washOrderId,
      required String eventType,
      required DateTime periodMonth,
      Value<DateTime> createdAt,
      required String createdById,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$LocalLoyaltyLedgerTableUpdateCompanionBuilder =
    LocalLoyaltyLedgerCompanion Function({
      Value<String> id,
      Value<String> vehicleId,
      Value<String?> washOrderId,
      Value<String> eventType,
      Value<DateTime> periodMonth,
      Value<DateTime> createdAt,
      Value<String> createdById,
      Value<String?> notes,
      Value<int> rowid,
    });

class $$LocalLoyaltyLedgerTableFilterComposer
    extends Composer<_$AppDatabase, $LocalLoyaltyLedgerTable> {
  $$LocalLoyaltyLedgerTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get washOrderId => $composableBuilder(
    column: $table.washOrderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get periodMonth => $composableBuilder(
    column: $table.periodMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdById => $composableBuilder(
    column: $table.createdById,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalLoyaltyLedgerTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalLoyaltyLedgerTable> {
  $$LocalLoyaltyLedgerTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get washOrderId => $composableBuilder(
    column: $table.washOrderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get periodMonth => $composableBuilder(
    column: $table.periodMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdById => $composableBuilder(
    column: $table.createdById,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalLoyaltyLedgerTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalLoyaltyLedgerTable> {
  $$LocalLoyaltyLedgerTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vehicleId =>
      $composableBuilder(column: $table.vehicleId, builder: (column) => column);

  GeneratedColumn<String> get washOrderId => $composableBuilder(
    column: $table.washOrderId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<DateTime> get periodMonth => $composableBuilder(
    column: $table.periodMonth,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdById => $composableBuilder(
    column: $table.createdById,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$LocalLoyaltyLedgerTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalLoyaltyLedgerTable,
          LocalLoyaltyLedgerData,
          $$LocalLoyaltyLedgerTableFilterComposer,
          $$LocalLoyaltyLedgerTableOrderingComposer,
          $$LocalLoyaltyLedgerTableAnnotationComposer,
          $$LocalLoyaltyLedgerTableCreateCompanionBuilder,
          $$LocalLoyaltyLedgerTableUpdateCompanionBuilder,
          (
            LocalLoyaltyLedgerData,
            BaseReferences<
              _$AppDatabase,
              $LocalLoyaltyLedgerTable,
              LocalLoyaltyLedgerData
            >,
          ),
          LocalLoyaltyLedgerData,
          PrefetchHooks Function()
        > {
  $$LocalLoyaltyLedgerTableTableManager(
    _$AppDatabase db,
    $LocalLoyaltyLedgerTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalLoyaltyLedgerTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalLoyaltyLedgerTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalLoyaltyLedgerTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<String?> washOrderId = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<DateTime> periodMonth = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdById = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalLoyaltyLedgerCompanion(
                id: id,
                vehicleId: vehicleId,
                washOrderId: washOrderId,
                eventType: eventType,
                periodMonth: periodMonth,
                createdAt: createdAt,
                createdById: createdById,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vehicleId,
                Value<String?> washOrderId = const Value.absent(),
                required String eventType,
                required DateTime periodMonth,
                Value<DateTime> createdAt = const Value.absent(),
                required String createdById,
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalLoyaltyLedgerCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                washOrderId: washOrderId,
                eventType: eventType,
                periodMonth: periodMonth,
                createdAt: createdAt,
                createdById: createdById,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalLoyaltyLedgerTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalLoyaltyLedgerTable,
      LocalLoyaltyLedgerData,
      $$LocalLoyaltyLedgerTableFilterComposer,
      $$LocalLoyaltyLedgerTableOrderingComposer,
      $$LocalLoyaltyLedgerTableAnnotationComposer,
      $$LocalLoyaltyLedgerTableCreateCompanionBuilder,
      $$LocalLoyaltyLedgerTableUpdateCompanionBuilder,
      (
        LocalLoyaltyLedgerData,
        BaseReferences<
          _$AppDatabase,
          $LocalLoyaltyLedgerTable,
          LocalLoyaltyLedgerData
        >,
      ),
      LocalLoyaltyLedgerData,
      PrefetchHooks Function()
    >;
typedef $$LocalLoyaltyRewardsTableCreateCompanionBuilder =
    LocalLoyaltyRewardsCompanion Function({
      required String id,
      required String vehicleId,
      required DateTime earnedMonth,
      required DateTime validMonth,
      Value<String> status,
      required String earnedFromLedgerId,
      Value<String?> redeemedWashOrderId,
      Value<DateTime?> redeemedAt,
      Value<DateTime?> expiredAt,
      Value<int> rowid,
    });
typedef $$LocalLoyaltyRewardsTableUpdateCompanionBuilder =
    LocalLoyaltyRewardsCompanion Function({
      Value<String> id,
      Value<String> vehicleId,
      Value<DateTime> earnedMonth,
      Value<DateTime> validMonth,
      Value<String> status,
      Value<String> earnedFromLedgerId,
      Value<String?> redeemedWashOrderId,
      Value<DateTime?> redeemedAt,
      Value<DateTime?> expiredAt,
      Value<int> rowid,
    });

class $$LocalLoyaltyRewardsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalLoyaltyRewardsTable> {
  $$LocalLoyaltyRewardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get earnedMonth => $composableBuilder(
    column: $table.earnedMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validMonth => $composableBuilder(
    column: $table.validMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get earnedFromLedgerId => $composableBuilder(
    column: $table.earnedFromLedgerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get redeemedWashOrderId => $composableBuilder(
    column: $table.redeemedWashOrderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get redeemedAt => $composableBuilder(
    column: $table.redeemedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiredAt => $composableBuilder(
    column: $table.expiredAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalLoyaltyRewardsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalLoyaltyRewardsTable> {
  $$LocalLoyaltyRewardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get earnedMonth => $composableBuilder(
    column: $table.earnedMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validMonth => $composableBuilder(
    column: $table.validMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get earnedFromLedgerId => $composableBuilder(
    column: $table.earnedFromLedgerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get redeemedWashOrderId => $composableBuilder(
    column: $table.redeemedWashOrderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get redeemedAt => $composableBuilder(
    column: $table.redeemedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiredAt => $composableBuilder(
    column: $table.expiredAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalLoyaltyRewardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalLoyaltyRewardsTable> {
  $$LocalLoyaltyRewardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vehicleId =>
      $composableBuilder(column: $table.vehicleId, builder: (column) => column);

  GeneratedColumn<DateTime> get earnedMonth => $composableBuilder(
    column: $table.earnedMonth,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get validMonth => $composableBuilder(
    column: $table.validMonth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get earnedFromLedgerId => $composableBuilder(
    column: $table.earnedFromLedgerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get redeemedWashOrderId => $composableBuilder(
    column: $table.redeemedWashOrderId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get redeemedAt => $composableBuilder(
    column: $table.redeemedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiredAt =>
      $composableBuilder(column: $table.expiredAt, builder: (column) => column);
}

class $$LocalLoyaltyRewardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalLoyaltyRewardsTable,
          LocalLoyaltyReward,
          $$LocalLoyaltyRewardsTableFilterComposer,
          $$LocalLoyaltyRewardsTableOrderingComposer,
          $$LocalLoyaltyRewardsTableAnnotationComposer,
          $$LocalLoyaltyRewardsTableCreateCompanionBuilder,
          $$LocalLoyaltyRewardsTableUpdateCompanionBuilder,
          (
            LocalLoyaltyReward,
            BaseReferences<
              _$AppDatabase,
              $LocalLoyaltyRewardsTable,
              LocalLoyaltyReward
            >,
          ),
          LocalLoyaltyReward,
          PrefetchHooks Function()
        > {
  $$LocalLoyaltyRewardsTableTableManager(
    _$AppDatabase db,
    $LocalLoyaltyRewardsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalLoyaltyRewardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalLoyaltyRewardsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalLoyaltyRewardsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<DateTime> earnedMonth = const Value.absent(),
                Value<DateTime> validMonth = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> earnedFromLedgerId = const Value.absent(),
                Value<String?> redeemedWashOrderId = const Value.absent(),
                Value<DateTime?> redeemedAt = const Value.absent(),
                Value<DateTime?> expiredAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalLoyaltyRewardsCompanion(
                id: id,
                vehicleId: vehicleId,
                earnedMonth: earnedMonth,
                validMonth: validMonth,
                status: status,
                earnedFromLedgerId: earnedFromLedgerId,
                redeemedWashOrderId: redeemedWashOrderId,
                redeemedAt: redeemedAt,
                expiredAt: expiredAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vehicleId,
                required DateTime earnedMonth,
                required DateTime validMonth,
                Value<String> status = const Value.absent(),
                required String earnedFromLedgerId,
                Value<String?> redeemedWashOrderId = const Value.absent(),
                Value<DateTime?> redeemedAt = const Value.absent(),
                Value<DateTime?> expiredAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalLoyaltyRewardsCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                earnedMonth: earnedMonth,
                validMonth: validMonth,
                status: status,
                earnedFromLedgerId: earnedFromLedgerId,
                redeemedWashOrderId: redeemedWashOrderId,
                redeemedAt: redeemedAt,
                expiredAt: expiredAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalLoyaltyRewardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalLoyaltyRewardsTable,
      LocalLoyaltyReward,
      $$LocalLoyaltyRewardsTableFilterComposer,
      $$LocalLoyaltyRewardsTableOrderingComposer,
      $$LocalLoyaltyRewardsTableAnnotationComposer,
      $$LocalLoyaltyRewardsTableCreateCompanionBuilder,
      $$LocalLoyaltyRewardsTableUpdateCompanionBuilder,
      (
        LocalLoyaltyReward,
        BaseReferences<
          _$AppDatabase,
          $LocalLoyaltyRewardsTable,
          LocalLoyaltyReward
        >,
      ),
      LocalLoyaltyReward,
      PrefetchHooks Function()
    >;
typedef $$LocalWashOrdersTableCreateCompanionBuilder =
    LocalWashOrdersCompanion Function({
      required String id,
      required String branchId,
      required String vehicleId,
      required String customerId,
      required String status,
      required int totalAmount,
      required DateTime createdAt,
      Value<DateTime?> completedAt,
      Value<DateTime?> cancelledAt,
      Value<String?> cancelReason,
      Value<WashSyncStatus> syncStatus,
      Value<int> rowid,
    });
typedef $$LocalWashOrdersTableUpdateCompanionBuilder =
    LocalWashOrdersCompanion Function({
      Value<String> id,
      Value<String> branchId,
      Value<String> vehicleId,
      Value<String> customerId,
      Value<String> status,
      Value<int> totalAmount,
      Value<DateTime> createdAt,
      Value<DateTime?> completedAt,
      Value<DateTime?> cancelledAt,
      Value<String?> cancelReason,
      Value<WashSyncStatus> syncStatus,
      Value<int> rowid,
    });

class $$LocalWashOrdersTableFilterComposer
    extends Composer<_$AppDatabase, $LocalWashOrdersTable> {
  $$LocalWashOrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cancelReason => $composableBuilder(
    column: $table.cancelReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WashSyncStatus, WashSyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$LocalWashOrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalWashOrdersTable> {
  $$LocalWashOrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cancelReason => $composableBuilder(
    column: $table.cancelReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalWashOrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalWashOrdersTable> {
  $$LocalWashOrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get branchId =>
      $composableBuilder(column: $table.branchId, builder: (column) => column);

  GeneratedColumn<String> get vehicleId =>
      $composableBuilder(column: $table.vehicleId, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cancelReason => $composableBuilder(
    column: $table.cancelReason,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<WashSyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );
}

class $$LocalWashOrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalWashOrdersTable,
          LocalWashOrder,
          $$LocalWashOrdersTableFilterComposer,
          $$LocalWashOrdersTableOrderingComposer,
          $$LocalWashOrdersTableAnnotationComposer,
          $$LocalWashOrdersTableCreateCompanionBuilder,
          $$LocalWashOrdersTableUpdateCompanionBuilder,
          (
            LocalWashOrder,
            BaseReferences<
              _$AppDatabase,
              $LocalWashOrdersTable,
              LocalWashOrder
            >,
          ),
          LocalWashOrder,
          PrefetchHooks Function()
        > {
  $$LocalWashOrdersTableTableManager(
    _$AppDatabase db,
    $LocalWashOrdersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalWashOrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalWashOrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalWashOrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> branchId = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<String> customerId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> totalAmount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> cancelledAt = const Value.absent(),
                Value<String?> cancelReason = const Value.absent(),
                Value<WashSyncStatus> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalWashOrdersCompanion(
                id: id,
                branchId: branchId,
                vehicleId: vehicleId,
                customerId: customerId,
                status: status,
                totalAmount: totalAmount,
                createdAt: createdAt,
                completedAt: completedAt,
                cancelledAt: cancelledAt,
                cancelReason: cancelReason,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String branchId,
                required String vehicleId,
                required String customerId,
                required String status,
                required int totalAmount,
                required DateTime createdAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> cancelledAt = const Value.absent(),
                Value<String?> cancelReason = const Value.absent(),
                Value<WashSyncStatus> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalWashOrdersCompanion.insert(
                id: id,
                branchId: branchId,
                vehicleId: vehicleId,
                customerId: customerId,
                status: status,
                totalAmount: totalAmount,
                createdAt: createdAt,
                completedAt: completedAt,
                cancelledAt: cancelledAt,
                cancelReason: cancelReason,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalWashOrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalWashOrdersTable,
      LocalWashOrder,
      $$LocalWashOrdersTableFilterComposer,
      $$LocalWashOrdersTableOrderingComposer,
      $$LocalWashOrdersTableAnnotationComposer,
      $$LocalWashOrdersTableCreateCompanionBuilder,
      $$LocalWashOrdersTableUpdateCompanionBuilder,
      (
        LocalWashOrder,
        BaseReferences<_$AppDatabase, $LocalWashOrdersTable, LocalWashOrder>,
      ),
      LocalWashOrder,
      PrefetchHooks Function()
    >;
typedef $$LocalWashOrderItemsTableCreateCompanionBuilder =
    LocalWashOrderItemsCompanion Function({
      required String id,
      required String washOrderId,
      required String itemType,
      Value<String?> serviceId,
      Value<String?> extraId,
      required String nameSnapshot,
      required int priceSnapshot,
      Value<int> qty,
      Value<int> rowid,
    });
typedef $$LocalWashOrderItemsTableUpdateCompanionBuilder =
    LocalWashOrderItemsCompanion Function({
      Value<String> id,
      Value<String> washOrderId,
      Value<String> itemType,
      Value<String?> serviceId,
      Value<String?> extraId,
      Value<String> nameSnapshot,
      Value<int> priceSnapshot,
      Value<int> qty,
      Value<int> rowid,
    });

class $$LocalWashOrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalWashOrderItemsTable> {
  $$LocalWashOrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get washOrderId => $composableBuilder(
    column: $table.washOrderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serviceId => $composableBuilder(
    column: $table.serviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extraId => $composableBuilder(
    column: $table.extraId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameSnapshot => $composableBuilder(
    column: $table.nameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceSnapshot => $composableBuilder(
    column: $table.priceSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalWashOrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalWashOrderItemsTable> {
  $$LocalWashOrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get washOrderId => $composableBuilder(
    column: $table.washOrderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serviceId => $composableBuilder(
    column: $table.serviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extraId => $composableBuilder(
    column: $table.extraId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameSnapshot => $composableBuilder(
    column: $table.nameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceSnapshot => $composableBuilder(
    column: $table.priceSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalWashOrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalWashOrderItemsTable> {
  $$LocalWashOrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get washOrderId => $composableBuilder(
    column: $table.washOrderId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<String> get serviceId =>
      $composableBuilder(column: $table.serviceId, builder: (column) => column);

  GeneratedColumn<String> get extraId =>
      $composableBuilder(column: $table.extraId, builder: (column) => column);

  GeneratedColumn<String> get nameSnapshot => $composableBuilder(
    column: $table.nameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priceSnapshot => $composableBuilder(
    column: $table.priceSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);
}

class $$LocalWashOrderItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalWashOrderItemsTable,
          LocalWashOrderItem,
          $$LocalWashOrderItemsTableFilterComposer,
          $$LocalWashOrderItemsTableOrderingComposer,
          $$LocalWashOrderItemsTableAnnotationComposer,
          $$LocalWashOrderItemsTableCreateCompanionBuilder,
          $$LocalWashOrderItemsTableUpdateCompanionBuilder,
          (
            LocalWashOrderItem,
            BaseReferences<
              _$AppDatabase,
              $LocalWashOrderItemsTable,
              LocalWashOrderItem
            >,
          ),
          LocalWashOrderItem,
          PrefetchHooks Function()
        > {
  $$LocalWashOrderItemsTableTableManager(
    _$AppDatabase db,
    $LocalWashOrderItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalWashOrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalWashOrderItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalWashOrderItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> washOrderId = const Value.absent(),
                Value<String> itemType = const Value.absent(),
                Value<String?> serviceId = const Value.absent(),
                Value<String?> extraId = const Value.absent(),
                Value<String> nameSnapshot = const Value.absent(),
                Value<int> priceSnapshot = const Value.absent(),
                Value<int> qty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalWashOrderItemsCompanion(
                id: id,
                washOrderId: washOrderId,
                itemType: itemType,
                serviceId: serviceId,
                extraId: extraId,
                nameSnapshot: nameSnapshot,
                priceSnapshot: priceSnapshot,
                qty: qty,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String washOrderId,
                required String itemType,
                Value<String?> serviceId = const Value.absent(),
                Value<String?> extraId = const Value.absent(),
                required String nameSnapshot,
                required int priceSnapshot,
                Value<int> qty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalWashOrderItemsCompanion.insert(
                id: id,
                washOrderId: washOrderId,
                itemType: itemType,
                serviceId: serviceId,
                extraId: extraId,
                nameSnapshot: nameSnapshot,
                priceSnapshot: priceSnapshot,
                qty: qty,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalWashOrderItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalWashOrderItemsTable,
      LocalWashOrderItem,
      $$LocalWashOrderItemsTableFilterComposer,
      $$LocalWashOrderItemsTableOrderingComposer,
      $$LocalWashOrderItemsTableAnnotationComposer,
      $$LocalWashOrderItemsTableCreateCompanionBuilder,
      $$LocalWashOrderItemsTableUpdateCompanionBuilder,
      (
        LocalWashOrderItem,
        BaseReferences<
          _$AppDatabase,
          $LocalWashOrderItemsTable,
          LocalWashOrderItem
        >,
      ),
      LocalWashOrderItem,
      PrefetchHooks Function()
    >;
typedef $$LocalPaymentsTableCreateCompanionBuilder =
    LocalPaymentsCompanion Function({
      required String id,
      required String washOrderId,
      required int totalAmount,
      required DateTime completedAt,
      Value<int> rowid,
    });
typedef $$LocalPaymentsTableUpdateCompanionBuilder =
    LocalPaymentsCompanion Function({
      Value<String> id,
      Value<String> washOrderId,
      Value<int> totalAmount,
      Value<DateTime> completedAt,
      Value<int> rowid,
    });

class $$LocalPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalPaymentsTable> {
  $$LocalPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get washOrderId => $composableBuilder(
    column: $table.washOrderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalPaymentsTable> {
  $$LocalPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get washOrderId => $composableBuilder(
    column: $table.washOrderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalPaymentsTable> {
  $$LocalPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get washOrderId => $composableBuilder(
    column: $table.washOrderId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$LocalPaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalPaymentsTable,
          LocalPayment,
          $$LocalPaymentsTableFilterComposer,
          $$LocalPaymentsTableOrderingComposer,
          $$LocalPaymentsTableAnnotationComposer,
          $$LocalPaymentsTableCreateCompanionBuilder,
          $$LocalPaymentsTableUpdateCompanionBuilder,
          (
            LocalPayment,
            BaseReferences<_$AppDatabase, $LocalPaymentsTable, LocalPayment>,
          ),
          LocalPayment,
          PrefetchHooks Function()
        > {
  $$LocalPaymentsTableTableManager(_$AppDatabase db, $LocalPaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> washOrderId = const Value.absent(),
                Value<int> totalAmount = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPaymentsCompanion(
                id: id,
                washOrderId: washOrderId,
                totalAmount: totalAmount,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String washOrderId,
                required int totalAmount,
                required DateTime completedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalPaymentsCompanion.insert(
                id: id,
                washOrderId: washOrderId,
                totalAmount: totalAmount,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalPaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalPaymentsTable,
      LocalPayment,
      $$LocalPaymentsTableFilterComposer,
      $$LocalPaymentsTableOrderingComposer,
      $$LocalPaymentsTableAnnotationComposer,
      $$LocalPaymentsTableCreateCompanionBuilder,
      $$LocalPaymentsTableUpdateCompanionBuilder,
      (
        LocalPayment,
        BaseReferences<_$AppDatabase, $LocalPaymentsTable, LocalPayment>,
      ),
      LocalPayment,
      PrefetchHooks Function()
    >;
typedef $$LocalPaymentComponentsTableCreateCompanionBuilder =
    LocalPaymentComponentsCompanion Function({
      required String id,
      required String paymentId,
      required String method,
      required int amount,
      Value<String?> externalReference,
      Value<int> rowid,
    });
typedef $$LocalPaymentComponentsTableUpdateCompanionBuilder =
    LocalPaymentComponentsCompanion Function({
      Value<String> id,
      Value<String> paymentId,
      Value<String> method,
      Value<int> amount,
      Value<String?> externalReference,
      Value<int> rowid,
    });

class $$LocalPaymentComponentsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalPaymentComponentsTable> {
  $$LocalPaymentComponentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentId => $composableBuilder(
    column: $table.paymentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalReference => $composableBuilder(
    column: $table.externalReference,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalPaymentComponentsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalPaymentComponentsTable> {
  $$LocalPaymentComponentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentId => $composableBuilder(
    column: $table.paymentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalReference => $composableBuilder(
    column: $table.externalReference,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalPaymentComponentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalPaymentComponentsTable> {
  $$LocalPaymentComponentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get paymentId =>
      $composableBuilder(column: $table.paymentId, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get externalReference => $composableBuilder(
    column: $table.externalReference,
    builder: (column) => column,
  );
}

class $$LocalPaymentComponentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalPaymentComponentsTable,
          LocalPaymentComponent,
          $$LocalPaymentComponentsTableFilterComposer,
          $$LocalPaymentComponentsTableOrderingComposer,
          $$LocalPaymentComponentsTableAnnotationComposer,
          $$LocalPaymentComponentsTableCreateCompanionBuilder,
          $$LocalPaymentComponentsTableUpdateCompanionBuilder,
          (
            LocalPaymentComponent,
            BaseReferences<
              _$AppDatabase,
              $LocalPaymentComponentsTable,
              LocalPaymentComponent
            >,
          ),
          LocalPaymentComponent,
          PrefetchHooks Function()
        > {
  $$LocalPaymentComponentsTableTableManager(
    _$AppDatabase db,
    $LocalPaymentComponentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPaymentComponentsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalPaymentComponentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalPaymentComponentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> paymentId = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String?> externalReference = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPaymentComponentsCompanion(
                id: id,
                paymentId: paymentId,
                method: method,
                amount: amount,
                externalReference: externalReference,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String paymentId,
                required String method,
                required int amount,
                Value<String?> externalReference = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPaymentComponentsCompanion.insert(
                id: id,
                paymentId: paymentId,
                method: method,
                amount: amount,
                externalReference: externalReference,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalPaymentComponentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalPaymentComponentsTable,
      LocalPaymentComponent,
      $$LocalPaymentComponentsTableFilterComposer,
      $$LocalPaymentComponentsTableOrderingComposer,
      $$LocalPaymentComponentsTableAnnotationComposer,
      $$LocalPaymentComponentsTableCreateCompanionBuilder,
      $$LocalPaymentComponentsTableUpdateCompanionBuilder,
      (
        LocalPaymentComponent,
        BaseReferences<
          _$AppDatabase,
          $LocalPaymentComponentsTable,
          LocalPaymentComponent
        >,
      ),
      LocalPaymentComponent,
      PrefetchHooks Function()
    >;
typedef $$PendingSyncOpsTableCreateCompanionBuilder =
    PendingSyncOpsCompanion Function({
      Value<int> rowId,
      required String entityType,
      required String entityId,
      required String opType,
      required String payloadJson,
      required String idempotencyKey,
      Value<DateTime> createdAt,
      Value<String> status,
      Value<String?> lastError,
      Value<int> attemptCount,
    });
typedef $$PendingSyncOpsTableUpdateCompanionBuilder =
    PendingSyncOpsCompanion Function({
      Value<int> rowId,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> opType,
      Value<String> payloadJson,
      Value<String> idempotencyKey,
      Value<DateTime> createdAt,
      Value<String> status,
      Value<String?> lastError,
      Value<int> attemptCount,
    });

class $$PendingSyncOpsTableFilterComposer
    extends Composer<_$AppDatabase, $PendingSyncOpsTable> {
  $$PendingSyncOpsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get opType => $composableBuilder(
    column: $table.opType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingSyncOpsTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingSyncOpsTable> {
  $$PendingSyncOpsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get opType => $composableBuilder(
    column: $table.opType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingSyncOpsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingSyncOpsTable> {
  $$PendingSyncOpsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get opType =>
      $composableBuilder(column: $table.opType, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );
}

class $$PendingSyncOpsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingSyncOpsTable,
          PendingSyncOp,
          $$PendingSyncOpsTableFilterComposer,
          $$PendingSyncOpsTableOrderingComposer,
          $$PendingSyncOpsTableAnnotationComposer,
          $$PendingSyncOpsTableCreateCompanionBuilder,
          $$PendingSyncOpsTableUpdateCompanionBuilder,
          (
            PendingSyncOp,
            BaseReferences<_$AppDatabase, $PendingSyncOpsTable, PendingSyncOp>,
          ),
          PendingSyncOp,
          PrefetchHooks Function()
        > {
  $$PendingSyncOpsTableTableManager(
    _$AppDatabase db,
    $PendingSyncOpsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingSyncOpsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingSyncOpsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingSyncOpsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> opType = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
              }) => PendingSyncOpsCompanion(
                rowId: rowId,
                entityType: entityType,
                entityId: entityId,
                opType: opType,
                payloadJson: payloadJson,
                idempotencyKey: idempotencyKey,
                createdAt: createdAt,
                status: status,
                lastError: lastError,
                attemptCount: attemptCount,
              ),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required String entityType,
                required String entityId,
                required String opType,
                required String payloadJson,
                required String idempotencyKey,
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
              }) => PendingSyncOpsCompanion.insert(
                rowId: rowId,
                entityType: entityType,
                entityId: entityId,
                opType: opType,
                payloadJson: payloadJson,
                idempotencyKey: idempotencyKey,
                createdAt: createdAt,
                status: status,
                lastError: lastError,
                attemptCount: attemptCount,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingSyncOpsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingSyncOpsTable,
      PendingSyncOp,
      $$PendingSyncOpsTableFilterComposer,
      $$PendingSyncOpsTableOrderingComposer,
      $$PendingSyncOpsTableAnnotationComposer,
      $$PendingSyncOpsTableCreateCompanionBuilder,
      $$PendingSyncOpsTableUpdateCompanionBuilder,
      (
        PendingSyncOp,
        BaseReferences<_$AppDatabase, $PendingSyncOpsTable, PendingSyncOp>,
      ),
      PendingSyncOp,
      PrefetchHooks Function()
    >;
typedef $$SyncMetaTableCreateCompanionBuilder = SyncMetaCompanion Function({
  required String key,
  required DateTime lastPulledAt,
  Value<int> rowid,
});
typedef $$SyncMetaTableUpdateCompanionBuilder = SyncMetaCompanion Function({
  Value<String> key,
  Value<DateTime> lastPulledAt,
  Value<int> rowid,
});

class $$SyncMetaTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPulledAt => $composableBuilder(
    column: $table.lastPulledAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPulledAt => $composableBuilder(
    column: $table.lastPulledAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPulledAt => $composableBuilder(
    column: $table.lastPulledAt,
    builder: (column) => column,
  );
}

class $$SyncMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncMetaTable,
          SyncMetaData,
          $$SyncMetaTableFilterComposer,
          $$SyncMetaTableOrderingComposer,
          $$SyncMetaTableAnnotationComposer,
          $$SyncMetaTableCreateCompanionBuilder,
          $$SyncMetaTableUpdateCompanionBuilder,
          (
            SyncMetaData,
            BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaData>,
          ),
          SyncMetaData,
          PrefetchHooks Function()
        > {
  $$SyncMetaTableTableManager(_$AppDatabase db, $SyncMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<DateTime> lastPulledAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetaCompanion(
                key: key,
                lastPulledAt: lastPulledAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required DateTime lastPulledAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncMetaCompanion.insert(
                key: key,
                lastPulledAt: lastPulledAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncMetaTable,
      SyncMetaData,
      $$SyncMetaTableFilterComposer,
      $$SyncMetaTableOrderingComposer,
      $$SyncMetaTableAnnotationComposer,
      $$SyncMetaTableCreateCompanionBuilder,
      $$SyncMetaTableUpdateCompanionBuilder,
      (
        SyncMetaData,
        BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaData>,
      ),
      SyncMetaData,
      PrefetchHooks Function()
    >;
typedef $$LocalExpenseCategoriesTableCreateCompanionBuilder =
    LocalExpenseCategoriesCompanion Function({
      required String id,
      required String name,
      Value<int> rowid,
    });
typedef $$LocalExpenseCategoriesTableUpdateCompanionBuilder =
    LocalExpenseCategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> rowid,
    });

class $$LocalExpenseCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalExpenseCategoriesTable> {
  $$LocalExpenseCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalExpenseCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalExpenseCategoriesTable> {
  $$LocalExpenseCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalExpenseCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalExpenseCategoriesTable> {
  $$LocalExpenseCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$LocalExpenseCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalExpenseCategoriesTable,
          LocalExpenseCategory,
          $$LocalExpenseCategoriesTableFilterComposer,
          $$LocalExpenseCategoriesTableOrderingComposer,
          $$LocalExpenseCategoriesTableAnnotationComposer,
          $$LocalExpenseCategoriesTableCreateCompanionBuilder,
          $$LocalExpenseCategoriesTableUpdateCompanionBuilder,
          (
            LocalExpenseCategory,
            BaseReferences<
              _$AppDatabase,
              $LocalExpenseCategoriesTable,
              LocalExpenseCategory
            >,
          ),
          LocalExpenseCategory,
          PrefetchHooks Function()
        > {
  $$LocalExpenseCategoriesTableTableManager(
    _$AppDatabase db,
    $LocalExpenseCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalExpenseCategoriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalExpenseCategoriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalExpenseCategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalExpenseCategoriesCompanion(
                id: id,
                name: name,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => LocalExpenseCategoriesCompanion.insert(
                id: id,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalExpenseCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalExpenseCategoriesTable,
      LocalExpenseCategory,
      $$LocalExpenseCategoriesTableFilterComposer,
      $$LocalExpenseCategoriesTableOrderingComposer,
      $$LocalExpenseCategoriesTableAnnotationComposer,
      $$LocalExpenseCategoriesTableCreateCompanionBuilder,
      $$LocalExpenseCategoriesTableUpdateCompanionBuilder,
      (
        LocalExpenseCategory,
        BaseReferences<
          _$AppDatabase,
          $LocalExpenseCategoriesTable,
          LocalExpenseCategory
        >,
      ),
      LocalExpenseCategory,
      PrefetchHooks Function()
    >;
typedef $$LocalExpensesTableCreateCompanionBuilder =
    LocalExpensesCompanion Function({
      required String id,
      required String branchId,
      required String categoryId,
      required String description,
      required int amount,
      required String paymentMethod,
      required DateTime createdAt,
      Value<bool> dirty,
      Value<int> rowid,
    });
typedef $$LocalExpensesTableUpdateCompanionBuilder =
    LocalExpensesCompanion Function({
      Value<String> id,
      Value<String> branchId,
      Value<String> categoryId,
      Value<String> description,
      Value<int> amount,
      Value<String> paymentMethod,
      Value<DateTime> createdAt,
      Value<bool> dirty,
      Value<int> rowid,
    });

class $$LocalExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalExpensesTable> {
  $$LocalExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalExpensesTable> {
  $$LocalExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalExpensesTable> {
  $$LocalExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get branchId =>
      $composableBuilder(column: $table.branchId, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);
}

class $$LocalExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalExpensesTable,
          LocalExpense,
          $$LocalExpensesTableFilterComposer,
          $$LocalExpensesTableOrderingComposer,
          $$LocalExpensesTableAnnotationComposer,
          $$LocalExpensesTableCreateCompanionBuilder,
          $$LocalExpensesTableUpdateCompanionBuilder,
          (
            LocalExpense,
            BaseReferences<_$AppDatabase, $LocalExpensesTable, LocalExpense>,
          ),
          LocalExpense,
          PrefetchHooks Function()
        > {
  $$LocalExpensesTableTableManager(_$AppDatabase db, $LocalExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> branchId = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalExpensesCompanion(
                id: id,
                branchId: branchId,
                categoryId: categoryId,
                description: description,
                amount: amount,
                paymentMethod: paymentMethod,
                createdAt: createdAt,
                dirty: dirty,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String branchId,
                required String categoryId,
                required String description,
                required int amount,
                required String paymentMethod,
                required DateTime createdAt,
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalExpensesCompanion.insert(
                id: id,
                branchId: branchId,
                categoryId: categoryId,
                description: description,
                amount: amount,
                paymentMethod: paymentMethod,
                createdAt: createdAt,
                dirty: dirty,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalExpensesTable,
      LocalExpense,
      $$LocalExpensesTableFilterComposer,
      $$LocalExpensesTableOrderingComposer,
      $$LocalExpensesTableAnnotationComposer,
      $$LocalExpensesTableCreateCompanionBuilder,
      $$LocalExpensesTableUpdateCompanionBuilder,
      (
        LocalExpense,
        BaseReferences<_$AppDatabase, $LocalExpensesTable, LocalExpense>,
      ),
      LocalExpense,
      PrefetchHooks Function()
    >;
typedef $$LocalPrepaidPackagesTableCreateCompanionBuilder =
    LocalPrepaidPackagesCompanion Function({
      required String id,
      required String name,
      required String eligibleTiers,
      required int washCount,
      required int price,
      required int validityDays,
      required String applicableScope,
      Value<int> rowid,
    });
typedef $$LocalPrepaidPackagesTableUpdateCompanionBuilder =
    LocalPrepaidPackagesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> eligibleTiers,
      Value<int> washCount,
      Value<int> price,
      Value<int> validityDays,
      Value<String> applicableScope,
      Value<int> rowid,
    });

class $$LocalPrepaidPackagesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalPrepaidPackagesTable> {
  $$LocalPrepaidPackagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eligibleTiers => $composableBuilder(
    column: $table.eligibleTiers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get washCount => $composableBuilder(
    column: $table.washCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get validityDays => $composableBuilder(
    column: $table.validityDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get applicableScope => $composableBuilder(
    column: $table.applicableScope,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalPrepaidPackagesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalPrepaidPackagesTable> {
  $$LocalPrepaidPackagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eligibleTiers => $composableBuilder(
    column: $table.eligibleTiers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get washCount => $composableBuilder(
    column: $table.washCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get validityDays => $composableBuilder(
    column: $table.validityDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get applicableScope => $composableBuilder(
    column: $table.applicableScope,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalPrepaidPackagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalPrepaidPackagesTable> {
  $$LocalPrepaidPackagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get eligibleTiers => $composableBuilder(
    column: $table.eligibleTiers,
    builder: (column) => column,
  );

  GeneratedColumn<int> get washCount =>
      $composableBuilder(column: $table.washCount, builder: (column) => column);

  GeneratedColumn<int> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get validityDays => $composableBuilder(
    column: $table.validityDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get applicableScope => $composableBuilder(
    column: $table.applicableScope,
    builder: (column) => column,
  );
}

class $$LocalPrepaidPackagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalPrepaidPackagesTable,
          LocalPrepaidPackage,
          $$LocalPrepaidPackagesTableFilterComposer,
          $$LocalPrepaidPackagesTableOrderingComposer,
          $$LocalPrepaidPackagesTableAnnotationComposer,
          $$LocalPrepaidPackagesTableCreateCompanionBuilder,
          $$LocalPrepaidPackagesTableUpdateCompanionBuilder,
          (
            LocalPrepaidPackage,
            BaseReferences<
              _$AppDatabase,
              $LocalPrepaidPackagesTable,
              LocalPrepaidPackage
            >,
          ),
          LocalPrepaidPackage,
          PrefetchHooks Function()
        > {
  $$LocalPrepaidPackagesTableTableManager(
    _$AppDatabase db,
    $LocalPrepaidPackagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPrepaidPackagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalPrepaidPackagesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalPrepaidPackagesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> eligibleTiers = const Value.absent(),
                Value<int> washCount = const Value.absent(),
                Value<int> price = const Value.absent(),
                Value<int> validityDays = const Value.absent(),
                Value<String> applicableScope = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPrepaidPackagesCompanion(
                id: id,
                name: name,
                eligibleTiers: eligibleTiers,
                washCount: washCount,
                price: price,
                validityDays: validityDays,
                applicableScope: applicableScope,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String eligibleTiers,
                required int washCount,
                required int price,
                required int validityDays,
                required String applicableScope,
                Value<int> rowid = const Value.absent(),
              }) => LocalPrepaidPackagesCompanion.insert(
                id: id,
                name: name,
                eligibleTiers: eligibleTiers,
                washCount: washCount,
                price: price,
                validityDays: validityDays,
                applicableScope: applicableScope,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalPrepaidPackagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalPrepaidPackagesTable,
      LocalPrepaidPackage,
      $$LocalPrepaidPackagesTableFilterComposer,
      $$LocalPrepaidPackagesTableOrderingComposer,
      $$LocalPrepaidPackagesTableAnnotationComposer,
      $$LocalPrepaidPackagesTableCreateCompanionBuilder,
      $$LocalPrepaidPackagesTableUpdateCompanionBuilder,
      (
        LocalPrepaidPackage,
        BaseReferences<
          _$AppDatabase,
          $LocalPrepaidPackagesTable,
          LocalPrepaidPackage
        >,
      ),
      LocalPrepaidPackage,
      PrefetchHooks Function()
    >;
typedef $$LocalPrepaidWalletsTableCreateCompanionBuilder =
    LocalPrepaidWalletsCompanion Function({
      required String customerId,
      required int balance,
      required DateTime asOf,
      Value<int> rowid,
    });
typedef $$LocalPrepaidWalletsTableUpdateCompanionBuilder =
    LocalPrepaidWalletsCompanion Function({
      Value<String> customerId,
      Value<int> balance,
      Value<DateTime> asOf,
      Value<int> rowid,
    });

class $$LocalPrepaidWalletsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalPrepaidWalletsTable> {
  $$LocalPrepaidWalletsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get asOf => $composableBuilder(
    column: $table.asOf,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalPrepaidWalletsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalPrepaidWalletsTable> {
  $$LocalPrepaidWalletsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get asOf => $composableBuilder(
    column: $table.asOf,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalPrepaidWalletsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalPrepaidWalletsTable> {
  $$LocalPrepaidWalletsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<DateTime> get asOf =>
      $composableBuilder(column: $table.asOf, builder: (column) => column);
}

class $$LocalPrepaidWalletsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalPrepaidWalletsTable,
          LocalPrepaidWallet,
          $$LocalPrepaidWalletsTableFilterComposer,
          $$LocalPrepaidWalletsTableOrderingComposer,
          $$LocalPrepaidWalletsTableAnnotationComposer,
          $$LocalPrepaidWalletsTableCreateCompanionBuilder,
          $$LocalPrepaidWalletsTableUpdateCompanionBuilder,
          (
            LocalPrepaidWallet,
            BaseReferences<
              _$AppDatabase,
              $LocalPrepaidWalletsTable,
              LocalPrepaidWallet
            >,
          ),
          LocalPrepaidWallet,
          PrefetchHooks Function()
        > {
  $$LocalPrepaidWalletsTableTableManager(
    _$AppDatabase db,
    $LocalPrepaidWalletsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPrepaidWalletsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalPrepaidWalletsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalPrepaidWalletsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> customerId = const Value.absent(),
                Value<int> balance = const Value.absent(),
                Value<DateTime> asOf = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPrepaidWalletsCompanion(
                customerId: customerId,
                balance: balance,
                asOf: asOf,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String customerId,
                required int balance,
                required DateTime asOf,
                Value<int> rowid = const Value.absent(),
              }) => LocalPrepaidWalletsCompanion.insert(
                customerId: customerId,
                balance: balance,
                asOf: asOf,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalPrepaidWalletsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalPrepaidWalletsTable,
      LocalPrepaidWallet,
      $$LocalPrepaidWalletsTableFilterComposer,
      $$LocalPrepaidWalletsTableOrderingComposer,
      $$LocalPrepaidWalletsTableAnnotationComposer,
      $$LocalPrepaidWalletsTableCreateCompanionBuilder,
      $$LocalPrepaidWalletsTableUpdateCompanionBuilder,
      (
        LocalPrepaidWallet,
        BaseReferences<
          _$AppDatabase,
          $LocalPrepaidWalletsTable,
          LocalPrepaidWallet
        >,
      ),
      LocalPrepaidWallet,
      PrefetchHooks Function()
    >;
typedef $$LocalPrepaidWalletLedgerTableCreateCompanionBuilder =
    LocalPrepaidWalletLedgerCompanion Function({
      required String id,
      required String customerId,
      required String entryType,
      required int amount,
      required int balanceAfter,
      Value<String?> method,
      Value<String?> reference,
      Value<DateTime> createdAt,
      required String createdById,
      required String clientEntryId,
      Value<int> rowid,
    });
typedef $$LocalPrepaidWalletLedgerTableUpdateCompanionBuilder =
    LocalPrepaidWalletLedgerCompanion Function({
      Value<String> id,
      Value<String> customerId,
      Value<String> entryType,
      Value<int> amount,
      Value<int> balanceAfter,
      Value<String?> method,
      Value<String?> reference,
      Value<DateTime> createdAt,
      Value<String> createdById,
      Value<String> clientEntryId,
      Value<int> rowid,
    });

class $$LocalPrepaidWalletLedgerTableFilterComposer
    extends Composer<_$AppDatabase, $LocalPrepaidWalletLedgerTable> {
  $$LocalPrepaidWalletLedgerTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entryType => $composableBuilder(
    column: $table.entryType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balanceAfter => $composableBuilder(
    column: $table.balanceAfter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdById => $composableBuilder(
    column: $table.createdById,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientEntryId => $composableBuilder(
    column: $table.clientEntryId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalPrepaidWalletLedgerTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalPrepaidWalletLedgerTable> {
  $$LocalPrepaidWalletLedgerTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entryType => $composableBuilder(
    column: $table.entryType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balanceAfter => $composableBuilder(
    column: $table.balanceAfter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdById => $composableBuilder(
    column: $table.createdById,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientEntryId => $composableBuilder(
    column: $table.clientEntryId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalPrepaidWalletLedgerTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalPrepaidWalletLedgerTable> {
  $$LocalPrepaidWalletLedgerTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entryType =>
      $composableBuilder(column: $table.entryType, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get balanceAfter => $composableBuilder(
    column: $table.balanceAfter,
    builder: (column) => column,
  );

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdById => $composableBuilder(
    column: $table.createdById,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientEntryId => $composableBuilder(
    column: $table.clientEntryId,
    builder: (column) => column,
  );
}

class $$LocalPrepaidWalletLedgerTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalPrepaidWalletLedgerTable,
          LocalPrepaidWalletLedgerData,
          $$LocalPrepaidWalletLedgerTableFilterComposer,
          $$LocalPrepaidWalletLedgerTableOrderingComposer,
          $$LocalPrepaidWalletLedgerTableAnnotationComposer,
          $$LocalPrepaidWalletLedgerTableCreateCompanionBuilder,
          $$LocalPrepaidWalletLedgerTableUpdateCompanionBuilder,
          (
            LocalPrepaidWalletLedgerData,
            BaseReferences<
              _$AppDatabase,
              $LocalPrepaidWalletLedgerTable,
              LocalPrepaidWalletLedgerData
            >,
          ),
          LocalPrepaidWalletLedgerData,
          PrefetchHooks Function()
        > {
  $$LocalPrepaidWalletLedgerTableTableManager(
    _$AppDatabase db,
    $LocalPrepaidWalletLedgerTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPrepaidWalletLedgerTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalPrepaidWalletLedgerTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalPrepaidWalletLedgerTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> customerId = const Value.absent(),
                Value<String> entryType = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<int> balanceAfter = const Value.absent(),
                Value<String?> method = const Value.absent(),
                Value<String?> reference = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdById = const Value.absent(),
                Value<String> clientEntryId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPrepaidWalletLedgerCompanion(
                id: id,
                customerId: customerId,
                entryType: entryType,
                amount: amount,
                balanceAfter: balanceAfter,
                method: method,
                reference: reference,
                createdAt: createdAt,
                createdById: createdById,
                clientEntryId: clientEntryId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String customerId,
                required String entryType,
                required int amount,
                required int balanceAfter,
                Value<String?> method = const Value.absent(),
                Value<String?> reference = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                required String createdById,
                required String clientEntryId,
                Value<int> rowid = const Value.absent(),
              }) => LocalPrepaidWalletLedgerCompanion.insert(
                id: id,
                customerId: customerId,
                entryType: entryType,
                amount: amount,
                balanceAfter: balanceAfter,
                method: method,
                reference: reference,
                createdAt: createdAt,
                createdById: createdById,
                clientEntryId: clientEntryId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalPrepaidWalletLedgerTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalPrepaidWalletLedgerTable,
      LocalPrepaidWalletLedgerData,
      $$LocalPrepaidWalletLedgerTableFilterComposer,
      $$LocalPrepaidWalletLedgerTableOrderingComposer,
      $$LocalPrepaidWalletLedgerTableAnnotationComposer,
      $$LocalPrepaidWalletLedgerTableCreateCompanionBuilder,
      $$LocalPrepaidWalletLedgerTableUpdateCompanionBuilder,
      (
        LocalPrepaidWalletLedgerData,
        BaseReferences<
          _$AppDatabase,
          $LocalPrepaidWalletLedgerTable,
          LocalPrepaidWalletLedgerData
        >,
      ),
      LocalPrepaidWalletLedgerData,
      PrefetchHooks Function()
    >;
typedef $$LocalPrepaidPackagePurchasesTableCreateCompanionBuilder =
    LocalPrepaidPackagePurchasesCompanion Function({
      required String id,
      required String packageId,
      required String customerId,
      Value<String?> vehicleId,
      Value<DateTime> purchasedAt,
      required DateTime expiresAt,
      required int remainingCount,
      Value<int> rowid,
    });
typedef $$LocalPrepaidPackagePurchasesTableUpdateCompanionBuilder =
    LocalPrepaidPackagePurchasesCompanion Function({
      Value<String> id,
      Value<String> packageId,
      Value<String> customerId,
      Value<String?> vehicleId,
      Value<DateTime> purchasedAt,
      Value<DateTime> expiresAt,
      Value<int> remainingCount,
      Value<int> rowid,
    });

class $$LocalPrepaidPackagePurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalPrepaidPackagePurchasesTable> {
  $$LocalPrepaidPackagePurchasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packageId => $composableBuilder(
    column: $table.packageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remainingCount => $composableBuilder(
    column: $table.remainingCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalPrepaidPackagePurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalPrepaidPackagePurchasesTable> {
  $$LocalPrepaidPackagePurchasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packageId => $composableBuilder(
    column: $table.packageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remainingCount => $composableBuilder(
    column: $table.remainingCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalPrepaidPackagePurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalPrepaidPackagePurchasesTable> {
  $$LocalPrepaidPackagePurchasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get packageId =>
      $composableBuilder(column: $table.packageId, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vehicleId =>
      $composableBuilder(column: $table.vehicleId, builder: (column) => column);

  GeneratedColumn<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<int> get remainingCount => $composableBuilder(
    column: $table.remainingCount,
    builder: (column) => column,
  );
}

class $$LocalPrepaidPackagePurchasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalPrepaidPackagePurchasesTable,
          LocalPrepaidPackagePurchase,
          $$LocalPrepaidPackagePurchasesTableFilterComposer,
          $$LocalPrepaidPackagePurchasesTableOrderingComposer,
          $$LocalPrepaidPackagePurchasesTableAnnotationComposer,
          $$LocalPrepaidPackagePurchasesTableCreateCompanionBuilder,
          $$LocalPrepaidPackagePurchasesTableUpdateCompanionBuilder,
          (
            LocalPrepaidPackagePurchase,
            BaseReferences<
              _$AppDatabase,
              $LocalPrepaidPackagePurchasesTable,
              LocalPrepaidPackagePurchase
            >,
          ),
          LocalPrepaidPackagePurchase,
          PrefetchHooks Function()
        > {
  $$LocalPrepaidPackagePurchasesTableTableManager(
    _$AppDatabase db,
    $LocalPrepaidPackagePurchasesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPrepaidPackagePurchasesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalPrepaidPackagePurchasesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalPrepaidPackagePurchasesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packageId = const Value.absent(),
                Value<String> customerId = const Value.absent(),
                Value<String?> vehicleId = const Value.absent(),
                Value<DateTime> purchasedAt = const Value.absent(),
                Value<DateTime> expiresAt = const Value.absent(),
                Value<int> remainingCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPrepaidPackagePurchasesCompanion(
                id: id,
                packageId: packageId,
                customerId: customerId,
                vehicleId: vehicleId,
                purchasedAt: purchasedAt,
                expiresAt: expiresAt,
                remainingCount: remainingCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packageId,
                required String customerId,
                Value<String?> vehicleId = const Value.absent(),
                Value<DateTime> purchasedAt = const Value.absent(),
                required DateTime expiresAt,
                required int remainingCount,
                Value<int> rowid = const Value.absent(),
              }) => LocalPrepaidPackagePurchasesCompanion.insert(
                id: id,
                packageId: packageId,
                customerId: customerId,
                vehicleId: vehicleId,
                purchasedAt: purchasedAt,
                expiresAt: expiresAt,
                remainingCount: remainingCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalPrepaidPackagePurchasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalPrepaidPackagePurchasesTable,
      LocalPrepaidPackagePurchase,
      $$LocalPrepaidPackagePurchasesTableFilterComposer,
      $$LocalPrepaidPackagePurchasesTableOrderingComposer,
      $$LocalPrepaidPackagePurchasesTableAnnotationComposer,
      $$LocalPrepaidPackagePurchasesTableCreateCompanionBuilder,
      $$LocalPrepaidPackagePurchasesTableUpdateCompanionBuilder,
      (
        LocalPrepaidPackagePurchase,
        BaseReferences<
          _$AppDatabase,
          $LocalPrepaidPackagePurchasesTable,
          LocalPrepaidPackagePurchase
        >,
      ),
      LocalPrepaidPackagePurchase,
      PrefetchHooks Function()
    >;
typedef $$LocalPrepaidPackageUsageTableCreateCompanionBuilder =
    LocalPrepaidPackageUsageCompanion Function({
      required String id,
      required String purchaseId,
      required String washOrderId,
      required String vehicleId,
      Value<DateTime> usedAt,
      required String usedById,
      required String clientEntryId,
      Value<int> rowid,
    });
typedef $$LocalPrepaidPackageUsageTableUpdateCompanionBuilder =
    LocalPrepaidPackageUsageCompanion Function({
      Value<String> id,
      Value<String> purchaseId,
      Value<String> washOrderId,
      Value<String> vehicleId,
      Value<DateTime> usedAt,
      Value<String> usedById,
      Value<String> clientEntryId,
      Value<int> rowid,
    });

class $$LocalPrepaidPackageUsageTableFilterComposer
    extends Composer<_$AppDatabase, $LocalPrepaidPackageUsageTable> {
  $$LocalPrepaidPackageUsageTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get washOrderId => $composableBuilder(
    column: $table.washOrderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get usedAt => $composableBuilder(
    column: $table.usedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usedById => $composableBuilder(
    column: $table.usedById,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientEntryId => $composableBuilder(
    column: $table.clientEntryId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalPrepaidPackageUsageTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalPrepaidPackageUsageTable> {
  $$LocalPrepaidPackageUsageTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get washOrderId => $composableBuilder(
    column: $table.washOrderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get usedAt => $composableBuilder(
    column: $table.usedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usedById => $composableBuilder(
    column: $table.usedById,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientEntryId => $composableBuilder(
    column: $table.clientEntryId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalPrepaidPackageUsageTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalPrepaidPackageUsageTable> {
  $$LocalPrepaidPackageUsageTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get washOrderId => $composableBuilder(
    column: $table.washOrderId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vehicleId =>
      $composableBuilder(column: $table.vehicleId, builder: (column) => column);

  GeneratedColumn<DateTime> get usedAt =>
      $composableBuilder(column: $table.usedAt, builder: (column) => column);

  GeneratedColumn<String> get usedById =>
      $composableBuilder(column: $table.usedById, builder: (column) => column);

  GeneratedColumn<String> get clientEntryId => $composableBuilder(
    column: $table.clientEntryId,
    builder: (column) => column,
  );
}

class $$LocalPrepaidPackageUsageTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalPrepaidPackageUsageTable,
          LocalPrepaidPackageUsageData,
          $$LocalPrepaidPackageUsageTableFilterComposer,
          $$LocalPrepaidPackageUsageTableOrderingComposer,
          $$LocalPrepaidPackageUsageTableAnnotationComposer,
          $$LocalPrepaidPackageUsageTableCreateCompanionBuilder,
          $$LocalPrepaidPackageUsageTableUpdateCompanionBuilder,
          (
            LocalPrepaidPackageUsageData,
            BaseReferences<
              _$AppDatabase,
              $LocalPrepaidPackageUsageTable,
              LocalPrepaidPackageUsageData
            >,
          ),
          LocalPrepaidPackageUsageData,
          PrefetchHooks Function()
        > {
  $$LocalPrepaidPackageUsageTableTableManager(
    _$AppDatabase db,
    $LocalPrepaidPackageUsageTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPrepaidPackageUsageTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalPrepaidPackageUsageTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalPrepaidPackageUsageTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> purchaseId = const Value.absent(),
                Value<String> washOrderId = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<DateTime> usedAt = const Value.absent(),
                Value<String> usedById = const Value.absent(),
                Value<String> clientEntryId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPrepaidPackageUsageCompanion(
                id: id,
                purchaseId: purchaseId,
                washOrderId: washOrderId,
                vehicleId: vehicleId,
                usedAt: usedAt,
                usedById: usedById,
                clientEntryId: clientEntryId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String purchaseId,
                required String washOrderId,
                required String vehicleId,
                Value<DateTime> usedAt = const Value.absent(),
                required String usedById,
                required String clientEntryId,
                Value<int> rowid = const Value.absent(),
              }) => LocalPrepaidPackageUsageCompanion.insert(
                id: id,
                purchaseId: purchaseId,
                washOrderId: washOrderId,
                vehicleId: vehicleId,
                usedAt: usedAt,
                usedById: usedById,
                clientEntryId: clientEntryId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalPrepaidPackageUsageTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalPrepaidPackageUsageTable,
      LocalPrepaidPackageUsageData,
      $$LocalPrepaidPackageUsageTableFilterComposer,
      $$LocalPrepaidPackageUsageTableOrderingComposer,
      $$LocalPrepaidPackageUsageTableAnnotationComposer,
      $$LocalPrepaidPackageUsageTableCreateCompanionBuilder,
      $$LocalPrepaidPackageUsageTableUpdateCompanionBuilder,
      (
        LocalPrepaidPackageUsageData,
        BaseReferences<
          _$AppDatabase,
          $LocalPrepaidPackageUsageTable,
          LocalPrepaidPackageUsageData
        >,
      ),
      LocalPrepaidPackageUsageData,
      PrefetchHooks Function()
    >;
typedef $$LocalCashCollectionsTableCreateCompanionBuilder =
    LocalCashCollectionsCompanion Function({
      required String id,
      required String branchId,
      required int countedCash,
      Value<String?> varianceReason,
      Value<String?> witness,
      Value<String?> notes,
      required DateTime countedAt,
      Value<int> rowid,
    });
typedef $$LocalCashCollectionsTableUpdateCompanionBuilder =
    LocalCashCollectionsCompanion Function({
      Value<String> id,
      Value<String> branchId,
      Value<int> countedCash,
      Value<String?> varianceReason,
      Value<String?> witness,
      Value<String?> notes,
      Value<DateTime> countedAt,
      Value<int> rowid,
    });

class $$LocalCashCollectionsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalCashCollectionsTable> {
  $$LocalCashCollectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get countedCash => $composableBuilder(
    column: $table.countedCash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get varianceReason => $composableBuilder(
    column: $table.varianceReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get witness => $composableBuilder(
    column: $table.witness,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get countedAt => $composableBuilder(
    column: $table.countedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalCashCollectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalCashCollectionsTable> {
  $$LocalCashCollectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get countedCash => $composableBuilder(
    column: $table.countedCash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get varianceReason => $composableBuilder(
    column: $table.varianceReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get witness => $composableBuilder(
    column: $table.witness,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get countedAt => $composableBuilder(
    column: $table.countedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalCashCollectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalCashCollectionsTable> {
  $$LocalCashCollectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get branchId =>
      $composableBuilder(column: $table.branchId, builder: (column) => column);

  GeneratedColumn<int> get countedCash => $composableBuilder(
    column: $table.countedCash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get varianceReason => $composableBuilder(
    column: $table.varianceReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get witness =>
      $composableBuilder(column: $table.witness, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get countedAt =>
      $composableBuilder(column: $table.countedAt, builder: (column) => column);
}

class $$LocalCashCollectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalCashCollectionsTable,
          LocalCashCollection,
          $$LocalCashCollectionsTableFilterComposer,
          $$LocalCashCollectionsTableOrderingComposer,
          $$LocalCashCollectionsTableAnnotationComposer,
          $$LocalCashCollectionsTableCreateCompanionBuilder,
          $$LocalCashCollectionsTableUpdateCompanionBuilder,
          (
            LocalCashCollection,
            BaseReferences<
              _$AppDatabase,
              $LocalCashCollectionsTable,
              LocalCashCollection
            >,
          ),
          LocalCashCollection,
          PrefetchHooks Function()
        > {
  $$LocalCashCollectionsTableTableManager(
    _$AppDatabase db,
    $LocalCashCollectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalCashCollectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalCashCollectionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalCashCollectionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> branchId = const Value.absent(),
                Value<int> countedCash = const Value.absent(),
                Value<String?> varianceReason = const Value.absent(),
                Value<String?> witness = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> countedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalCashCollectionsCompanion(
                id: id,
                branchId: branchId,
                countedCash: countedCash,
                varianceReason: varianceReason,
                witness: witness,
                notes: notes,
                countedAt: countedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String branchId,
                required int countedCash,
                Value<String?> varianceReason = const Value.absent(),
                Value<String?> witness = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime countedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalCashCollectionsCompanion.insert(
                id: id,
                branchId: branchId,
                countedCash: countedCash,
                varianceReason: varianceReason,
                witness: witness,
                notes: notes,
                countedAt: countedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalCashCollectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalCashCollectionsTable,
      LocalCashCollection,
      $$LocalCashCollectionsTableFilterComposer,
      $$LocalCashCollectionsTableOrderingComposer,
      $$LocalCashCollectionsTableAnnotationComposer,
      $$LocalCashCollectionsTableCreateCompanionBuilder,
      $$LocalCashCollectionsTableUpdateCompanionBuilder,
      (
        LocalCashCollection,
        BaseReferences<
          _$AppDatabase,
          $LocalCashCollectionsTable,
          LocalCashCollection
        >,
      ),
      LocalCashCollection,
      PrefetchHooks Function()
    >;
typedef $$LocalPendingUsersTableCreateCompanionBuilder =
    LocalPendingUsersCompanion Function({
      required String id,
      required String branchId,
      required String fullName,
      required String username,
      required String password,
      required String role,
      Value<String?> pin,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$LocalPendingUsersTableUpdateCompanionBuilder =
    LocalPendingUsersCompanion Function({
      Value<String> id,
      Value<String> branchId,
      Value<String> fullName,
      Value<String> username,
      Value<String> password,
      Value<String> role,
      Value<String?> pin,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$LocalPendingUsersTableFilterComposer
    extends Composer<_$AppDatabase, $LocalPendingUsersTable> {
  $$LocalPendingUsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pin => $composableBuilder(
    column: $table.pin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalPendingUsersTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalPendingUsersTable> {
  $$LocalPendingUsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pin => $composableBuilder(
    column: $table.pin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalPendingUsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalPendingUsersTable> {
  $$LocalPendingUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get branchId =>
      $composableBuilder(column: $table.branchId, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get pin =>
      $composableBuilder(column: $table.pin, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocalPendingUsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalPendingUsersTable,
          LocalPendingUser,
          $$LocalPendingUsersTableFilterComposer,
          $$LocalPendingUsersTableOrderingComposer,
          $$LocalPendingUsersTableAnnotationComposer,
          $$LocalPendingUsersTableCreateCompanionBuilder,
          $$LocalPendingUsersTableUpdateCompanionBuilder,
          (
            LocalPendingUser,
            BaseReferences<
              _$AppDatabase,
              $LocalPendingUsersTable,
              LocalPendingUser
            >,
          ),
          LocalPendingUser,
          PrefetchHooks Function()
        > {
  $$LocalPendingUsersTableTableManager(
    _$AppDatabase db,
    $LocalPendingUsersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPendingUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalPendingUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalPendingUsersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> branchId = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> password = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String?> pin = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPendingUsersCompanion(
                id: id,
                branchId: branchId,
                fullName: fullName,
                username: username,
                password: password,
                role: role,
                pin: pin,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String branchId,
                required String fullName,
                required String username,
                required String password,
                required String role,
                Value<String?> pin = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalPendingUsersCompanion.insert(
                id: id,
                branchId: branchId,
                fullName: fullName,
                username: username,
                password: password,
                role: role,
                pin: pin,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalPendingUsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalPendingUsersTable,
      LocalPendingUser,
      $$LocalPendingUsersTableFilterComposer,
      $$LocalPendingUsersTableOrderingComposer,
      $$LocalPendingUsersTableAnnotationComposer,
      $$LocalPendingUsersTableCreateCompanionBuilder,
      $$LocalPendingUsersTableUpdateCompanionBuilder,
      (
        LocalPendingUser,
        BaseReferences<
          _$AppDatabase,
          $LocalPendingUsersTable,
          LocalPendingUser
        >,
      ),
      LocalPendingUser,
      PrefetchHooks Function()
    >;
typedef $$LocalUsersTableCreateCompanionBuilder = LocalUsersCompanion Function({
  required String id,
  required String fullName,
  required String username,
  required String passwordHash,
  Value<String?> pinHash,
  required String role,
  Value<bool> active,
  Value<DateTime?> lastLoginAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$LocalUsersTableUpdateCompanionBuilder = LocalUsersCompanion Function({
  Value<String> id,
  Value<String> fullName,
  Value<String> username,
  Value<String> passwordHash,
  Value<String?> pinHash,
  Value<String> role,
  Value<bool> active,
  Value<DateTime?> lastLoginAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$LocalUsersTableFilterComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalUsersTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalUsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocalUsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalUsersTable,
          LocalUser,
          $$LocalUsersTableFilterComposer,
          $$LocalUsersTableOrderingComposer,
          $$LocalUsersTableAnnotationComposer,
          $$LocalUsersTableCreateCompanionBuilder,
          $$LocalUsersTableUpdateCompanionBuilder,
          (
            LocalUser,
            BaseReferences<_$AppDatabase, $LocalUsersTable, LocalUser>,
          ),
          LocalUser,
          PrefetchHooks Function()
        > {
  $$LocalUsersTableTableManager(_$AppDatabase db, $LocalUsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> passwordHash = const Value.absent(),
                Value<String?> pinHash = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime?> lastLoginAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUsersCompanion(
                id: id,
                fullName: fullName,
                username: username,
                passwordHash: passwordHash,
                pinHash: pinHash,
                role: role,
                active: active,
                lastLoginAt: lastLoginAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fullName,
                required String username,
                required String passwordHash,
                Value<String?> pinHash = const Value.absent(),
                required String role,
                Value<bool> active = const Value.absent(),
                Value<DateTime?> lastLoginAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUsersCompanion.insert(
                id: id,
                fullName: fullName,
                username: username,
                passwordHash: passwordHash,
                pinHash: pinHash,
                role: role,
                active: active,
                lastLoginAt: lastLoginAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalUsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalUsersTable,
      LocalUser,
      $$LocalUsersTableFilterComposer,
      $$LocalUsersTableOrderingComposer,
      $$LocalUsersTableAnnotationComposer,
      $$LocalUsersTableCreateCompanionBuilder,
      $$LocalUsersTableUpdateCompanionBuilder,
      (LocalUser, BaseReferences<_$AppDatabase, $LocalUsersTable, LocalUser>),
      LocalUser,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalWashServicesTableTableManager get localWashServices =>
      $$LocalWashServicesTableTableManager(_db, _db.localWashServices);
  $$LocalWashExtrasTableTableManager get localWashExtras =>
      $$LocalWashExtrasTableTableManager(_db, _db.localWashExtras);
  $$LocalCustomersTableTableManager get localCustomers =>
      $$LocalCustomersTableTableManager(_db, _db.localCustomers);
  $$LocalVehiclesTableTableManager get localVehicles =>
      $$LocalVehiclesTableTableManager(_db, _db.localVehicles);
  $$LocalLoyaltySummariesTableTableManager get localLoyaltySummaries =>
      $$LocalLoyaltySummariesTableTableManager(_db, _db.localLoyaltySummaries);
  $$LocalLoyaltyLedgerTableTableManager get localLoyaltyLedger =>
      $$LocalLoyaltyLedgerTableTableManager(_db, _db.localLoyaltyLedger);
  $$LocalLoyaltyRewardsTableTableManager get localLoyaltyRewards =>
      $$LocalLoyaltyRewardsTableTableManager(_db, _db.localLoyaltyRewards);
  $$LocalWashOrdersTableTableManager get localWashOrders =>
      $$LocalWashOrdersTableTableManager(_db, _db.localWashOrders);
  $$LocalWashOrderItemsTableTableManager get localWashOrderItems =>
      $$LocalWashOrderItemsTableTableManager(_db, _db.localWashOrderItems);
  $$LocalPaymentsTableTableManager get localPayments =>
      $$LocalPaymentsTableTableManager(_db, _db.localPayments);
  $$LocalPaymentComponentsTableTableManager get localPaymentComponents =>
      $$LocalPaymentComponentsTableTableManager(
        _db,
        _db.localPaymentComponents,
      );
  $$PendingSyncOpsTableTableManager get pendingSyncOps =>
      $$PendingSyncOpsTableTableManager(_db, _db.pendingSyncOps);
  $$SyncMetaTableTableManager get syncMeta =>
      $$SyncMetaTableTableManager(_db, _db.syncMeta);
  $$LocalExpenseCategoriesTableTableManager get localExpenseCategories =>
      $$LocalExpenseCategoriesTableTableManager(
        _db,
        _db.localExpenseCategories,
      );
  $$LocalExpensesTableTableManager get localExpenses =>
      $$LocalExpensesTableTableManager(_db, _db.localExpenses);
  $$LocalPrepaidPackagesTableTableManager get localPrepaidPackages =>
      $$LocalPrepaidPackagesTableTableManager(_db, _db.localPrepaidPackages);
  $$LocalPrepaidWalletsTableTableManager get localPrepaidWallets =>
      $$LocalPrepaidWalletsTableTableManager(_db, _db.localPrepaidWallets);
  $$LocalPrepaidWalletLedgerTableTableManager get localPrepaidWalletLedger =>
      $$LocalPrepaidWalletLedgerTableTableManager(
        _db,
        _db.localPrepaidWalletLedger,
      );
  $$LocalPrepaidPackagePurchasesTableTableManager
  get localPrepaidPackagePurchases =>
      $$LocalPrepaidPackagePurchasesTableTableManager(
        _db,
        _db.localPrepaidPackagePurchases,
      );
  $$LocalPrepaidPackageUsageTableTableManager get localPrepaidPackageUsage =>
      $$LocalPrepaidPackageUsageTableTableManager(
        _db,
        _db.localPrepaidPackageUsage,
      );
  $$LocalCashCollectionsTableTableManager get localCashCollections =>
      $$LocalCashCollectionsTableTableManager(_db, _db.localCashCollections);
  $$LocalPendingUsersTableTableManager get localPendingUsers =>
      $$LocalPendingUsersTableTableManager(_db, _db.localPendingUsers);
  $$LocalUsersTableTableManager get localUsers =>
      $$LocalUsersTableTableManager(_db, _db.localUsers);
}
