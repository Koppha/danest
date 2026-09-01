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
  late final GeneratedColumn<double> basePrice = GeneratedColumn<double>(
    'base_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
        DriftSqlType.double,
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
  final double basePrice;
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
    map['base_price'] = Variable<double>(basePrice);
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
      basePrice: serializer.fromJson<double>(json['basePrice']),
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
      'basePrice': serializer.toJson<double>(basePrice),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
    };
  }

  LocalWashService copyWith({
    String? id,
    String? name,
    String? tier,
    double? basePrice,
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
  final Value<double> basePrice;
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
    required double basePrice,
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
    Expression<double>? basePrice,
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
    Value<double>? basePrice,
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
      map['base_price'] = Variable<double>(basePrice.value);
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
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
        DriftSqlType.double,
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
  final double price;
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
    map['price'] = Variable<double>(price);
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
      price: serializer.fromJson<double>(json['price']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'price': serializer.toJson<double>(price),
    };
  }

  LocalWashExtra copyWith({String? id, String? name, double? price}) =>
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
  final Value<double> price;
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
    required double price,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       price = Value(price);
  static Insertable<LocalWashExtra> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? price,
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
    Value<double>? price,
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
      map['price'] = Variable<double>(price.value);
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
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
        DriftSqlType.double,
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
  final double totalAmount;
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
    map['total_amount'] = Variable<double>(totalAmount);
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
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
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
      'totalAmount': serializer.toJson<double>(totalAmount),
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
    double? totalAmount,
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
  final Value<double> totalAmount;
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
    required double totalAmount,
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
    Expression<double>? totalAmount,
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
    Value<double>? totalAmount,
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
      map['total_amount'] = Variable<double>(totalAmount.value);
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
  late final GeneratedColumn<double> priceSnapshot = GeneratedColumn<double>(
    'price_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
        DriftSqlType.double,
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
  final double priceSnapshot;
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
    map['price_snapshot'] = Variable<double>(priceSnapshot);
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
      priceSnapshot: serializer.fromJson<double>(json['priceSnapshot']),
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
      'priceSnapshot': serializer.toJson<double>(priceSnapshot),
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
    double? priceSnapshot,
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
  final Value<double> priceSnapshot;
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
    required double priceSnapshot,
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
    Expression<double>? priceSnapshot,
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
    Value<double>? priceSnapshot,
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
      map['price_snapshot'] = Variable<double>(priceSnapshot.value);
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
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
        DriftSqlType.double,
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
  final double totalAmount;
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
    map['total_amount'] = Variable<double>(totalAmount);
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
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'washOrderId': serializer.toJson<String>(washOrderId),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  LocalPayment copyWith({
    String? id,
    String? washOrderId,
    double? totalAmount,
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
  final Value<double> totalAmount;
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
    required double totalAmount,
    required DateTime completedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       washOrderId = Value(washOrderId),
       totalAmount = Value(totalAmount),
       completedAt = Value(completedAt);
  static Insertable<LocalPayment> custom({
    Expression<String>? id,
    Expression<String>? washOrderId,
    Expression<double>? totalAmount,
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
    Value<double>? totalAmount,
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
      map['total_amount'] = Variable<double>(totalAmount.value);
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
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
        DriftSqlType.double,
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
  final double amount;
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
    map['amount'] = Variable<double>(amount);
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
      amount: serializer.fromJson<double>(json['amount']),
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
      'amount': serializer.toJson<double>(amount),
      'externalReference': serializer.toJson<String?>(externalReference),
    };
  }

  LocalPaymentComponent copyWith({
    String? id,
    String? paymentId,
    String? method,
    double? amount,
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
  final Value<double> amount;
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
    required double amount,
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
    Expression<double>? amount,
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
    Value<double>? amount,
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
      map['amount'] = Variable<double>(amount.value);
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
    localWashOrders,
    localWashOrderItems,
    localPayments,
    localPaymentComponents,
    pendingSyncOps,
    syncMeta,
  ];
}

typedef $$LocalWashServicesTableCreateCompanionBuilder =
    LocalWashServicesCompanion Function({
      required String id,
      required String name,
      required String tier,
      required double basePrice,
      required int durationMinutes,
      Value<int> rowid,
    });
typedef $$LocalWashServicesTableUpdateCompanionBuilder =
    LocalWashServicesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> tier,
      Value<double> basePrice,
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

  ColumnFilters<double> get basePrice => $composableBuilder(
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

  ColumnOrderings<double> get basePrice => $composableBuilder(
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

  GeneratedColumn<double> get basePrice =>
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
                Value<double> basePrice = const Value.absent(),
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
                required double basePrice,
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
      required double price,
      Value<int> rowid,
    });
typedef $$LocalWashExtrasTableUpdateCompanionBuilder =
    LocalWashExtrasCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<double> price,
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

  ColumnFilters<double> get price => $composableBuilder(
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

  ColumnOrderings<double> get price => $composableBuilder(
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

  GeneratedColumn<double> get price =>
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
                Value<double> price = const Value.absent(),
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
                required double price,
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
typedef $$LocalWashOrdersTableCreateCompanionBuilder =
    LocalWashOrdersCompanion Function({
      required String id,
      required String branchId,
      required String vehicleId,
      required String customerId,
      required String status,
      required double totalAmount,
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
      Value<double> totalAmount,
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

  ColumnFilters<double> get totalAmount => $composableBuilder(
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

  ColumnOrderings<double> get totalAmount => $composableBuilder(
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

  GeneratedColumn<double> get totalAmount => $composableBuilder(
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
                Value<double> totalAmount = const Value.absent(),
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
                required double totalAmount,
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
      required double priceSnapshot,
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
      Value<double> priceSnapshot,
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

  ColumnFilters<double> get priceSnapshot => $composableBuilder(
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

  ColumnOrderings<double> get priceSnapshot => $composableBuilder(
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

  GeneratedColumn<double> get priceSnapshot => $composableBuilder(
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
                Value<double> priceSnapshot = const Value.absent(),
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
                required double priceSnapshot,
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
      required double totalAmount,
      required DateTime completedAt,
      Value<int> rowid,
    });
typedef $$LocalPaymentsTableUpdateCompanionBuilder =
    LocalPaymentsCompanion Function({
      Value<String> id,
      Value<String> washOrderId,
      Value<double> totalAmount,
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

  ColumnFilters<double> get totalAmount => $composableBuilder(
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

  ColumnOrderings<double> get totalAmount => $composableBuilder(
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

  GeneratedColumn<double> get totalAmount => $composableBuilder(
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
                Value<double> totalAmount = const Value.absent(),
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
                required double totalAmount,
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
      required double amount,
      Value<String?> externalReference,
      Value<int> rowid,
    });
typedef $$LocalPaymentComponentsTableUpdateCompanionBuilder =
    LocalPaymentComponentsCompanion Function({
      Value<String> id,
      Value<String> paymentId,
      Value<String> method,
      Value<double> amount,
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

  ColumnFilters<double> get amount => $composableBuilder(
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

  ColumnOrderings<double> get amount => $composableBuilder(
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

  GeneratedColumn<double> get amount =>
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
                Value<double> amount = const Value.absent(),
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
                required double amount,
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
}
