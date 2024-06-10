// Сгенерированный код – НЕ ИЗМЕНЯЙТЕ ВРУЧНУЮ
// Этот код был сгенерирован ObjectBox. Чтобы обновить его, снова запустите генератор:
// С пакетом Flutter запустите `flutter pub run build_runner build`.
// Используя пакет Dart, запустите `dart run build_runner build`.
// См. также https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: Camel_case_types, Depen_on_referenced_packages
// покрытие:игнорировать-файл

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'
    as obx_int; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart' as obx;
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import '../entity/account.dart';
import '../entity/category.dart';
import '../entity/profile.dart';
import '../entity/transaction.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(1, 1185109045851542775),
      name: 'Account',
      lastPropertyId: const obx_int.IdUid(11, 4051834862557712608),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 691229716270374342),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 8773312281127696732),
            name: 'uuid',
            type: 9,
            flags: 2080,
            indexId: const obx_int.IdUid(1, 1929937644746519082)),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 4657518713627449829),
            name: 'createdDate',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 98438281425253729),
            name: 'name',
            type: 9,
            flags: 2080,
            indexId: const obx_int.IdUid(2, 7523580271093772442)),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 4774765264550205574),
            name: 'currency',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 4199922829114171439),
            name: 'iconCode',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(10, 1464855086006613388),
            name: 'excludeFromTotalBalance',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(11, 4051834862557712608),
            name: 'sortOrder',
            type: 6,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[
        obx_int.ModelBacklink(
            name: 'transactions', srcEntity: 'Transaction', srcField: 'account')
      ]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(2, 649350347514211469),
      name: 'Category',
      lastPropertyId: const obx_int.IdUid(8, 2832069050067036408),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 1543873184246568510),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 4092645274001419169),
            name: 'uuid',
            type: 9,
            flags: 2080,
            indexId: const obx_int.IdUid(3, 4567310141724695230)),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 7355350125139499009),
            name: 'createdDate',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 6997289246296566376),
            name: 'name',
            type: 9,
            flags: 2080,
            indexId: const obx_int.IdUid(4, 2391044209964121362)),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 7989789340130049283),
            name: 'iconCode',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[
        obx_int.ModelBacklink(
            name: 'transactions',
            srcEntity: 'Transaction',
            srcField: 'category')
      ]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(5, 3298987588431022631),
      name: 'Profile',
      lastPropertyId: const obx_int.IdUid(5, 3781626172731013526),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 7051631551441750621),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 731255396614738413),
            name: 'uuid',
            type: 9,
            flags: 2080,
            indexId: const obx_int.IdUid(11, 6445110811655945444)),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 6455801293952865246),
            name: 'name',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 5771346759499657768),
            name: 'createdDate',
            type: 10,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(6, 5991227438386928245),
      name: 'BackupEntry',
      lastPropertyId: const obx_int.IdUid(6, 85022155315718452),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 5752762434527855344),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 8774895379662319967),
            name: 'syncModelVersion',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 5145480293665316701),
            name: 'createdDate',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 6125452647375382801),
            name: 'filePath',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 5398904418479897232),
            name: 'type',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 85022155315718452),
            name: 'fileExt',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(7, 5357777579468740615),
      name: 'Transaction',
      lastPropertyId: const obx_int.IdUid(13, 8197332672689416676),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 9110098830115993878),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 5969985101281949207),
            name: 'uuid',
            type: 9,
            flags: 2080,
            indexId: const obx_int.IdUid(12, 1386471796517044894)),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 614756132375370358),
            name: 'createdDate',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 7728114574705964455),
            name: 'transactionDate',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 784468101854697419),
            name: 'title',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 7213343959758309797),
            name: 'amount',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 5879078778613651092),
            name: 'currency',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(8, 7268940743609048799),
            name: 'subtype',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(9, 4527254666523321017),
            name: 'extra',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(10, 3862476953254710135),
            name: 'categoryId',
            type: 11,
            flags: 520,
            indexId: const obx_int.IdUid(13, 6668612341220351989),
            relationTarget: 'Category'),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(11, 2468817122549060742),
            name: 'accountId',
            type: 11,
            flags: 520,
            indexId: const obx_int.IdUid(14, 1594637005857043935),
            relationTarget: 'Account'),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(12, 2414941424956693997),
            name: 'categoryUuid',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(13, 8197332672689416676),
            name: 'accountUuid',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[])
];

