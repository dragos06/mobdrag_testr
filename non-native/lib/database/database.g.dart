

part of 'database.dart';


class $DeviceTablesTable extends DeviceTables
    with TableInfo<$DeviceTablesTable, DeviceTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceTablesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pendingSyncMeta = const VerificationMeta(
    'pendingSync',
  );
  @override
  late final GeneratedColumn<bool> pendingSync = GeneratedColumn<bool>(
    'pending_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pending_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _toDeleteMeta = const VerificationMeta(
    'toDelete',
  );
  @override
  late final GeneratedColumn<bool> toDelete = GeneratedColumn<bool>(
    'to_delete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("to_delete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _osMeta = const VerificationMeta('os');
  @override
  late final GeneratedColumn<String> os = GeneratedColumn<String>(
    'os',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 30,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _screenResolutionMeta = const VerificationMeta(
    'screenResolution',
  );
  @override
  late final GeneratedColumn<String> screenResolution = GeneratedColumn<String>(
    'screen_resolution',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usedByMeta = const VerificationMeta('usedBy');
  @override
  late final GeneratedColumn<String> usedBy = GeneratedColumn<String>(
    'used_by',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    pendingSync,
    toDelete,
    lastModified,
    model,
    os,
    screenResolution,
    status,
    usedBy,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_tables';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeviceTable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('pending_sync')) {
      context.handle(
        _pendingSyncMeta,
        pendingSync.isAcceptableOrUnknown(
          data['pending_sync']!,
          _pendingSyncMeta,
        ),
      );
    }
    if (data.containsKey('to_delete')) {
      context.handle(
        _toDeleteMeta,
        toDelete.isAcceptableOrUnknown(data['to_delete']!, _toDeleteMeta),
      );
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('os')) {
      context.handle(_osMeta, os.isAcceptableOrUnknown(data['os']!, _osMeta));
    } else if (isInserting) {
      context.missing(_osMeta);
    }
    if (data.containsKey('screen_resolution')) {
      context.handle(
        _screenResolutionMeta,
        screenResolution.isAcceptableOrUnknown(
          data['screen_resolution']!,
          _screenResolutionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_screenResolutionMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('used_by')) {
      context.handle(
        _usedByMeta,
        usedBy.isAcceptableOrUnknown(data['used_by']!, _usedByMeta),
      );
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
  DeviceTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceTable(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      pendingSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pending_sync'],
      )!,
      toDelete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}to_delete'],
      )!,
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      os: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}os'],
      )!,
      screenResolution: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}screen_resolution'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      usedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}used_by'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $DeviceTablesTable createAlias(String alias) {
    return $DeviceTablesTable(attachedDatabase, alias);
  }
}

