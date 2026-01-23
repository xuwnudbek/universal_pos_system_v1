// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UnitsTable extends Units with TableInfo<$UnitsTable, Unit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _shortNameMeta = const VerificationMeta(
    'shortName',
  );
  @override
  late final GeneratedColumn<String> shortName = GeneratedColumn<String>(
    'short_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    defaultValue: currentDate,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    shortName,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'units';
  @override
  VerificationContext validateIntegrity(
    Insertable<Unit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('short_name')) {
      context.handle(
        _shortNameMeta,
        shortName.isAcceptableOrUnknown(data['short_name']!, _shortNameMeta),
      );
    } else if (isInserting) {
      context.missing(_shortNameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
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
  Unit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Unit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      shortName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}short_name'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UnitsTable createAlias(String alias) {
    return $UnitsTable(attachedDatabase, alias);
  }
}

class Unit extends DataClass implements Insertable<Unit> {
  final int id;
  final String name;
  final String shortName;
  final bool isActive;
  final DateTime createdAt;
  const Unit({
    required this.id,
    required this.name,
    required this.shortName,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['short_name'] = Variable<String>(shortName);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UnitsCompanion toCompanion(bool nullToAbsent) {
    return UnitsCompanion(
      id: Value(id),
      name: Value(name),
      shortName: Value(shortName),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory Unit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Unit(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      shortName: serializer.fromJson<String>(json['shortName']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'shortName': serializer.toJson<String>(shortName),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Unit copyWith({
    int? id,
    String? name,
    String? shortName,
    bool? isActive,
    DateTime? createdAt,
  }) => Unit(
    id: id ?? this.id,
    name: name ?? this.name,
    shortName: shortName ?? this.shortName,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  Unit copyWithCompanion(UnitsCompanion data) {
    return Unit(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      shortName: data.shortName.present ? data.shortName.value : this.shortName,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Unit(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('shortName: $shortName, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, shortName, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Unit &&
          other.id == this.id &&
          other.name == this.name &&
          other.shortName == this.shortName &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class UnitsCompanion extends UpdateCompanion<Unit> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> shortName;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const UnitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.shortName = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UnitsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String shortName,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       shortName = Value(shortName);
  static Insertable<Unit> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? shortName,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (shortName != null) 'short_name': shortName,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UnitsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? shortName,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return UnitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (shortName.present) {
      map['short_name'] = Variable<String>(shortName.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('shortName: $shortName, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ItemsTable extends Items with TableInfo<$ItemsTable, Item> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
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
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<int> unitId = GeneratedColumn<int>(
    'unit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES units (id)',
    ),
  );
  static const VerificationMeta _stockMeta = const VerificationMeta('stock');
  @override
  late final GeneratedColumn<double> stock = GeneratedColumn<double>(
    'stock',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
    name,
    barcode,
    price,
    unitId,
    stock,
    isActive,
    categoryId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(
    Insertable<Item> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    } else if (isInserting) {
      context.missing(_barcodeMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('stock')) {
      context.handle(
        _stockMeta,
        stock.isAcceptableOrUnknown(data['stock']!, _stockMeta),
      );
    } else if (isInserting) {
      context.missing(_stockMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
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
  Item map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Item(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_id'],
      )!,
      stock: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stock'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }
}

class Item extends DataClass implements Insertable<Item> {
  final int id;
  final String name;
  final String barcode;
  final double price;
  final int unitId;
  final double stock;
  final bool isActive;
  final int? categoryId;
  final DateTime createdAt;
  const Item({
    required this.id,
    required this.name,
    required this.barcode,
    required this.price,
    required this.unitId,
    required this.stock,
    required this.isActive,
    this.categoryId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['barcode'] = Variable<String>(barcode);
    map['price'] = Variable<double>(price);
    map['unit_id'] = Variable<int>(unitId);
    map['stock'] = Variable<double>(stock);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: Value(id),
      name: Value(name),
      barcode: Value(barcode),
      price: Value(price),
      unitId: Value(unitId),
      stock: Value(stock),
      isActive: Value(isActive),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      createdAt: Value(createdAt),
    );
  }

  factory Item.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Item(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      barcode: serializer.fromJson<String>(json['barcode']),
      price: serializer.fromJson<double>(json['price']),
      unitId: serializer.fromJson<int>(json['unitId']),
      stock: serializer.fromJson<double>(json['stock']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'barcode': serializer.toJson<String>(barcode),
      'price': serializer.toJson<double>(price),
      'unitId': serializer.toJson<int>(unitId),
      'stock': serializer.toJson<double>(stock),
      'isActive': serializer.toJson<bool>(isActive),
      'categoryId': serializer.toJson<int?>(categoryId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Item copyWith({
    int? id,
    String? name,
    String? barcode,
    double? price,
    int? unitId,
    double? stock,
    bool? isActive,
    Value<int?> categoryId = const Value.absent(),
    DateTime? createdAt,
  }) => Item(
    id: id ?? this.id,
    name: name ?? this.name,
    barcode: barcode ?? this.barcode,
    price: price ?? this.price,
    unitId: unitId ?? this.unitId,
    stock: stock ?? this.stock,
    isActive: isActive ?? this.isActive,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    createdAt: createdAt ?? this.createdAt,
  );
  Item copyWithCompanion(ItemsCompanion data) {
    return Item(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      price: data.price.present ? data.price.value : this.price,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      stock: data.stock.present ? data.stock.value : this.stock,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Item(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('price: $price, ')
          ..write('unitId: $unitId, ')
          ..write('stock: $stock, ')
          ..write('isActive: $isActive, ')
          ..write('categoryId: $categoryId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    barcode,
    price,
    unitId,
    stock,
    isActive,
    categoryId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Item &&
          other.id == this.id &&
          other.name == this.name &&
          other.barcode == this.barcode &&
          other.price == this.price &&
          other.unitId == this.unitId &&
          other.stock == this.stock &&
          other.isActive == this.isActive &&
          other.categoryId == this.categoryId &&
          other.createdAt == this.createdAt);
}

class ItemsCompanion extends UpdateCompanion<Item> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> barcode;
  final Value<double> price;
  final Value<int> unitId;
  final Value<double> stock;
  final Value<bool> isActive;
  final Value<int?> categoryId;
  final Value<DateTime> createdAt;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.barcode = const Value.absent(),
    this.price = const Value.absent(),
    this.unitId = const Value.absent(),
    this.stock = const Value.absent(),
    this.isActive = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ItemsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String barcode,
    required double price,
    required int unitId,
    required double stock,
    this.isActive = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       barcode = Value(barcode),
       price = Value(price),
       unitId = Value(unitId),
       stock = Value(stock);
  static Insertable<Item> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? barcode,
    Expression<double>? price,
    Expression<int>? unitId,
    Expression<double>? stock,
    Expression<bool>? isActive,
    Expression<int>? categoryId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (barcode != null) 'barcode': barcode,
      if (price != null) 'price': price,
      if (unitId != null) 'unit_id': unitId,
      if (stock != null) 'stock': stock,
      if (isActive != null) 'is_active': isActive,
      if (categoryId != null) 'category_id': categoryId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? barcode,
    Value<double>? price,
    Value<int>? unitId,
    Value<double>? stock,
    Value<bool>? isActive,
    Value<int?>? categoryId,
    Value<DateTime>? createdAt,
  }) {
    return ItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      price: price ?? this.price,
      unitId: unitId ?? this.unitId,
      stock: stock ?? this.stock,
      isActive: isActive ?? this.isActive,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<int>(unitId.value);
    }
    if (stock.present) {
      map['stock'] = Variable<double>(stock.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('price: $price, ')
          ..write('unitId: $unitId, ')
          ..write('stock: $stock, ')
          ..write('isActive: $isActive, ')
          ..write('categoryId: $categoryId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CategoryColorsTable extends CategoryColors
    with TableInfo<$CategoryColorsTable, CategoryColor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryColorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _hexMeta = const VerificationMeta('hex');
  @override
  late final GeneratedColumn<String> hex = GeneratedColumn<String>(
    'hex',
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
    requiredDuringInsert: false,
    defaultValue: currentDate,
  );
  @override
  List<GeneratedColumn> get $columns => [id, hex, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_colors';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryColor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('hex')) {
      context.handle(
        _hexMeta,
        hex.isAcceptableOrUnknown(data['hex']!, _hexMeta),
      );
    } else if (isInserting) {
      context.missing(_hexMeta);
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
  CategoryColor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryColor(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      hex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hex'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CategoryColorsTable createAlias(String alias) {
    return $CategoryColorsTable(attachedDatabase, alias);
  }
}

class CategoryColor extends DataClass implements Insertable<CategoryColor> {
  final int id;
  final String hex;
  final DateTime createdAt;
  const CategoryColor({
    required this.id,
    required this.hex,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['hex'] = Variable<String>(hex);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CategoryColorsCompanion toCompanion(bool nullToAbsent) {
    return CategoryColorsCompanion(
      id: Value(id),
      hex: Value(hex),
      createdAt: Value(createdAt),
    );
  }

  factory CategoryColor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryColor(
      id: serializer.fromJson<int>(json['id']),
      hex: serializer.fromJson<String>(json['hex']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'hex': serializer.toJson<String>(hex),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CategoryColor copyWith({int? id, String? hex, DateTime? createdAt}) =>
      CategoryColor(
        id: id ?? this.id,
        hex: hex ?? this.hex,
        createdAt: createdAt ?? this.createdAt,
      );
  CategoryColor copyWithCompanion(CategoryColorsCompanion data) {
    return CategoryColor(
      id: data.id.present ? data.id.value : this.id,
      hex: data.hex.present ? data.hex.value : this.hex,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryColor(')
          ..write('id: $id, ')
          ..write('hex: $hex, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, hex, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryColor &&
          other.id == this.id &&
          other.hex == this.hex &&
          other.createdAt == this.createdAt);
}

class CategoryColorsCompanion extends UpdateCompanion<CategoryColor> {
  final Value<int> id;
  final Value<String> hex;
  final Value<DateTime> createdAt;
  const CategoryColorsCompanion({
    this.id = const Value.absent(),
    this.hex = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CategoryColorsCompanion.insert({
    this.id = const Value.absent(),
    required String hex,
    this.createdAt = const Value.absent(),
  }) : hex = Value(hex);
  static Insertable<CategoryColor> custom({
    Expression<int>? id,
    Expression<String>? hex,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hex != null) 'hex': hex,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CategoryColorsCompanion copyWith({
    Value<int>? id,
    Value<String>? hex,
    Value<DateTime>? createdAt,
  }) {
    return CategoryColorsCompanion(
      id: id ?? this.id,
      hex: hex ?? this.hex,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (hex.present) {
      map['hex'] = Variable<String>(hex.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryColorsCompanion(')
          ..write('id: $id, ')
          ..write('hex: $hex, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ItemCategoriesTable extends ItemCategories
    with TableInfo<$ItemCategoriesTable, ItemCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _colorIdMeta = const VerificationMeta(
    'colorId',
  );
  @override
  late final GeneratedColumn<int> colorId = GeneratedColumn<int>(
    'color_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES category_colors (id)',
    ),
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
  List<GeneratedColumn> get $columns => [id, name, colorId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_id')) {
      context.handle(
        _colorIdMeta,
        colorId.isAcceptableOrUnknown(data['color_id']!, _colorIdMeta),
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
  ItemCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ItemCategoriesTable createAlias(String alias) {
    return $ItemCategoriesTable(attachedDatabase, alias);
  }
}

class ItemCategory extends DataClass implements Insertable<ItemCategory> {
  final int id;
  final String name;
  final int? colorId;
  final DateTime createdAt;
  const ItemCategory({
    required this.id,
    required this.name,
    this.colorId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || colorId != null) {
      map['color_id'] = Variable<int>(colorId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ItemCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ItemCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      colorId: colorId == null && nullToAbsent
          ? const Value.absent()
          : Value(colorId),
      createdAt: Value(createdAt),
    );
  }

  factory ItemCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemCategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorId: serializer.fromJson<int?>(json['colorId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'colorId': serializer.toJson<int?>(colorId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ItemCategory copyWith({
    int? id,
    String? name,
    Value<int?> colorId = const Value.absent(),
    DateTime? createdAt,
  }) => ItemCategory(
    id: id ?? this.id,
    name: name ?? this.name,
    colorId: colorId.present ? colorId.value : this.colorId,
    createdAt: createdAt ?? this.createdAt,
  );
  ItemCategory copyWithCompanion(ItemCategoriesCompanion data) {
    return ItemCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorId: data.colorId.present ? data.colorId.value : this.colorId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorId: $colorId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, colorId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorId == this.colorId &&
          other.createdAt == this.createdAt);
}

class ItemCategoriesCompanion extends UpdateCompanion<ItemCategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> colorId;
  final Value<DateTime> createdAt;
  const ItemCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ItemCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.colorId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ItemCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? colorId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorId != null) 'color_id': colorId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ItemCategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int?>? colorId,
    Value<DateTime>? createdAt,
  }) {
    return ItemCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorId: colorId ?? this.colorId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorId.present) {
      map['color_id'] = Variable<int>(colorId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorId: $colorId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CartsTable extends Carts with TableInfo<$CartsTable, Cart> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CartsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
    defaultValue: currentDate,
  );
  @override
  List<GeneratedColumn> get $columns => [id, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'carts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cart> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
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
  Cart map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cart(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CartsTable createAlias(String alias) {
    return $CartsTable(attachedDatabase, alias);
  }
}

class Cart extends DataClass implements Insertable<Cart> {
  final int id;
  final DateTime createdAt;
  const Cart({required this.id, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CartsCompanion toCompanion(bool nullToAbsent) {
    return CartsCompanion(id: Value(id), createdAt: Value(createdAt));
  }

  factory Cart.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cart(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Cart copyWith({int? id, DateTime? createdAt}) =>
      Cart(id: id ?? this.id, createdAt: createdAt ?? this.createdAt);
  Cart copyWithCompanion(CartsCompanion data) {
    return Cart(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cart(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cart &&
          other.id == this.id &&
          other.createdAt == this.createdAt);
}

class CartsCompanion extends UpdateCompanion<Cart> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  const CartsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CartsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  static Insertable<Cart> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CartsCompanion copyWith({Value<int>? id, Value<DateTime>? createdAt}) {
    return CartsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CartsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CartItemsTable extends CartItems
    with TableInfo<$CartItemsTable, CartItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CartItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cartIdMeta = const VerificationMeta('cartId');
  @override
  late final GeneratedColumn<int> cartId = GeneratedColumn<int>(
    'cart_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES carts (id)',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [id, cartId, itemId, quantity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cart_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CartItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cart_id')) {
      context.handle(
        _cartIdMeta,
        cartId.isAcceptableOrUnknown(data['cart_id']!, _cartIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cartIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CartItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CartItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cartId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cart_id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
    );
  }

  @override
  $CartItemsTable createAlias(String alias) {
    return $CartItemsTable(attachedDatabase, alias);
  }
}

class CartItem extends DataClass implements Insertable<CartItem> {
  final int id;
  final int cartId;
  final int itemId;
  final int quantity;
  const CartItem({
    required this.id,
    required this.cartId,
    required this.itemId,
    required this.quantity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cart_id'] = Variable<int>(cartId);
    map['item_id'] = Variable<int>(itemId);
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  CartItemsCompanion toCompanion(bool nullToAbsent) {
    return CartItemsCompanion(
      id: Value(id),
      cartId: Value(cartId),
      itemId: Value(itemId),
      quantity: Value(quantity),
    );
  }

  factory CartItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CartItem(
      id: serializer.fromJson<int>(json['id']),
      cartId: serializer.fromJson<int>(json['cartId']),
      itemId: serializer.fromJson<int>(json['itemId']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cartId': serializer.toJson<int>(cartId),
      'itemId': serializer.toJson<int>(itemId),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  CartItem copyWith({int? id, int? cartId, int? itemId, int? quantity}) =>
      CartItem(
        id: id ?? this.id,
        cartId: cartId ?? this.cartId,
        itemId: itemId ?? this.itemId,
        quantity: quantity ?? this.quantity,
      );
  CartItem copyWithCompanion(CartItemsCompanion data) {
    return CartItem(
      id: data.id.present ? data.id.value : this.id,
      cartId: data.cartId.present ? data.cartId.value : this.cartId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CartItem(')
          ..write('id: $id, ')
          ..write('cartId: $cartId, ')
          ..write('itemId: $itemId, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cartId, itemId, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartItem &&
          other.id == this.id &&
          other.cartId == this.cartId &&
          other.itemId == this.itemId &&
          other.quantity == this.quantity);
}

class CartItemsCompanion extends UpdateCompanion<CartItem> {
  final Value<int> id;
  final Value<int> cartId;
  final Value<int> itemId;
  final Value<int> quantity;
  const CartItemsCompanion({
    this.id = const Value.absent(),
    this.cartId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  CartItemsCompanion.insert({
    this.id = const Value.absent(),
    required int cartId,
    required int itemId,
    this.quantity = const Value.absent(),
  }) : cartId = Value(cartId),
       itemId = Value(itemId);
  static Insertable<CartItem> custom({
    Expression<int>? id,
    Expression<int>? cartId,
    Expression<int>? itemId,
    Expression<int>? quantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cartId != null) 'cart_id': cartId,
      if (itemId != null) 'item_id': itemId,
      if (quantity != null) 'quantity': quantity,
    });
  }

  CartItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? cartId,
    Value<int>? itemId,
    Value<int>? quantity,
  }) {
    return CartItemsCompanion(
      id: id ?? this.id,
      cartId: cartId ?? this.cartId,
      itemId: itemId ?? this.itemId,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cartId.present) {
      map['cart_id'] = Variable<int>(cartId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CartItemsCompanion(')
          ..write('id: $id, ')
          ..write('cartId: $cartId, ')
          ..write('itemId: $itemId, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }
}

class $SaleHistoriesTable extends SaleHistories
    with TableInfo<$SaleHistoriesTable, SaleHistory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleHistoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cartIdMeta = const VerificationMeta('cartId');
  @override
  late final GeneratedColumn<int> cartId = GeneratedColumn<int>(
    'cart_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES carts (id)',
    ),
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    true,
    type: DriftSqlType.double,
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
    defaultValue: currentDate,
  );
  @override
  List<GeneratedColumn> get $columns => [id, cartId, total, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_histories';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleHistory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cart_id')) {
      context.handle(
        _cartIdMeta,
        cartId.isAcceptableOrUnknown(data['cart_id']!, _cartIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cartIdMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
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
  SaleHistory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleHistory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cartId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cart_id'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SaleHistoriesTable createAlias(String alias) {
    return $SaleHistoriesTable(attachedDatabase, alias);
  }
}

class SaleHistory extends DataClass implements Insertable<SaleHistory> {
  final int id;
  final int cartId;
  final double? total;
  final DateTime createdAt;
  const SaleHistory({
    required this.id,
    required this.cartId,
    this.total,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cart_id'] = Variable<int>(cartId);
    if (!nullToAbsent || total != null) {
      map['total'] = Variable<double>(total);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SaleHistoriesCompanion toCompanion(bool nullToAbsent) {
    return SaleHistoriesCompanion(
      id: Value(id),
      cartId: Value(cartId),
      total: total == null && nullToAbsent
          ? const Value.absent()
          : Value(total),
      createdAt: Value(createdAt),
    );
  }

  factory SaleHistory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleHistory(
      id: serializer.fromJson<int>(json['id']),
      cartId: serializer.fromJson<int>(json['cartId']),
      total: serializer.fromJson<double?>(json['total']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cartId': serializer.toJson<int>(cartId),
      'total': serializer.toJson<double?>(total),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SaleHistory copyWith({
    int? id,
    int? cartId,
    Value<double?> total = const Value.absent(),
    DateTime? createdAt,
  }) => SaleHistory(
    id: id ?? this.id,
    cartId: cartId ?? this.cartId,
    total: total.present ? total.value : this.total,
    createdAt: createdAt ?? this.createdAt,
  );
  SaleHistory copyWithCompanion(SaleHistoriesCompanion data) {
    return SaleHistory(
      id: data.id.present ? data.id.value : this.id,
      cartId: data.cartId.present ? data.cartId.value : this.cartId,
      total: data.total.present ? data.total.value : this.total,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleHistory(')
          ..write('id: $id, ')
          ..write('cartId: $cartId, ')
          ..write('total: $total, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cartId, total, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleHistory &&
          other.id == this.id &&
          other.cartId == this.cartId &&
          other.total == this.total &&
          other.createdAt == this.createdAt);
}

class SaleHistoriesCompanion extends UpdateCompanion<SaleHistory> {
  final Value<int> id;
  final Value<int> cartId;
  final Value<double?> total;
  final Value<DateTime> createdAt;
  const SaleHistoriesCompanion({
    this.id = const Value.absent(),
    this.cartId = const Value.absent(),
    this.total = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SaleHistoriesCompanion.insert({
    this.id = const Value.absent(),
    required int cartId,
    this.total = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : cartId = Value(cartId);
  static Insertable<SaleHistory> custom({
    Expression<int>? id,
    Expression<int>? cartId,
    Expression<double>? total,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cartId != null) 'cart_id': cartId,
      if (total != null) 'total': total,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SaleHistoriesCompanion copyWith({
    Value<int>? id,
    Value<int>? cartId,
    Value<double?>? total,
    Value<DateTime>? createdAt,
  }) {
    return SaleHistoriesCompanion(
      id: id ?? this.id,
      cartId: cartId ?? this.cartId,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cartId.present) {
      map['cart_id'] = Variable<int>(cartId.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('cartId: $cartId, ')
          ..write('total: $total, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $StocksTable extends Stocks with TableInfo<$StocksTable, Stock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocationsEnum, String> location =
      GeneratedColumn<String>(
        'location',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LocationsEnum>($StocksTable.$converterlocation);
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, itemId, location, quantity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Stock> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Stock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Stock(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      )!,
      location: $StocksTable.$converterlocation.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}location'],
        )!,
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
    );
  }

  @override
  $StocksTable createAlias(String alias) {
    return $StocksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LocationsEnum, String, String> $converterlocation =
      const EnumNameConverter<LocationsEnum>(LocationsEnum.values);
}

class Stock extends DataClass implements Insertable<Stock> {
  final int id;
  final int itemId;
  final LocationsEnum location;
  final double quantity;
  const Stock({
    required this.id,
    required this.itemId,
    required this.location,
    required this.quantity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_id'] = Variable<int>(itemId);
    {
      map['location'] = Variable<String>(
        $StocksTable.$converterlocation.toSql(location),
      );
    }
    map['quantity'] = Variable<double>(quantity);
    return map;
  }

  StocksCompanion toCompanion(bool nullToAbsent) {
    return StocksCompanion(
      id: Value(id),
      itemId: Value(itemId),
      location: Value(location),
      quantity: Value(quantity),
    );
  }

  factory Stock.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Stock(
      id: serializer.fromJson<int>(json['id']),
      itemId: serializer.fromJson<int>(json['itemId']),
      location: $StocksTable.$converterlocation.fromJson(
        serializer.fromJson<String>(json['location']),
      ),
      quantity: serializer.fromJson<double>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemId': serializer.toJson<int>(itemId),
      'location': serializer.toJson<String>(
        $StocksTable.$converterlocation.toJson(location),
      ),
      'quantity': serializer.toJson<double>(quantity),
    };
  }

  Stock copyWith({
    int? id,
    int? itemId,
    LocationsEnum? location,
    double? quantity,
  }) => Stock(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    location: location ?? this.location,
    quantity: quantity ?? this.quantity,
  );
  Stock copyWithCompanion(StocksCompanion data) {
    return Stock(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      location: data.location.present ? data.location.value : this.location,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Stock(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('location: $location, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, itemId, location, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Stock &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.location == this.location &&
          other.quantity == this.quantity);
}

class StocksCompanion extends UpdateCompanion<Stock> {
  final Value<int> id;
  final Value<int> itemId;
  final Value<LocationsEnum> location;
  final Value<double> quantity;
  const StocksCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.location = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  StocksCompanion.insert({
    this.id = const Value.absent(),
    required int itemId,
    required LocationsEnum location,
    this.quantity = const Value.absent(),
  }) : itemId = Value(itemId),
       location = Value(location);
  static Insertable<Stock> custom({
    Expression<int>? id,
    Expression<int>? itemId,
    Expression<String>? location,
    Expression<double>? quantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (location != null) 'location': location,
      if (quantity != null) 'quantity': quantity,
    });
  }

  StocksCompanion copyWith({
    Value<int>? id,
    Value<int>? itemId,
    Value<LocationsEnum>? location,
    Value<double>? quantity,
  }) {
    return StocksCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      location: location ?? this.location,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(
        $StocksTable.$converterlocation.toSql(location.value),
      );
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StocksCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('location: $location, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }
}

class $TransfersTable extends Transfers
    with TableInfo<$TransfersTable, Transfer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransfersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocationsEnum, String>
  fromLocation = GeneratedColumn<String>(
    'from_location',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<LocationsEnum>($TransfersTable.$converterfromLocation);
  @override
  late final GeneratedColumnWithTypeConverter<LocationsEnum, String>
  toLocation = GeneratedColumn<String>(
    'to_location',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<LocationsEnum>($TransfersTable.$convertertoLocation);
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemId,
    fromLocation,
    toLocation,
    quantity,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transfers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transfer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
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
  Transfer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transfer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      )!,
      fromLocation: $TransfersTable.$converterfromLocation.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}from_location'],
        )!,
      ),
      toLocation: $TransfersTable.$convertertoLocation.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}to_location'],
        )!,
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TransfersTable createAlias(String alias) {
    return $TransfersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LocationsEnum, String, String>
  $converterfromLocation = const EnumNameConverter<LocationsEnum>(
    LocationsEnum.values,
  );
  static JsonTypeConverter2<LocationsEnum, String, String>
  $convertertoLocation = const EnumNameConverter<LocationsEnum>(
    LocationsEnum.values,
  );
}

class Transfer extends DataClass implements Insertable<Transfer> {
  final int id;
  final int itemId;
  final LocationsEnum fromLocation;
  final LocationsEnum toLocation;
  final double quantity;
  final String? note;
  final DateTime createdAt;
  const Transfer({
    required this.id,
    required this.itemId,
    required this.fromLocation,
    required this.toLocation,
    required this.quantity,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_id'] = Variable<int>(itemId);
    {
      map['from_location'] = Variable<String>(
        $TransfersTable.$converterfromLocation.toSql(fromLocation),
      );
    }
    {
      map['to_location'] = Variable<String>(
        $TransfersTable.$convertertoLocation.toSql(toLocation),
      );
    }
    map['quantity'] = Variable<double>(quantity);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransfersCompanion toCompanion(bool nullToAbsent) {
    return TransfersCompanion(
      id: Value(id),
      itemId: Value(itemId),
      fromLocation: Value(fromLocation),
      toLocation: Value(toLocation),
      quantity: Value(quantity),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory Transfer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transfer(
      id: serializer.fromJson<int>(json['id']),
      itemId: serializer.fromJson<int>(json['itemId']),
      fromLocation: $TransfersTable.$converterfromLocation.fromJson(
        serializer.fromJson<String>(json['fromLocation']),
      ),
      toLocation: $TransfersTable.$convertertoLocation.fromJson(
        serializer.fromJson<String>(json['toLocation']),
      ),
      quantity: serializer.fromJson<double>(json['quantity']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemId': serializer.toJson<int>(itemId),
      'fromLocation': serializer.toJson<String>(
        $TransfersTable.$converterfromLocation.toJson(fromLocation),
      ),
      'toLocation': serializer.toJson<String>(
        $TransfersTable.$convertertoLocation.toJson(toLocation),
      ),
      'quantity': serializer.toJson<double>(quantity),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Transfer copyWith({
    int? id,
    int? itemId,
    LocationsEnum? fromLocation,
    LocationsEnum? toLocation,
    double? quantity,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => Transfer(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    fromLocation: fromLocation ?? this.fromLocation,
    toLocation: toLocation ?? this.toLocation,
    quantity: quantity ?? this.quantity,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  Transfer copyWithCompanion(TransfersCompanion data) {
    return Transfer(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      fromLocation: data.fromLocation.present
          ? data.fromLocation.value
          : this.fromLocation,
      toLocation: data.toLocation.present
          ? data.toLocation.value
          : this.toLocation,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transfer(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('fromLocation: $fromLocation, ')
          ..write('toLocation: $toLocation, ')
          ..write('quantity: $quantity, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    itemId,
    fromLocation,
    toLocation,
    quantity,
    note,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transfer &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.fromLocation == this.fromLocation &&
          other.toLocation == this.toLocation &&
          other.quantity == this.quantity &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class TransfersCompanion extends UpdateCompanion<Transfer> {
  final Value<int> id;
  final Value<int> itemId;
  final Value<LocationsEnum> fromLocation;
  final Value<LocationsEnum> toLocation;
  final Value<double> quantity;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const TransfersCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.fromLocation = const Value.absent(),
    this.toLocation = const Value.absent(),
    this.quantity = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TransfersCompanion.insert({
    this.id = const Value.absent(),
    required int itemId,
    required LocationsEnum fromLocation,
    required LocationsEnum toLocation,
    required double quantity,
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : itemId = Value(itemId),
       fromLocation = Value(fromLocation),
       toLocation = Value(toLocation),
       quantity = Value(quantity);
  static Insertable<Transfer> custom({
    Expression<int>? id,
    Expression<int>? itemId,
    Expression<String>? fromLocation,
    Expression<String>? toLocation,
    Expression<double>? quantity,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (fromLocation != null) 'from_location': fromLocation,
      if (toLocation != null) 'to_location': toLocation,
      if (quantity != null) 'quantity': quantity,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TransfersCompanion copyWith({
    Value<int>? id,
    Value<int>? itemId,
    Value<LocationsEnum>? fromLocation,
    Value<LocationsEnum>? toLocation,
    Value<double>? quantity,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return TransfersCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      fromLocation: fromLocation ?? this.fromLocation,
      toLocation: toLocation ?? this.toLocation,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (fromLocation.present) {
      map['from_location'] = Variable<String>(
        $TransfersTable.$converterfromLocation.toSql(fromLocation.value),
      );
    }
    if (toLocation.present) {
      map['to_location'] = Variable<String>(
        $TransfersTable.$convertertoLocation.toSql(toLocation.value),
      );
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransfersCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('fromLocation: $fromLocation, ')
          ..write('toLocation: $toLocation, ')
          ..write('quantity: $quantity, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UnitsTable units = $UnitsTable(this);
  late final $ItemsTable items = $ItemsTable(this);
  late final $CategoryColorsTable categoryColors = $CategoryColorsTable(this);
  late final $ItemCategoriesTable itemCategories = $ItemCategoriesTable(this);
  late final $CartsTable carts = $CartsTable(this);
  late final $CartItemsTable cartItems = $CartItemsTable(this);
  late final $SaleHistoriesTable saleHistories = $SaleHistoriesTable(this);
  late final $StocksTable stocks = $StocksTable(this);
  late final $TransfersTable transfers = $TransfersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    units,
    items,
    categoryColors,
    itemCategories,
    carts,
    cartItems,
    saleHistories,
    stocks,
    transfers,
  ];
}

typedef $$UnitsTableCreateCompanionBuilder =
    UnitsCompanion Function({
      Value<int> id,
      required String name,
      required String shortName,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });
typedef $$UnitsTableUpdateCompanionBuilder =
    UnitsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> shortName,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });

final class $$UnitsTableReferences
    extends BaseReferences<_$AppDatabase, $UnitsTable, Unit> {
  $$UnitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ItemsTable, List<Item>> _itemsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.items,
    aliasName: $_aliasNameGenerator(db.units.id, db.items.unitId),
  );

  $$ItemsTableProcessedTableManager get itemsRefs {
    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.unitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UnitsTableFilterComposer extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shortName => $composableBuilder(
    column: $table.shortName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> itemsRefs(
    Expression<bool> Function($$ItemsTableFilterComposer f) f,
  ) {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shortName => $composableBuilder(
    column: $table.shortName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get shortName =>
      $composableBuilder(column: $table.shortName, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> itemsRefs<T extends Object>(
    Expression<T> Function($$ItemsTableAnnotationComposer a) f,
  ) {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UnitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnitsTable,
          Unit,
          $$UnitsTableFilterComposer,
          $$UnitsTableOrderingComposer,
          $$UnitsTableAnnotationComposer,
          $$UnitsTableCreateCompanionBuilder,
          $$UnitsTableUpdateCompanionBuilder,
          (Unit, $$UnitsTableReferences),
          Unit,
          PrefetchHooks Function({bool itemsRefs})
        > {
  $$UnitsTableTableManager(_$AppDatabase db, $UnitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> shortName = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UnitsCompanion(
                id: id,
                name: name,
                shortName: shortName,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String shortName,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UnitsCompanion.insert(
                id: id,
                name: name,
                shortName: shortName,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UnitsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({itemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (itemsRefs) db.items],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (itemsRefs)
                    await $_getPrefetchedData<Unit, $UnitsTable, Item>(
                      currentTable: table,
                      referencedTable: $$UnitsTableReferences._itemsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$UnitsTableReferences(db, table, p0).itemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.unitId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UnitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnitsTable,
      Unit,
      $$UnitsTableFilterComposer,
      $$UnitsTableOrderingComposer,
      $$UnitsTableAnnotationComposer,
      $$UnitsTableCreateCompanionBuilder,
      $$UnitsTableUpdateCompanionBuilder,
      (Unit, $$UnitsTableReferences),
      Unit,
      PrefetchHooks Function({bool itemsRefs})
    >;
typedef $$ItemsTableCreateCompanionBuilder =
    ItemsCompanion Function({
      Value<int> id,
      required String name,
      required String barcode,
      required double price,
      required int unitId,
      required double stock,
      Value<bool> isActive,
      Value<int?> categoryId,
      Value<DateTime> createdAt,
    });
typedef $$ItemsTableUpdateCompanionBuilder =
    ItemsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> barcode,
      Value<double> price,
      Value<int> unitId,
      Value<double> stock,
      Value<bool> isActive,
      Value<int?> categoryId,
      Value<DateTime> createdAt,
    });

final class $$ItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ItemsTable, Item> {
  $$ItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UnitsTable _unitIdTable(_$AppDatabase db) =>
      db.units.createAlias($_aliasNameGenerator(db.items.unitId, db.units.id));

  $$UnitsTableProcessedTableManager get unitId {
    final $_column = $_itemColumn<int>('unit_id')!;

    final manager = $$UnitsTableTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_unitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CartItemsTable, List<CartItem>>
  _cartItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cartItems,
    aliasName: $_aliasNameGenerator(db.items.id, db.cartItems.itemId),
  );

  $$CartItemsTableProcessedTableManager get cartItemsRefs {
    final manager = $$CartItemsTableTableManager(
      $_db,
      $_db.cartItems,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cartItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StocksTable, List<Stock>> _stocksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.stocks,
    aliasName: $_aliasNameGenerator(db.items.id, db.stocks.itemId),
  );

  $$StocksTableProcessedTableManager get stocksRefs {
    final manager = $$StocksTableTableManager(
      $_db,
      $_db.stocks,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_stocksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransfersTable, List<Transfer>>
  _transfersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transfers,
    aliasName: $_aliasNameGenerator(db.items.id, db.transfers.itemId),
  );

  $$TransfersTableProcessedTableManager get transfersRefs {
    final manager = $$TransfersTableTableManager(
      $_db,
      $_db.transfers,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transfersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ItemsTableFilterComposer extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UnitsTableFilterComposer get unitId {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> cartItemsRefs(
    Expression<bool> Function($$CartItemsTableFilterComposer f) f,
  ) {
    final $$CartItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cartItems,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartItemsTableFilterComposer(
            $db: $db,
            $table: $db.cartItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> stocksRefs(
    Expression<bool> Function($$StocksTableFilterComposer f) f,
  ) {
    final $$StocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stocks,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StocksTableFilterComposer(
            $db: $db,
            $table: $db.stocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transfersRefs(
    Expression<bool> Function($$TransfersTableFilterComposer f) f,
  ) {
    final $$TransfersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transfers,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransfersTableFilterComposer(
            $db: $db,
            $table: $db.transfers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UnitsTableOrderingComposer get unitId {
    final $$UnitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableOrderingComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get stock =>
      $composableBuilder(column: $table.stock, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UnitsTableAnnotationComposer get unitId {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> cartItemsRefs<T extends Object>(
    Expression<T> Function($$CartItemsTableAnnotationComposer a) f,
  ) {
    final $$CartItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cartItems,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.cartItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> stocksRefs<T extends Object>(
    Expression<T> Function($$StocksTableAnnotationComposer a) f,
  ) {
    final $$StocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stocks,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StocksTableAnnotationComposer(
            $db: $db,
            $table: $db.stocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transfersRefs<T extends Object>(
    Expression<T> Function($$TransfersTableAnnotationComposer a) f,
  ) {
    final $$TransfersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transfers,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransfersTableAnnotationComposer(
            $db: $db,
            $table: $db.transfers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemsTable,
          Item,
          $$ItemsTableFilterComposer,
          $$ItemsTableOrderingComposer,
          $$ItemsTableAnnotationComposer,
          $$ItemsTableCreateCompanionBuilder,
          $$ItemsTableUpdateCompanionBuilder,
          (Item, $$ItemsTableReferences),
          Item,
          PrefetchHooks Function({
            bool unitId,
            bool cartItemsRefs,
            bool stocksRefs,
            bool transfersRefs,
          })
        > {
  $$ItemsTableTableManager(_$AppDatabase db, $ItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> barcode = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<int> unitId = const Value.absent(),
                Value<double> stock = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ItemsCompanion(
                id: id,
                name: name,
                barcode: barcode,
                price: price,
                unitId: unitId,
                stock: stock,
                isActive: isActive,
                categoryId: categoryId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String barcode,
                required double price,
                required int unitId,
                required double stock,
                Value<bool> isActive = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ItemsCompanion.insert(
                id: id,
                name: name,
                barcode: barcode,
                price: price,
                unitId: unitId,
                stock: stock,
                isActive: isActive,
                categoryId: categoryId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ItemsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                unitId = false,
                cartItemsRefs = false,
                stocksRefs = false,
                transfersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (cartItemsRefs) db.cartItems,
                    if (stocksRefs) db.stocks,
                    if (transfersRefs) db.transfers,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (unitId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.unitId,
                                    referencedTable: $$ItemsTableReferences
                                        ._unitIdTable(db),
                                    referencedColumn: $$ItemsTableReferences
                                        ._unitIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (cartItemsRefs)
                        await $_getPrefetchedData<Item, $ItemsTable, CartItem>(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._cartItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).cartItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (stocksRefs)
                        await $_getPrefetchedData<Item, $ItemsTable, Stock>(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._stocksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(db, table, p0).stocksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (transfersRefs)
                        await $_getPrefetchedData<Item, $ItemsTable, Transfer>(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._transfersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).transfersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemsTable,
      Item,
      $$ItemsTableFilterComposer,
      $$ItemsTableOrderingComposer,
      $$ItemsTableAnnotationComposer,
      $$ItemsTableCreateCompanionBuilder,
      $$ItemsTableUpdateCompanionBuilder,
      (Item, $$ItemsTableReferences),
      Item,
      PrefetchHooks Function({
        bool unitId,
        bool cartItemsRefs,
        bool stocksRefs,
        bool transfersRefs,
      })
    >;
typedef $$CategoryColorsTableCreateCompanionBuilder =
    CategoryColorsCompanion Function({
      Value<int> id,
      required String hex,
      Value<DateTime> createdAt,
    });
typedef $$CategoryColorsTableUpdateCompanionBuilder =
    CategoryColorsCompanion Function({
      Value<int> id,
      Value<String> hex,
      Value<DateTime> createdAt,
    });

final class $$CategoryColorsTableReferences
    extends BaseReferences<_$AppDatabase, $CategoryColorsTable, CategoryColor> {
  $$CategoryColorsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ItemCategoriesTable, List<ItemCategory>>
  _itemCategoriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.itemCategories,
    aliasName: $_aliasNameGenerator(
      db.categoryColors.id,
      db.itemCategories.colorId,
    ),
  );

  $$ItemCategoriesTableProcessedTableManager get itemCategoriesRefs {
    final manager = $$ItemCategoriesTableTableManager(
      $_db,
      $_db.itemCategories,
    ).filter((f) => f.colorId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemCategoriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoryColorsTableFilterComposer
    extends Composer<_$AppDatabase, $CategoryColorsTable> {
  $$CategoryColorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hex => $composableBuilder(
    column: $table.hex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> itemCategoriesRefs(
    Expression<bool> Function($$ItemCategoriesTableFilterComposer f) f,
  ) {
    final $$ItemCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemCategories,
      getReferencedColumn: (t) => t.colorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.itemCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoryColorsTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoryColorsTable> {
  $$CategoryColorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hex => $composableBuilder(
    column: $table.hex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoryColorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoryColorsTable> {
  $$CategoryColorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get hex =>
      $composableBuilder(column: $table.hex, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> itemCategoriesRefs<T extends Object>(
    Expression<T> Function($$ItemCategoriesTableAnnotationComposer a) f,
  ) {
    final $$ItemCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemCategories,
      getReferencedColumn: (t) => t.colorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.itemCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoryColorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoryColorsTable,
          CategoryColor,
          $$CategoryColorsTableFilterComposer,
          $$CategoryColorsTableOrderingComposer,
          $$CategoryColorsTableAnnotationComposer,
          $$CategoryColorsTableCreateCompanionBuilder,
          $$CategoryColorsTableUpdateCompanionBuilder,
          (CategoryColor, $$CategoryColorsTableReferences),
          CategoryColor,
          PrefetchHooks Function({bool itemCategoriesRefs})
        > {
  $$CategoryColorsTableTableManager(
    _$AppDatabase db,
    $CategoryColorsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryColorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryColorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoryColorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> hex = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CategoryColorsCompanion(
                id: id,
                hex: hex,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String hex,
                Value<DateTime> createdAt = const Value.absent(),
              }) => CategoryColorsCompanion.insert(
                id: id,
                hex: hex,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoryColorsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemCategoriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (itemCategoriesRefs) db.itemCategories,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (itemCategoriesRefs)
                    await $_getPrefetchedData<
                      CategoryColor,
                      $CategoryColorsTable,
                      ItemCategory
                    >(
                      currentTable: table,
                      referencedTable: $$CategoryColorsTableReferences
                          ._itemCategoriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoryColorsTableReferences(
                            db,
                            table,
                            p0,
                          ).itemCategoriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.colorId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoryColorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoryColorsTable,
      CategoryColor,
      $$CategoryColorsTableFilterComposer,
      $$CategoryColorsTableOrderingComposer,
      $$CategoryColorsTableAnnotationComposer,
      $$CategoryColorsTableCreateCompanionBuilder,
      $$CategoryColorsTableUpdateCompanionBuilder,
      (CategoryColor, $$CategoryColorsTableReferences),
      CategoryColor,
      PrefetchHooks Function({bool itemCategoriesRefs})
    >;
typedef $$ItemCategoriesTableCreateCompanionBuilder =
    ItemCategoriesCompanion Function({
      Value<int> id,
      required String name,
      Value<int?> colorId,
      Value<DateTime> createdAt,
    });
typedef $$ItemCategoriesTableUpdateCompanionBuilder =
    ItemCategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int?> colorId,
      Value<DateTime> createdAt,
    });

final class $$ItemCategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $ItemCategoriesTable, ItemCategory> {
  $$ItemCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoryColorsTable _colorIdTable(_$AppDatabase db) =>
      db.categoryColors.createAlias(
        $_aliasNameGenerator(db.itemCategories.colorId, db.categoryColors.id),
      );

  $$CategoryColorsTableProcessedTableManager? get colorId {
    final $_column = $_itemColumn<int>('color_id');
    if ($_column == null) return null;
    final manager = $$CategoryColorsTableTableManager(
      $_db,
      $_db.categoryColors,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_colorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ItemCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $ItemCategoriesTable> {
  $$ItemCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoryColorsTableFilterComposer get colorId {
    final $$CategoryColorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.colorId,
      referencedTable: $db.categoryColors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryColorsTableFilterComposer(
            $db: $db,
            $table: $db.categoryColors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemCategoriesTable> {
  $$ItemCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoryColorsTableOrderingComposer get colorId {
    final $$CategoryColorsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.colorId,
      referencedTable: $db.categoryColors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryColorsTableOrderingComposer(
            $db: $db,
            $table: $db.categoryColors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemCategoriesTable> {
  $$ItemCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CategoryColorsTableAnnotationComposer get colorId {
    final $$CategoryColorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.colorId,
      referencedTable: $db.categoryColors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryColorsTableAnnotationComposer(
            $db: $db,
            $table: $db.categoryColors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemCategoriesTable,
          ItemCategory,
          $$ItemCategoriesTableFilterComposer,
          $$ItemCategoriesTableOrderingComposer,
          $$ItemCategoriesTableAnnotationComposer,
          $$ItemCategoriesTableCreateCompanionBuilder,
          $$ItemCategoriesTableUpdateCompanionBuilder,
          (ItemCategory, $$ItemCategoriesTableReferences),
          ItemCategory,
          PrefetchHooks Function({bool colorId})
        > {
  $$ItemCategoriesTableTableManager(
    _$AppDatabase db,
    $ItemCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> colorId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ItemCategoriesCompanion(
                id: id,
                name: name,
                colorId: colorId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int?> colorId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ItemCategoriesCompanion.insert(
                id: id,
                name: name,
                colorId: colorId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ItemCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({colorId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (colorId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.colorId,
                                referencedTable: $$ItemCategoriesTableReferences
                                    ._colorIdTable(db),
                                referencedColumn:
                                    $$ItemCategoriesTableReferences
                                        ._colorIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ItemCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemCategoriesTable,
      ItemCategory,
      $$ItemCategoriesTableFilterComposer,
      $$ItemCategoriesTableOrderingComposer,
      $$ItemCategoriesTableAnnotationComposer,
      $$ItemCategoriesTableCreateCompanionBuilder,
      $$ItemCategoriesTableUpdateCompanionBuilder,
      (ItemCategory, $$ItemCategoriesTableReferences),
      ItemCategory,
      PrefetchHooks Function({bool colorId})
    >;
typedef $$CartsTableCreateCompanionBuilder =
    CartsCompanion Function({Value<int> id, Value<DateTime> createdAt});
typedef $$CartsTableUpdateCompanionBuilder =
    CartsCompanion Function({Value<int> id, Value<DateTime> createdAt});

final class $$CartsTableReferences
    extends BaseReferences<_$AppDatabase, $CartsTable, Cart> {
  $$CartsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CartItemsTable, List<CartItem>>
  _cartItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cartItems,
    aliasName: $_aliasNameGenerator(db.carts.id, db.cartItems.cartId),
  );

  $$CartItemsTableProcessedTableManager get cartItemsRefs {
    final manager = $$CartItemsTableTableManager(
      $_db,
      $_db.cartItems,
    ).filter((f) => f.cartId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cartItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SaleHistoriesTable, List<SaleHistory>>
  _saleHistoriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.saleHistories,
    aliasName: $_aliasNameGenerator(db.carts.id, db.saleHistories.cartId),
  );

  $$SaleHistoriesTableProcessedTableManager get saleHistoriesRefs {
    final manager = $$SaleHistoriesTableTableManager(
      $_db,
      $_db.saleHistories,
    ).filter((f) => f.cartId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_saleHistoriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CartsTableFilterComposer extends Composer<_$AppDatabase, $CartsTable> {
  $$CartsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> cartItemsRefs(
    Expression<bool> Function($$CartItemsTableFilterComposer f) f,
  ) {
    final $$CartItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cartItems,
      getReferencedColumn: (t) => t.cartId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartItemsTableFilterComposer(
            $db: $db,
            $table: $db.cartItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> saleHistoriesRefs(
    Expression<bool> Function($$SaleHistoriesTableFilterComposer f) f,
  ) {
    final $$SaleHistoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleHistories,
      getReferencedColumn: (t) => t.cartId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleHistoriesTableFilterComposer(
            $db: $db,
            $table: $db.saleHistories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CartsTableOrderingComposer
    extends Composer<_$AppDatabase, $CartsTable> {
  $$CartsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CartsTable> {
  $$CartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> cartItemsRefs<T extends Object>(
    Expression<T> Function($$CartItemsTableAnnotationComposer a) f,
  ) {
    final $$CartItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cartItems,
      getReferencedColumn: (t) => t.cartId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.cartItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> saleHistoriesRefs<T extends Object>(
    Expression<T> Function($$SaleHistoriesTableAnnotationComposer a) f,
  ) {
    final $$SaleHistoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleHistories,
      getReferencedColumn: (t) => t.cartId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleHistoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.saleHistories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CartsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CartsTable,
          Cart,
          $$CartsTableFilterComposer,
          $$CartsTableOrderingComposer,
          $$CartsTableAnnotationComposer,
          $$CartsTableCreateCompanionBuilder,
          $$CartsTableUpdateCompanionBuilder,
          (Cart, $$CartsTableReferences),
          Cart,
          PrefetchHooks Function({bool cartItemsRefs, bool saleHistoriesRefs})
        > {
  $$CartsTableTableManager(_$AppDatabase db, $CartsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CartsCompanion(id: id, createdAt: createdAt),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CartsCompanion.insert(id: id, createdAt: createdAt),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$CartsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({cartItemsRefs = false, saleHistoriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (cartItemsRefs) db.cartItems,
                    if (saleHistoriesRefs) db.saleHistories,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (cartItemsRefs)
                        await $_getPrefetchedData<Cart, $CartsTable, CartItem>(
                          currentTable: table,
                          referencedTable: $$CartsTableReferences
                              ._cartItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CartsTableReferences(
                                db,
                                table,
                                p0,
                              ).cartItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cartId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (saleHistoriesRefs)
                        await $_getPrefetchedData<
                          Cart,
                          $CartsTable,
                          SaleHistory
                        >(
                          currentTable: table,
                          referencedTable: $$CartsTableReferences
                              ._saleHistoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CartsTableReferences(
                                db,
                                table,
                                p0,
                              ).saleHistoriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cartId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CartsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CartsTable,
      Cart,
      $$CartsTableFilterComposer,
      $$CartsTableOrderingComposer,
      $$CartsTableAnnotationComposer,
      $$CartsTableCreateCompanionBuilder,
      $$CartsTableUpdateCompanionBuilder,
      (Cart, $$CartsTableReferences),
      Cart,
      PrefetchHooks Function({bool cartItemsRefs, bool saleHistoriesRefs})
    >;
typedef $$CartItemsTableCreateCompanionBuilder =
    CartItemsCompanion Function({
      Value<int> id,
      required int cartId,
      required int itemId,
      Value<int> quantity,
    });
typedef $$CartItemsTableUpdateCompanionBuilder =
    CartItemsCompanion Function({
      Value<int> id,
      Value<int> cartId,
      Value<int> itemId,
      Value<int> quantity,
    });

final class $$CartItemsTableReferences
    extends BaseReferences<_$AppDatabase, $CartItemsTable, CartItem> {
  $$CartItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CartsTable _cartIdTable(_$AppDatabase db) => db.carts.createAlias(
    $_aliasNameGenerator(db.cartItems.cartId, db.carts.id),
  );

  $$CartsTableProcessedTableManager get cartId {
    final $_column = $_itemColumn<int>('cart_id')!;

    final manager = $$CartsTableTableManager(
      $_db,
      $_db.carts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cartIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ItemsTable _itemIdTable(_$AppDatabase db) => db.items.createAlias(
    $_aliasNameGenerator(db.cartItems.itemId, db.items.id),
  );

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<int>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CartItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CartItemsTable> {
  $$CartItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  $$CartsTableFilterComposer get cartId {
    final $$CartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cartId,
      referencedTable: $db.carts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartsTableFilterComposer(
            $db: $db,
            $table: $db.carts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CartItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CartItemsTable> {
  $$CartItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  $$CartsTableOrderingComposer get cartId {
    final $$CartsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cartId,
      referencedTable: $db.carts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartsTableOrderingComposer(
            $db: $db,
            $table: $db.carts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CartItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CartItemsTable> {
  $$CartItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  $$CartsTableAnnotationComposer get cartId {
    final $$CartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cartId,
      referencedTable: $db.carts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartsTableAnnotationComposer(
            $db: $db,
            $table: $db.carts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CartItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CartItemsTable,
          CartItem,
          $$CartItemsTableFilterComposer,
          $$CartItemsTableOrderingComposer,
          $$CartItemsTableAnnotationComposer,
          $$CartItemsTableCreateCompanionBuilder,
          $$CartItemsTableUpdateCompanionBuilder,
          (CartItem, $$CartItemsTableReferences),
          CartItem,
          PrefetchHooks Function({bool cartId, bool itemId})
        > {
  $$CartItemsTableTableManager(_$AppDatabase db, $CartItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CartItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CartItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CartItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cartId = const Value.absent(),
                Value<int> itemId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
              }) => CartItemsCompanion(
                id: id,
                cartId: cartId,
                itemId: itemId,
                quantity: quantity,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cartId,
                required int itemId,
                Value<int> quantity = const Value.absent(),
              }) => CartItemsCompanion.insert(
                id: id,
                cartId: cartId,
                itemId: itemId,
                quantity: quantity,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CartItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cartId = false, itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cartId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cartId,
                                referencedTable: $$CartItemsTableReferences
                                    ._cartIdTable(db),
                                referencedColumn: $$CartItemsTableReferences
                                    ._cartIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (itemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.itemId,
                                referencedTable: $$CartItemsTableReferences
                                    ._itemIdTable(db),
                                referencedColumn: $$CartItemsTableReferences
                                    ._itemIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CartItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CartItemsTable,
      CartItem,
      $$CartItemsTableFilterComposer,
      $$CartItemsTableOrderingComposer,
      $$CartItemsTableAnnotationComposer,
      $$CartItemsTableCreateCompanionBuilder,
      $$CartItemsTableUpdateCompanionBuilder,
      (CartItem, $$CartItemsTableReferences),
      CartItem,
      PrefetchHooks Function({bool cartId, bool itemId})
    >;
typedef $$SaleHistoriesTableCreateCompanionBuilder =
    SaleHistoriesCompanion Function({
      Value<int> id,
      required int cartId,
      Value<double?> total,
      Value<DateTime> createdAt,
    });
typedef $$SaleHistoriesTableUpdateCompanionBuilder =
    SaleHistoriesCompanion Function({
      Value<int> id,
      Value<int> cartId,
      Value<double?> total,
      Value<DateTime> createdAt,
    });

final class $$SaleHistoriesTableReferences
    extends BaseReferences<_$AppDatabase, $SaleHistoriesTable, SaleHistory> {
  $$SaleHistoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CartsTable _cartIdTable(_$AppDatabase db) => db.carts.createAlias(
    $_aliasNameGenerator(db.saleHistories.cartId, db.carts.id),
  );

  $$CartsTableProcessedTableManager get cartId {
    final $_column = $_itemColumn<int>('cart_id')!;

    final manager = $$CartsTableTableManager(
      $_db,
      $_db.carts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cartIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SaleHistoriesTableFilterComposer
    extends Composer<_$AppDatabase, $SaleHistoriesTable> {
  $$SaleHistoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CartsTableFilterComposer get cartId {
    final $$CartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cartId,
      referencedTable: $db.carts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartsTableFilterComposer(
            $db: $db,
            $table: $db.carts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleHistoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleHistoriesTable> {
  $$SaleHistoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CartsTableOrderingComposer get cartId {
    final $$CartsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cartId,
      referencedTable: $db.carts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartsTableOrderingComposer(
            $db: $db,
            $table: $db.carts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleHistoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleHistoriesTable> {
  $$SaleHistoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CartsTableAnnotationComposer get cartId {
    final $$CartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cartId,
      referencedTable: $db.carts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartsTableAnnotationComposer(
            $db: $db,
            $table: $db.carts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleHistoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SaleHistoriesTable,
          SaleHistory,
          $$SaleHistoriesTableFilterComposer,
          $$SaleHistoriesTableOrderingComposer,
          $$SaleHistoriesTableAnnotationComposer,
          $$SaleHistoriesTableCreateCompanionBuilder,
          $$SaleHistoriesTableUpdateCompanionBuilder,
          (SaleHistory, $$SaleHistoriesTableReferences),
          SaleHistory,
          PrefetchHooks Function({bool cartId})
        > {
  $$SaleHistoriesTableTableManager(_$AppDatabase db, $SaleHistoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleHistoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleHistoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleHistoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cartId = const Value.absent(),
                Value<double?> total = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SaleHistoriesCompanion(
                id: id,
                cartId: cartId,
                total: total,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cartId,
                Value<double?> total = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SaleHistoriesCompanion.insert(
                id: id,
                cartId: cartId,
                total: total,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SaleHistoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cartId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cartId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cartId,
                                referencedTable: $$SaleHistoriesTableReferences
                                    ._cartIdTable(db),
                                referencedColumn: $$SaleHistoriesTableReferences
                                    ._cartIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SaleHistoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SaleHistoriesTable,
      SaleHistory,
      $$SaleHistoriesTableFilterComposer,
      $$SaleHistoriesTableOrderingComposer,
      $$SaleHistoriesTableAnnotationComposer,
      $$SaleHistoriesTableCreateCompanionBuilder,
      $$SaleHistoriesTableUpdateCompanionBuilder,
      (SaleHistory, $$SaleHistoriesTableReferences),
      SaleHistory,
      PrefetchHooks Function({bool cartId})
    >;
typedef $$StocksTableCreateCompanionBuilder =
    StocksCompanion Function({
      Value<int> id,
      required int itemId,
      required LocationsEnum location,
      Value<double> quantity,
    });
typedef $$StocksTableUpdateCompanionBuilder =
    StocksCompanion Function({
      Value<int> id,
      Value<int> itemId,
      Value<LocationsEnum> location,
      Value<double> quantity,
    });

final class $$StocksTableReferences
    extends BaseReferences<_$AppDatabase, $StocksTable, Stock> {
  $$StocksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTable _itemIdTable(_$AppDatabase db) =>
      db.items.createAlias($_aliasNameGenerator(db.stocks.itemId, db.items.id));

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<int>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StocksTableFilterComposer
    extends Composer<_$AppDatabase, $StocksTable> {
  $$StocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LocationsEnum, LocationsEnum, String>
  get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StocksTableOrderingComposer
    extends Composer<_$AppDatabase, $StocksTable> {
  $$StocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $StocksTable> {
  $$StocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocationsEnum, String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StocksTable,
          Stock,
          $$StocksTableFilterComposer,
          $$StocksTableOrderingComposer,
          $$StocksTableAnnotationComposer,
          $$StocksTableCreateCompanionBuilder,
          $$StocksTableUpdateCompanionBuilder,
          (Stock, $$StocksTableReferences),
          Stock,
          PrefetchHooks Function({bool itemId})
        > {
  $$StocksTableTableManager(_$AppDatabase db, $StocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> itemId = const Value.absent(),
                Value<LocationsEnum> location = const Value.absent(),
                Value<double> quantity = const Value.absent(),
              }) => StocksCompanion(
                id: id,
                itemId: itemId,
                location: location,
                quantity: quantity,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int itemId,
                required LocationsEnum location,
                Value<double> quantity = const Value.absent(),
              }) => StocksCompanion.insert(
                id: id,
                itemId: itemId,
                location: location,
                quantity: quantity,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$StocksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.itemId,
                                referencedTable: $$StocksTableReferences
                                    ._itemIdTable(db),
                                referencedColumn: $$StocksTableReferences
                                    ._itemIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StocksTable,
      Stock,
      $$StocksTableFilterComposer,
      $$StocksTableOrderingComposer,
      $$StocksTableAnnotationComposer,
      $$StocksTableCreateCompanionBuilder,
      $$StocksTableUpdateCompanionBuilder,
      (Stock, $$StocksTableReferences),
      Stock,
      PrefetchHooks Function({bool itemId})
    >;
typedef $$TransfersTableCreateCompanionBuilder =
    TransfersCompanion Function({
      Value<int> id,
      required int itemId,
      required LocationsEnum fromLocation,
      required LocationsEnum toLocation,
      required double quantity,
      Value<String?> note,
      Value<DateTime> createdAt,
    });
typedef $$TransfersTableUpdateCompanionBuilder =
    TransfersCompanion Function({
      Value<int> id,
      Value<int> itemId,
      Value<LocationsEnum> fromLocation,
      Value<LocationsEnum> toLocation,
      Value<double> quantity,
      Value<String?> note,
      Value<DateTime> createdAt,
    });

final class $$TransfersTableReferences
    extends BaseReferences<_$AppDatabase, $TransfersTable, Transfer> {
  $$TransfersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTable _itemIdTable(_$AppDatabase db) => db.items.createAlias(
    $_aliasNameGenerator(db.transfers.itemId, db.items.id),
  );

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<int>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransfersTableFilterComposer
    extends Composer<_$AppDatabase, $TransfersTable> {
  $$TransfersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LocationsEnum, LocationsEnum, String>
  get fromLocation => $composableBuilder(
    column: $table.fromLocation,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<LocationsEnum, LocationsEnum, String>
  get toLocation => $composableBuilder(
    column: $table.toLocation,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransfersTableOrderingComposer
    extends Composer<_$AppDatabase, $TransfersTable> {
  $$TransfersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromLocation => $composableBuilder(
    column: $table.fromLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toLocation => $composableBuilder(
    column: $table.toLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransfersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransfersTable> {
  $$TransfersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocationsEnum, String> get fromLocation =>
      $composableBuilder(
        column: $table.fromLocation,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<LocationsEnum, String> get toLocation =>
      $composableBuilder(
        column: $table.toLocation,
        builder: (column) => column,
      );

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransfersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransfersTable,
          Transfer,
          $$TransfersTableFilterComposer,
          $$TransfersTableOrderingComposer,
          $$TransfersTableAnnotationComposer,
          $$TransfersTableCreateCompanionBuilder,
          $$TransfersTableUpdateCompanionBuilder,
          (Transfer, $$TransfersTableReferences),
          Transfer,
          PrefetchHooks Function({bool itemId})
        > {
  $$TransfersTableTableManager(_$AppDatabase db, $TransfersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransfersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransfersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransfersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> itemId = const Value.absent(),
                Value<LocationsEnum> fromLocation = const Value.absent(),
                Value<LocationsEnum> toLocation = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TransfersCompanion(
                id: id,
                itemId: itemId,
                fromLocation: fromLocation,
                toLocation: toLocation,
                quantity: quantity,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int itemId,
                required LocationsEnum fromLocation,
                required LocationsEnum toLocation,
                required double quantity,
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TransfersCompanion.insert(
                id: id,
                itemId: itemId,
                fromLocation: fromLocation,
                toLocation: toLocation,
                quantity: quantity,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransfersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.itemId,
                                referencedTable: $$TransfersTableReferences
                                    ._itemIdTable(db),
                                referencedColumn: $$TransfersTableReferences
                                    ._itemIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TransfersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransfersTable,
      Transfer,
      $$TransfersTableFilterComposer,
      $$TransfersTableOrderingComposer,
      $$TransfersTableAnnotationComposer,
      $$TransfersTableCreateCompanionBuilder,
      $$TransfersTableUpdateCompanionBuilder,
      (Transfer, $$TransfersTableReferences),
      Transfer,
      PrefetchHooks Function({bool itemId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db, _db.units);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
  $$CategoryColorsTableTableManager get categoryColors =>
      $$CategoryColorsTableTableManager(_db, _db.categoryColors);
  $$ItemCategoriesTableTableManager get itemCategories =>
      $$ItemCategoriesTableTableManager(_db, _db.itemCategories);
  $$CartsTableTableManager get carts =>
      $$CartsTableTableManager(_db, _db.carts);
  $$CartItemsTableTableManager get cartItems =>
      $$CartItemsTableTableManager(_db, _db.cartItems);
  $$SaleHistoriesTableTableManager get saleHistories =>
      $$SaleHistoriesTableTableManager(_db, _db.saleHistories);
  $$StocksTableTableManager get stocks =>
      $$StocksTableTableManager(_db, _db.stocks);
  $$TransfersTableTableManager get transfers =>
      $$TransfersTableTableManager(_db, _db.transfers);
}