/// Shortcut for [Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [Store.new] for an explanation of all parameters.
///
/// For Flutter apps, also calls `loadObjectBoxLibraryAndroidCompat()` from
/// the ObjectBox Flutter library to fix loading the native ObjectBox library
/// on Android 6 and older.
Future<obx.Store> openStore(
    {String? directory,
    int? maxDBSizeInKB,
    int? maxDataSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool queriesCaseSensitiveDefault = true,
    String? macosApplicationGroup}) async {
  await loadObjectBoxLibraryAndroidCompat();
  return obx.Store(getObjectBoxModel(),
      directory: directory ?? (await defaultStoreDirectory()).path,
      maxDBSizeInKB: maxDBSizeInKB,
      maxDataSizeInKB: maxDataSizeInKB,
      fileMode: fileMode,
      maxReaders: maxReaders,
      queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
      macosApplicationGroup: macosApplicationGroup);
}

/// Returns the ObjectBox model definition for this project for use with
/// [Store.new].
obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
      entities: _entities,
      lastEntityId: const obx_int.IdUid(7, 5357777579468740615),
      lastIndexId: const obx_int.IdUid(14, 1594637005857043935),
      lastRelationId: const obx_int.IdUid(0, 0),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [3796819593314794683, 2857566645668229410],
      retiredIndexUids: const [],
      retiredPropertyUids: const [
        620570223027064518,
        4256690661297760083,
        6938078869065968115,
        1403783421127032859,
        5822272069646732572,
        3352242595820563295,
        7280484442250674290,
        7528954808630752939,
        2052151351995260526,
        2763207879596101849,
        3781626172731013526,
        4631816643044519644,
        2582035562365559834,
        1199002594005420779,
        7985125654311551623,
        7846957356397143011,
        8386618621719093135,
        3858309169442527296,
        6772806689343886062,
        8465977223650476366,
        3806574754524012859,
        8163231449257835161,
        8413544260372569748,
        5446772239174299489,
        3056128952161562633,
        2675470948342446870,
        2832069050067036408
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, obx_int.EntityDefinition>{
    Account: obx_int.EntityDefinition<Account>(
        model: _entities[0],
        toOneRelations: (Account object) => [],
        toManyRelations: (Account object) => {
              obx_int.RelInfo<Transaction>.toOneBacklink(11, object.id,
                      (Transaction srcObject) => srcObject.account):
                  object.transactions
            },
        getId: (Account object) => object.id,
        setId: (Account object, int id) {
          object.id = id;
        },
        objectToFB: (Account object, fb.Builder fbb) {
          final uuidOffset = fbb.writeString(object.uuid);
          final nameOffset = fbb.writeString(object.name);
          final currencyOffset = fbb.writeString(object.currency);
          final iconCodeOffset = fbb.writeString(object.iconCode);
          fbb.startTable(12);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, uuidOffset);
          fbb.addInt64(2, object.createdDate.millisecondsSinceEpoch);
          fbb.addOffset(3, nameOffset);
          fbb.addOffset(4, currencyOffset);
          fbb.addOffset(6, iconCodeOffset);
          fbb.addBool(9, object.excludeFromTotalBalance);
          fbb.addInt64(10, object.sortOrder);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final nameParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 10, '');
          final currencyParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 12, '');
          final iconCodeParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 16, '');
          final excludeFromTotalBalanceParam =
              const fb.BoolReader().vTableGet(buffer, rootOffset, 22, false);
          final sortOrderParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 24, 0);
          final createdDateParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0));
          final object = Account(
              id: idParam,
              name: nameParam,
              currency: currencyParam,
              iconCode: iconCodeParam,
              excludeFromTotalBalance: excludeFromTotalBalanceParam,
              sortOrder: sortOrderParam,
              createdDate: createdDateParam)
            ..uuid = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 6, '');
          obx_int.InternalToManyAccess.setRelInfo<Account>(
              object.transactions,
              store,
              obx_int.RelInfo<Transaction>.toOneBacklink(
                  11, object.id, (Transaction srcObject) => srcObject.account));
          return object;
        }),
    Category: obx_int.EntityDefinition<Category>(
        model: _entities[1],
        toOneRelations: (Category object) => [],
        toManyRelations: (Category object) => {
              obx_int.RelInfo<Transaction>.toOneBacklink(10, object.id,
                      (Transaction srcObject) => srcObject.category):
                  object.transactions
            },
        getId: (Category object) => object.id,
        setId: (Category object, int id) {
          object.id = id;
        },
        objectToFB: (Category object, fb.Builder fbb) {
          final uuidOffset = fbb.writeString(object.uuid);
          final nameOffset = fbb.writeString(object.name);
          final iconCodeOffset = fbb.writeString(object.iconCode);
          fbb.startTable(9);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, uuidOffset);
          fbb.addInt64(2, object.createdDate.millisecondsSinceEpoch);
          fbb.addOffset(3, nameOffset);
          fbb.addOffset(5, iconCodeOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final nameParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 10, '');
          final iconCodeParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 14, '');
          final createdDateParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0));
          final object = Category(
              id: idParam,
              name: nameParam,
              iconCode: iconCodeParam,
              createdDate: createdDateParam)
            ..uuid = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 6, '');
          obx_int.InternalToManyAccess.setRelInfo<Category>(
              object.transactions,
              store,
              obx_int.RelInfo<Transaction>.toOneBacklink(10, object.id,
                  (Transaction srcObject) => srcObject.category));
          return object;
        }),
    Profile: obx_int.EntityDefinition<Profile>(
        model: _entities[2],
        toOneRelations: (Profile object) => [],
        toManyRelations: (Profile object) => {},
        getId: (Profile object) => object.id,
        setId: (Profile object, int id) {
          object.id = id;
        },
        objectToFB: (Profile object, fb.Builder fbb) {
          final uuidOffset = fbb.writeString(object.uuid);
          final nameOffset = fbb.writeString(object.name);
          fbb.startTable(6);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, uuidOffset);
          fbb.addOffset(2, nameOffset);
          fbb.addInt64(3, object.createdDate.millisecondsSinceEpoch);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final createdDateParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0));
          final nameParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 8, '');
          final object = Profile(
              id: idParam, createdDate: createdDateParam, name: nameParam)
            ..uuid = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 6, '');

          return object;
        }),

    Transaction: obx_int.EntityDefinition<Transaction>(
        model: _entities[4],
        toOneRelations: (Transaction object) =>
            [object.category, object.account],
        toManyRelations: (Transaction object) => {},
        getId: (Transaction object) => object.id,
        setId: (Transaction object, int id) {
          object.id = id;
        },
        objectToFB: (Transaction object, fb.Builder fbb) {
          final uuidOffset = fbb.writeString(object.uuid);
          final titleOffset =
              object.title == null ? null : fbb.writeString(object.title!);
          final currencyOffset = fbb.writeString(object.valuyta);
          final subtypeOffset =
              object.subtype == null ? null : fbb.writeString(object.subtype!);
          final extraOffset =
              object.extra == null ? null : fbb.writeString(object.extra!);
          final categoryUuidOffset = object.categoryUuid == null
              ? null
              : fbb.writeString(object.categoryUuid!);
          final accountUuidOffset = object.accountUuid == null
              ? null
              : fbb.writeString(object.accountUuid!);
          fbb.startTable(14);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, uuidOffset);
          fbb.addInt64(2, object.createdDate.millisecondsSinceEpoch);
          fbb.addInt64(3, object.transactionDate.millisecondsSinceEpoch);
          fbb.addOffset(4, titleOffset);
          fbb.addFloat64(5, object.amount);
          fbb.addOffset(6, currencyOffset);
          fbb.addOffset(7, subtypeOffset);
          fbb.addOffset(8, extraOffset);
          fbb.addInt64(9, object.category.targetId);
          fbb.addInt64(10, object.account.targetId);
          fbb.addOffset(11, categoryUuidOffset);
          fbb.addOffset(12, accountUuidOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final titleParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 12);
          final subtypeParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 18);
          final amountParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 14, 0);
          final currencyParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 16, '');
          final transactionDateParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0));
          final createdDateParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0));
          final object = Transaction(
              id: idParam,
              title: titleParam,
              subtype: subtypeParam,
              amount: amountParam,
              valuyta: currencyParam,
              transactionDate: transactionDateParam,
              createdDate: createdDateParam)
            ..uuid = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 6, '')
            ..extra = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 20)
            ..categoryUuid = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 26)
            ..accountUuid = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 28);
          object.category.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 22, 0);
          object.category.attach(store);
          object.account.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 24, 0);
          object.account.attach(store);
          return object;
        })
  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [Account] entity fields to define ObjectBox queries.