class DeviceTable extends DataClass implements Insertable<DeviceTable> {
  final int id;
  final int? serverId;
  final bool pendingSync;
  final bool toDelete;
  final DateTime lastModified;
  final String model;
  final String os;
  final String screenResolution;
  final int status;
  final String? usedBy;
  final String? notes;
  const DeviceTable({
    required this.id,
    this.serverId,
    required this.pendingSync,
    required this.toDelete,
    required this.lastModified,
    required this.model,
    required this.os,
    required this.screenResolution,
    required this.status,
    this.usedBy,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['pending_sync'] = Variable<bool>(pendingSync);
    map['to_delete'] = Variable<bool>(toDelete);
    map['last_modified'] = Variable<DateTime>(lastModified);
    map['model'] = Variable<String>(model);
    map['os'] = Variable<String>(os);
    map['screen_resolution'] = Variable<String>(screenResolution);
    map['status'] = Variable<int>(status);
    if (!nullToAbsent || usedBy != null) {
      map['used_by'] = Variable<String>(usedBy);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  DeviceTablesCompanion toCompanion(bool nullToAbsent) {
    return DeviceTablesCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      pendingSync: Value(pendingSync),
      toDelete: Value(toDelete),
      lastModified: Value(lastModified),
      model: Value(model),
      os: Value(os),
      screenResolution: Value(screenResolution),
      status: Value(status),
      usedBy: usedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(usedBy),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory DeviceTable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceTable(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      pendingSync: serializer.fromJson<bool>(json['pendingSync']),
      toDelete: serializer.fromJson<bool>(json['toDelete']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
      model: serializer.fromJson<String>(json['model']),
      os: serializer.fromJson<String>(json['os']),
      screenResolution: serializer.fromJson<String>(json['screenResolution']),
      status: serializer.fromJson<int>(json['status']),
      usedBy: serializer.fromJson<String?>(json['usedBy']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<int?>(serverId),
      'pendingSync': serializer.toJson<bool>(pendingSync),
      'toDelete': serializer.toJson<bool>(toDelete),
      'lastModified': serializer.toJson<DateTime>(lastModified),
      'model': serializer.toJson<String>(model),
      'os': serializer.toJson<String>(os),
      'screenResolution': serializer.toJson<String>(screenResolution),
      'status': serializer.toJson<int>(status),
      'usedBy': serializer.toJson<String?>(usedBy),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  DeviceTable copyWith({
    int? id,
    Value<int?> serverId = const Value.absent(),
    bool? pendingSync,
    bool? toDelete,
    DateTime? lastModified,
    String? model,
    String? os,
    String? screenResolution,
    int? status,
    Value<String?> usedBy = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => DeviceTable(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    pendingSync: pendingSync ?? this.pendingSync,
    toDelete: toDelete ?? this.toDelete,
    lastModified: lastModified ?? this.lastModified,
    model: model ?? this.model,
    os: os ?? this.os,
    screenResolution: screenResolution ?? this.screenResolution,
    status: status ?? this.status,
    usedBy: usedBy.present ? usedBy.value : this.usedBy,
    notes: notes.present ? notes.value : this.notes,
  );
  DeviceTable copyWithCompanion(DeviceTablesCompanion data) {
    return DeviceTable(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      pendingSync: data.pendingSync.present
          ? data.pendingSync.value
          : this.pendingSync,
      toDelete: data.toDelete.present ? data.toDelete.value : this.toDelete,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
      model: data.model.present ? data.model.value : this.model,
      os: data.os.present ? data.os.value : this.os,
      screenResolution: data.screenResolution.present
          ? data.screenResolution.value
          : this.screenResolution,
      status: data.status.present ? data.status.value : this.status,
      usedBy: data.usedBy.present ? data.usedBy.value : this.usedBy,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceTable(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('pendingSync: $pendingSync, ')
          ..write('toDelete: $toDelete, ')
          ..write('lastModified: $lastModified, ')
          ..write('model: $model, ')
          ..write('os: $os, ')
          ..write('screenResolution: $screenResolution, ')
          ..write('status: $status, ')
          ..write('usedBy: $usedBy, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    pendingSync,
    toDelete,
    lastModified,
    model,
    os,
    screenResolution,
    status,
    usedBy,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceTable &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.pendingSync == this.pendingSync &&
          other.toDelete == this.toDelete &&
          other.lastModified == this.lastModified &&
          other.model == this.model &&
          other.os == this.os &&
          other.screenResolution == this.screenResolution &&
          other.status == this.status &&
          other.usedBy == this.usedBy &&
          other.notes == this.notes);
}

class DeviceTablesCompanion extends UpdateCompanion<DeviceTable> {
  final Value<int> id;
  final Value<int?> serverId;
  final Value<bool> pendingSync;
  final Value<bool> toDelete;
  final Value<DateTime> lastModified;
  final Value<String> model;
  final Value<String> os;
  final Value<String> screenResolution;
  final Value<int> status;
  final Value<String?> usedBy;
  final Value<String?> notes;
  const DeviceTablesCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.pendingSync = const Value.absent(),
    this.toDelete = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.model = const Value.absent(),
    this.os = const Value.absent(),
    this.screenResolution = const Value.absent(),
    this.status = const Value.absent(),
    this.usedBy = const Value.absent(),
    this.notes = const Value.absent(),
  });
  DeviceTablesCompanion.insert({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.pendingSync = const Value.absent(),
    this.toDelete = const Value.absent(),
    this.lastModified = const Value.absent(),
    required String model,
    required String os,
    required String screenResolution,
    required int status,
    this.usedBy = const Value.absent(),
    this.notes = const Value.absent(),
  }) : model = Value(model),
       os = Value(os),
       screenResolution = Value(screenResolution),
       status = Value(status);
  static Insertable<DeviceTable> custom({
    Expression<int>? id,
    Expression<int>? serverId,
    Expression<bool>? pendingSync,
    Expression<bool>? toDelete,
    Expression<DateTime>? lastModified,
    Expression<String>? model,
    Expression<String>? os,
    Expression<String>? screenResolution,
    Expression<int>? status,
    Expression<String>? usedBy,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (pendingSync != null) 'pending_sync': pendingSync,
      if (toDelete != null) 'to_delete': toDelete,
      if (lastModified != null) 'last_modified': lastModified,
      if (model != null) 'model': model,
      if (os != null) 'os': os,
      if (screenResolution != null) 'screen_resolution': screenResolution,
      if (status != null) 'status': status,
      if (usedBy != null) 'used_by': usedBy,
      if (notes != null) 'notes': notes,
    });
  }

  DeviceTablesCompanion copyWith({
    Value<int>? id,
    Value<int?>? serverId,
    Value<bool>? pendingSync,
    Value<bool>? toDelete,
    Value<DateTime>? lastModified,
    Value<String>? model,
    Value<String>? os,
    Value<String>? screenResolution,
    Value<int>? status,
    Value<String?>? usedBy,
    Value<String?>? notes,
  }) {
    return DeviceTablesCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      pendingSync: pendingSync ?? this.pendingSync,
      toDelete: toDelete ?? this.toDelete,
      lastModified: lastModified ?? this.lastModified,
      model: model ?? this.model,
      os: os ?? this.os,
      screenResolution: screenResolution ?? this.screenResolution,
      status: status ?? this.status,
      usedBy: usedBy ?? this.usedBy,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (pendingSync.present) {
      map['pending_sync'] = Variable<bool>(pendingSync.value);
    }
    if (toDelete.present) {
      map['to_delete'] = Variable<bool>(toDelete.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (os.present) {
      map['os'] = Variable<String>(os.value);
    }
    if (screenResolution.present) {
      map['screen_resolution'] = Variable<String>(screenResolution.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (usedBy.present) {
      map['used_by'] = Variable<String>(usedBy.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceTablesCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('pendingSync: $pendingSync, ')
          ..write('toDelete: $toDelete, ')
          ..write('lastModified: $lastModified, ')
          ..write('model: $model, ')
          ..write('os: $os, ')
          ..write('screenResolution: $screenResolution, ')
          ..write('status: $status, ')
          ..write('usedBy: $usedBy, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DeviceTablesTable deviceTables = $DeviceTablesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [deviceTables];
}

typedef $$DeviceTablesTableCreateCompanionBuilder =
    DeviceTablesCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      Value<bool> pendingSync,
      Value<bool> toDelete,
      Value<DateTime> lastModified,
      required String model,
      required String os,
      required String screenResolution,
      required int status,
      Value<String?> usedBy,
      Value<String?> notes,
    });
typedef $$DeviceTablesTableUpdateCompanionBuilder =
    DeviceTablesCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      Value<bool> pendingSync,
      Value<bool> toDelete,
      Value<DateTime> lastModified,
      Value<String> model,
      Value<String> os,
      Value<String> screenResolution,
      Value<int> status,
      Value<String?> usedBy,
      Value<String?> notes,
    });

class $$DeviceTablesTableFilterComposer
    extends Composer<_$AppDatabase, $DeviceTablesTable> {
  $$DeviceTablesTableFilterComposer({
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

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get toDelete => $composableBuilder(
    column: $table.toDelete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get os => $composableBuilder(
    column: $table.os,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get screenResolution => $composableBuilder(
    column: $table.screenResolution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usedBy => $composableBuilder(
    column: $table.usedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeviceTablesTableOrderingComposer
    extends Composer<_$AppDatabase, $DeviceTablesTable> {
  $$DeviceTablesTableOrderingComposer({
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

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get toDelete => $composableBuilder(
    column: $table.toDelete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get os => $composableBuilder(
    column: $table.os,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get screenResolution => $composableBuilder(
    column: $table.screenResolution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usedBy => $composableBuilder(
    column: $table.usedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeviceTablesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeviceTablesTable> {
  $$DeviceTablesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get toDelete =>
      $composableBuilder(column: $table.toDelete, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get os =>
      $composableBuilder(column: $table.os, builder: (column) => column);

  GeneratedColumn<String> get screenResolution => $composableBuilder(
    column: $table.screenResolution,
    builder: (column) => column,
  );

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get usedBy =>
      $composableBuilder(column: $table.usedBy, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$DeviceTablesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeviceTablesTable,
          DeviceTable,
          $$DeviceTablesTableFilterComposer,
          $$DeviceTablesTableOrderingComposer,
          $$DeviceTablesTableAnnotationComposer,
          $$DeviceTablesTableCreateCompanionBuilder,
          $$DeviceTablesTableUpdateCompanionBuilder,
          (
            DeviceTable,
            BaseReferences<_$AppDatabase, $DeviceTablesTable, DeviceTable>,
          ),
          DeviceTable,
          PrefetchHooks Function()
        > {
  $$DeviceTablesTableTableManager(_$AppDatabase db, $DeviceTablesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeviceTablesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeviceTablesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeviceTablesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<bool> pendingSync = const Value.absent(),
                Value<bool> toDelete = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<String> os = const Value.absent(),
                Value<String> screenResolution = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<String?> usedBy = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => DeviceTablesCompanion(
                id: id,
                serverId: serverId,
                pendingSync: pendingSync,
                toDelete: toDelete,
                lastModified: lastModified,
                model: model,
                os: os,
                screenResolution: screenResolution,
                status: status,
                usedBy: usedBy,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<bool> pendingSync = const Value.absent(),
                Value<bool> toDelete = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                required String model,
                required String os,
                required String screenResolution,
                required int status,
                Value<String?> usedBy = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => DeviceTablesCompanion.insert(
                id: id,
                serverId: serverId,
                pendingSync: pendingSync,
                toDelete: toDelete,
                lastModified: lastModified,
                model: model,
                os: os,
                screenResolution: screenResolution,
                status: status,
                usedBy: usedBy,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeviceTablesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeviceTablesTable,
      DeviceTable,
      $$DeviceTablesTableFilterComposer,
      $$DeviceTablesTableOrderingComposer,
      $$DeviceTablesTableAnnotationComposer,
      $$DeviceTablesTableCreateCompanionBuilder,
      $$DeviceTablesTableUpdateCompanionBuilder,
      (
        DeviceTable,
        BaseReferences<_$AppDatabase, $DeviceTablesTable, DeviceTable>,
      ),
      DeviceTable,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DeviceTablesTableTableManager get deviceTables =>
      $$DeviceTablesTableTableManager(_db, _db.deviceTables);
}