class Account_ {
  /// see [Account.id]
  static final id =
      obx.QueryIntegerProperty<Account>(_entities[0].properties[0]);

  /// see [Account.uuid]
  static final uuid =
      obx.QueryStringProperty<Account>(_entities[0].properties[1]);

  /// see [Account.createdDate]
  static final createdDate =
      obx.QueryDateProperty<Account>(_entities[0].properties[2]);

  /// see [Account.name]
  static final name =
      obx.QueryStringProperty<Account>(_entities[0].properties[3]);

  /// see [Account.currency]
  static final currency =
      obx.QueryStringProperty<Account>(_entities[0].properties[4]);

  /// see [Account.iconCode]
  static final iconCode =
      obx.QueryStringProperty<Account>(_entities[0].properties[5]);

  /// see [Account.excludeFromTotalBalance]
  static final excludeFromTotalBalance =
      obx.QueryBooleanProperty<Account>(_entities[0].properties[6]);

  /// see [Account.sortOrder]
  static final sortOrder =
      obx.QueryIntegerProperty<Account>(_entities[0].properties[7]);

  /// see [Account.transactions]
  static final transactions =
      obx.QueryBacklinkToMany<Transaction, Account>(Transaction_.account);
}

/// [Category] entity fields to define ObjectBox queries.
class Category_ {
  /// see [Category.id]
  static final id =
      obx.QueryIntegerProperty<Category>(_entities[1].properties[0]);

  /// see [Category.uuid]
  static final uuid =
      obx.QueryStringProperty<Category>(_entities[1].properties[1]);

  /// see [Category.createdDate]
  static final createdDate =
      obx.QueryDateProperty<Category>(_entities[1].properties[2]);

  /// see [Category.name]
  static final name =
      obx.QueryStringProperty<Category>(_entities[1].properties[3]);

  /// see [Category.iconCode]
  static final iconCode =
      obx.QueryStringProperty<Category>(_entities[1].properties[4]);

  /// see [Category.transactions]
  static final transactions =
      obx.QueryBacklinkToMany<Transaction, Category>(Transaction_.category);
}

/// [Profile] entity fields to define ObjectBox queries.
class Profile_ {
  /// see [Profile.id]
  static final id =
      obx.QueryIntegerProperty<Profile>(_entities[2].properties[0]);

  /// see [Profile.uuid]
  static final uuid =
      obx.QueryStringProperty<Profile>(_entities[2].properties[1]);

  /// see [Profile.name]
  static final name =
      obx.QueryStringProperty<Profile>(_entities[2].properties[2]);

  /// see [Profile.createdDate]
  static final createdDate =
      obx.QueryDateProperty<Profile>(_entities[2].properties[3]);
}

/// [BackupEntry] entity fields to define ObjectBox queries.


/// [Transaction] entity fields to define ObjectBox queries.
class Transaction_ {
  /// see [Transaction.id]
  static final id =
      obx.QueryIntegerProperty<Transaction>(_entities[4].properties[0]);

  /// see [Transaction.uuid]
  static final uuid =
      obx.QueryStringProperty<Transaction>(_entities[4].properties[1]);

  /// see [Transaction.createdDate]
  static final createdDate =
      obx.QueryDateProperty<Transaction>(_entities[4].properties[2]);

  /// see [Transaction.transactionDate]
  static final transactionDate =
      obx.QueryDateProperty<Transaction>(_entities[4].properties[3]);

  /// see [Transaction.title]
  static final title =
      obx.QueryStringProperty<Transaction>(_entities[4].properties[4]);

  /// see [Transaction.amount]
  static final amount =
      obx.QueryDoubleProperty<Transaction>(_entities[4].properties[5]);

  /// see [Transaction.valuyta]
  static final currency =
      obx.QueryStringProperty<Transaction>(_entities[4].properties[6]);

  /// see [Transaction.subtype]
  static final subtype =
      obx.QueryStringProperty<Transaction>(_entities[4].properties[7]);

  /// see [Transaction.extra]
  static final extra =
      obx.QueryStringProperty<Transaction>(_entities[4].properties[8]);

  /// see [Transaction.category]
  static final category =
      obx.QueryRelationToOne<Transaction, Category>(_entities[4].properties[9]);

  /// see [Transaction.account]
  static final account =
      obx.QueryRelationToOne<Transaction, Account>(_entities[4].properties[10]);

  /// see [Transaction.categoryUuid]
  static final categoryUuid =
      obx.QueryStringProperty<Transaction>(_entities[4].properties[11]);

  /// see [Transaction.accountUuid]
  static final accountUuid =
      obx.QueryStringProperty<Transaction>(_entities[4].properties[12]);
}
