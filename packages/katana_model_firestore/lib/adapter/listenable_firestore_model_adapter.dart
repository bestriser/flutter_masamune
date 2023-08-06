part of katana_model_firestore;

/// Model adapter with Firebase Firestore available.
///
/// It monitors all documents in Firestore for changes and notifies you of any changes on the remote side.
///
/// Firestore application settings must be completed in advance and [FirebaseCore.initialize] must be executed.
///
/// Basically, the default [FirebaseFirestore.instance] is used, but it is possible to use a specified database by passing [database] when creating the adapter.
///
/// You can initialize Firebase by passing [options].
///
/// The internal database can be specified in [localDatabase].
///
/// By passing data to [initialValue], the database can be used as a data mockup because it contains data in advance.
///
/// By adding [prefix], all paths can be prefixed, enabling operations such as separating data storage locations for each Flavor.
///
/// FirebaseFirestoreを利用できるようにしたモデルアダプター。
///
/// Firestoreのすべてのドキュメントの変更を監視し、リモート側で変更があればそれを通知します。
///
/// 事前にFirestoreのアプリ設定を済ませておくことと[FirebaseCore.initialize]を実行しておきます。
///
/// 基本的にデフォルトの[FirebaseFirestore.instance]が利用されますが、アダプターの作成時に[database]を渡すことで指定されたデータベースを利用することが可能です。
///
/// [options]を渡すことでFirebaseの初期化を行うことができます。
///
/// 内部データベースは[localDatabase]で指定することができます。
///
/// [initialValue]にデータを渡すことで予めデータが入った状態でデータベースを利用することができるためデータモックとして利用することができます。
///
/// [prefix]を追加することですべてのパスにプレフィックスを付与することができ、Flavorごとにデータの保存場所を分けるなどの運用が可能です。
class ListenableFirestoreModelAdapter extends ModelAdapter
    implements FirestoreModelAdapterBase {
  /// Model adapter with Firebase Firestore available.
  ///
  /// It monitors all documents in Firestore for changes and notifies you of any changes on the remote side.
  ///
  /// Firestore application settings must be completed in advance and [FirebaseCore.initialize] must be executed.
  ///
  /// Basically, the default [FirebaseFirestore.instance] is used, but it is possible to use a specified database by passing [database] when creating the adapter.
  ///
  /// You can initialize Firebase by passing [options].
  ///
  /// The internal database can be specified in [localDatabase].
  ///
  /// By passing data to [initialValue], the database can be used as a data mockup because it contains data in advance.
  ///
  /// By adding [prefix], all paths can be prefixed, enabling operations such as separating data storage locations for each Flavor.
  ///
  /// FirebaseFirestoreを利用できるようにしたモデルアダプター。
  ///
  /// Firestoreのすべてのドキュメントの変更を監視し、リモート側で変更があればそれを通知します。
  ///
  /// 事前にFirestoreのアプリ設定を済ませておくことと[FirebaseCore.initialize]を実行しておきます。
  ///
  /// 基本的にデフォルトの[FirebaseFirestore.instance]が利用されますが、アダプターの作成時に[database]を渡すことで指定されたデータベースを利用することが可能です。
  ///
  /// [options]を渡すことでFirebaseの初期化を行うことができます。
  ///
  /// 内部データベースは[localDatabase]で指定することができます。
  ///
  /// [initialValue]にデータを渡すことで予めデータが入った状態でデータベースを利用することができるためデータモックとして利用することができます。
  ///
  /// [prefix]を追加することですべてのパスにプレフィックスを付与することができ、Flavorごとにデータの保存場所を分けるなどの運用が可能です。
  const ListenableFirestoreModelAdapter({
    this.initialValue,
    FirebaseFirestore? database,
    NoSqlDatabase? localDatabase,
    FirebaseOptions? options,
    this.iosOptions,
    this.androidOptions,
    this.webOptions,
    this.linuxOptions,
    this.windowsOptions,
    this.macosOptions,
    this.prefix,
  })  : _options = options,
        _database = database,
        _localDatabase = localDatabase;

  /// The Firestore database instance used in the adapter.
  ///
  /// アダプター内で利用しているFirestoreのデータベースインスタンス。
  @override
  FirebaseFirestore get database => _database ?? FirebaseFirestore.instance;
  final FirebaseFirestore? _database;

  /// Caches data retrieved from the specified internal database, Firestore.
  ///
  /// 指定の内部データベース。Firestoreから取得したデータをキャッシュします。
  NoSqlDatabase get localDatabase {
    final database = _localDatabase ?? sharedLocalDatabase;
    if (initialValue.isNotEmpty && !database.isInitialValueRegistered) {
      for (final raw in initialValue!) {
        if (raw is ModelInitialDocument) {
          final map = raw.toMap(raw.value);
          database.setInitialValue(
            _path(raw.path),
            raw.filterOnSave(map, raw.value),
          );
        } else if (raw is ModelInitialCollection) {
          for (final tmp in raw.value.entries) {
            final map = raw.toMap(tmp.value);
            database.setInitialValue(
              _path("${raw.path}/${tmp.key}"),
              raw.filterOnSave(map, tmp.value),
            );
          }
        }
      }
    }
    return database;
  }

  final NoSqlDatabase? _localDatabase;

  /// A common internal database throughout the app.
  ///
  /// アプリ内全体での共通の内部データベース。
  static final NoSqlDatabase sharedLocalDatabase = NoSqlDatabase();

  /// Actual data when used as a mock-up.
  ///
  /// モックアップとして利用する際の実データ。
  final List<ModelInitialValue>? initialValue;

  /// A special class can be registered as a [ModelFieldValue] by passing [FirestoreModelFieldValueConverter] to [converter].
  ///
  /// [FirestoreModelFieldValueConverter]を[converter]に渡すことで特殊なクラスを[ModelFieldValue]として登録することができます。
  static void registerConverter(FirestoreModelFieldValueConverter converter) {
    _converters.add(converter);
  }

  /// By passing [FirestoreModelFieldValueConverter] to [converter], you can release an already registered [FirestoreModelFieldValueConverter].
  ///
  /// [converter]に[FirestoreModelFieldValueConverter]を渡すことですでに登録されている[FirestoreModelFieldValueConverter]を解除することができます。
  static void unregisterConverter(FirestoreModelFieldValueConverter converter) {
    _converters.remove(converter);
  }

  static final Set<FirestoreModelFieldValueConverter> _converters = {
    const FirestoreModelCounterConverter(),
    const FirestoreModelTimestampConverter(),
    const FirestoreModelLocaleConverter(),
    const FirestoreModelLocalizedValueConverter(),
    const FirestoreModelUriConverter(),
    const FirestoreModelImageUriConverter(),
    const FirestoreModelVideoUriConverter(),
    const FirestoreModelSearchConverter(),
    const FirestoreModelGeoValueConverter(),
    const FirestoreModelRefConverter(),
    const FirestoreNullConverter(),
    const FirestoreBasicConverter(),
  };

  /// Options for initializing Firebase.
  ///
  /// If platform-specific options are specified, they take precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// プラットフォーム固有のオプションが指定されている場合はそちらが優先されます。
  FirebaseOptions? get options {
    if (UniversalPlatform.isIOS) {
      return iosOptions ?? _options;
    } else if (UniversalPlatform.isAndroid) {
      return androidOptions ?? _options;
    } else if (UniversalPlatform.isWeb) {
      return webOptions ?? _options;
    } else if (UniversalPlatform.isLinux) {
      return linuxOptions ?? _options;
    } else if (UniversalPlatform.isWindows) {
      return windowsOptions ?? _options;
    } else if (UniversalPlatform.isMacOS) {
      return macosOptions ?? _options;
    } else {
      return _options;
    }
  }

  /// Options for initializing Firebase.
  ///
  /// If options for other platforms are specified, these are ignored.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// 他のプラットフォーム用のオプションが指定されている場合はこちらは無視されます。
  final FirebaseOptions? _options;

  /// Options for initializing Firebase.
  ///
  /// Applies to IOS only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// IOSのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? iosOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Android only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Androidのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? androidOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Web only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Webのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? webOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Web only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Webのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? windowsOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to MacOS only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// MacOSのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? macosOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Linux only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Linuxのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? linuxOptions;

  /// Path prefix.
  ///
  /// パスのプレフィックス。
  @override
  final String? prefix;

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    await FirebaseCore.initialize(options: options);
    await _documentReference(query).delete();
    _FirestoreCache.getCache(options).set(_path(query.query.path));
  }

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    await FirebaseCore.initialize(options: options);
    final snapshot = await _documentReference(query).get();
    var res = _convertFrom(snapshot.data()?.cast() ?? {});
    if (res.isEmpty) {
      final localRes =
          await localDatabase.getInitialDocument(query, prefix: prefix);
      if (localRes.isNotEmpty) {
        res = localRes!;
      }
    }
    _FirestoreCache.getCache(options).set(_path(query.query.path), res);
    return res;
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {}

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {}

  @override
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    await FirebaseCore.initialize(options: options);
    final snapshot = await Future.wait<QuerySnapshot<DynamicMap>>(
      _collectionReference(query).map((reference) => reference.get()),
    );
    final res = snapshot.expand((e) => e.docChanges).toMap(
          (e) => MapEntry(e.doc.id, _convertFrom(e.doc.data()?.cast() ?? {})),
        );
    final localRes =
        await localDatabase.getInitialCollection(query, prefix: prefix);
    if (localRes.isNotEmpty) {
      for (final entry in localRes!.entries) {
        if (res.containsKey(entry.key)) {
          continue;
        }
        if (!query.query.hasMatchAsMap(entry.value)) {
          continue;
        }
        res[entry.key] = entry.value;
      }
    }
    for (final doc in res.entries) {
      _FirestoreCache.getCache(options).set(
        "${_path(query.query.path)}/${doc.key}",
        doc.value,
      );
    }
    return res;
  }

  @override
  Future<int> loadCollectionCount(
    ModelAdapterCollectionQuery query, {
    Iterable? retreivedList,
  }) async {
    await FirebaseCore.initialize(options: options);
    final snapshot = await Future.wait<AggregateQuerySnapshot>(
      _collectionReference(query).map((reference) => reference.count().get()),
    );
    final res = snapshot.fold<int>(0, (p, e) => p + e.count);
    return res;
  }

  @override
  Future<void> saveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    await FirebaseCore.initialize(options: options);

    final converted = _convertTo(
      value,
      _FirestoreCache.getCache(options).get(_path(query.query.path)) ?? {},
    );
    await _documentReference(query).set(
      converted,
      SetOptions(merge: true),
    );
    _FirestoreCache.getCache(options).set(
      _path(query.query.path),
      value,
    );
  }

  @override
  bool get availableListen => true;

  @override
  Future<List<StreamSubscription>> listenCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    await FirebaseCore.initialize(options: options);
    final localRes =
        await localDatabase.getInitialCollection(query, prefix: prefix);
    if (localRes.isNotEmpty) {
      for (final entry in localRes!.entries) {
        if (!query.query.hasMatchAsMap(entry.value)) {
          continue;
        }
        query.callback?.call(
          ModelUpdateNotification(
            path: entry.key,
            id: entry.key.last(),
            status: ModelUpdateNotificationStatus.added,
            value: entry.value,
            newIndex: 0,
            origin: query.origin,
            listen: availableListen,
            query: query.query,
          ),
        );
      }
    }
    final streams =
        _collectionReference(query).map((reference) => reference.snapshots());
    final subscriptions = streams.map((e) {
      return e.listen((event) {
        for (final doc in event.docChanges) {
          final path = doc.doc.reference.path;
          final converted = _convertFrom(doc.doc.data()?.cast() ?? {});
          query.callback?.call(
            ModelUpdateNotification(
              path: path,
              id: doc.doc.id,
              status: _status(doc.type),
              value: converted,
              oldIndex: doc.oldIndex,
              newIndex: doc.newIndex,
              origin: query.origin,
              listen: availableListen,
              query: query.query,
            ),
          );
          _FirestoreCache.getCache(options).set(
            _path(query.query.path),
            converted,
          );
        }
      });
    }).toList();
    await Future.wait(streams.map((stream) => stream.first));
    return subscriptions;
  }

  @override
  Future<List<StreamSubscription>> listenDocument(
    ModelAdapterDocumentQuery query,
  ) async {
    await FirebaseCore.initialize(options: options);
    final localRes =
        await localDatabase.getInitialDocument(query, prefix: prefix);
    if (localRes.isNotEmpty) {
      query.callback?.call(
        ModelUpdateNotification(
          path: query.query.path.parentPath(),
          id: query.query.path.last(),
          status: ModelUpdateNotificationStatus.modified,
          value: localRes!,
          origin: query.origin,
          listen: availableListen,
          query: query.query,
        ),
      );
    }
    final stream = _documentReference(query).snapshots();
    // ignore: cancel_subscriptions
    final subscription = stream.listen((doc) {
      final converted = _convertFrom(doc.data()?.cast() ?? {});
      if (converted.isEmpty && localRes.isNotEmpty) {
        return;
      }
      query.callback?.call(
        ModelUpdateNotification(
          path: doc.reference.path,
          id: doc.id,
          status: ModelUpdateNotificationStatus.modified,
          value: converted,
          origin: query.origin,
          listen: availableListen,
          query: query.query,
        ),
      );
      _FirestoreCache.getCache(options).set(
        _path(query.query.path),
        converted,
      );
    });
    await stream.first;
    return [subscription];
  }

  @override
  void deleteOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    if (ref is! ListenableFirestoreModelTransactionRef) {
      throw Exception("[ref] is not [ListenableFirestoreModelTransactionRef].");
    }
    ref._transaction.delete(database.doc(_path(query.query.path)));
    ref._localTransaction.add(() async {
      _FirestoreCache.getCache(options).set(_path(query.query.path));
    });
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) async {
    if (ref is! ListenableFirestoreModelTransactionRef) {
      throw Exception("[ref] is not [ListenableFirestoreModelTransactionRef].");
    }
    final snapshot =
        await ref._transaction.get(database.doc(_path(query.query.path)));
    var res = _convertFrom(snapshot.data() ?? {});
    if (res.isEmpty) {
      final localRes =
          await localDatabase.getInitialDocument(query, prefix: prefix);
      if (localRes.isNotEmpty) {
        res = localRes!;
      }
    }
    _FirestoreCache.getCache(options).set(_path(query.query.path), res);
    return res;
  }

  @override
  void saveOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    if (ref is! ListenableFirestoreModelTransactionRef) {
      throw Exception("[ref] is not [ListenableFirestoreModelTransactionRef].");
    }
    final converted = _convertTo(
      value,
      _FirestoreCache.getCache(options).get(_path(query.query.path)) ?? {},
    );
    ref._transaction.set(
      database.doc(_path(query.query.path)),
      converted,
      SetOptions(merge: true),
    );
    ref._localTransaction.add(() async {
      _FirestoreCache.getCache(options).set(_path(query.query.path), value);
    });
  }

  @override
  FutureOr<void> runTransaction(
    FutureOr<void> Function(
      ModelTransactionRef ref,
    ) transaction,
  ) async {
    await FirebaseCore.initialize(options: options);
    await database.runTransaction((handler) async {
      final ref = ListenableFirestoreModelTransactionRef._(handler);
      await transaction.call(ref);
      for (final tr in ref._localTransaction) {
        await tr.call();
      }
    });
  }

  @override
  void deleteOnBatch(ModelBatchRef ref, ModelAdapterDocumentQuery query) {
    if (ref is! ListenableFirestoreModelBatchRef) {
      throw Exception("[ref] is not [ListenableFirestoreModelBatchRef].");
    }
    ref._localBatch.add(
      _ListenableFirestoreModelBatchItem(
        path: _path(query.query.path),
        actions: () async {
          await localDatabase.deleteDocument(query, prefix: prefix);
          _FirestoreCache.getCache(options).set(_path(query.query.path));
        },
      ),
    );
  }

  @override
  FutureOr<void> runBatch(
    FutureOr<void> Function(
      ModelBatchRef ref,
    ) batch,
    int splitLength,
  ) async {
    assert(
      splitLength > 0 && splitLength <= 500,
      "[splitLength] must be greater than 0 and less than or equal to 500 in Firestore.",
    );
    await FirebaseCore.initialize(options: options);
    final ref = ListenableFirestoreModelBatchRef._();
    await batch.call(ref);
    await wait(
      ref._localBatch.split(splitLength).expand((b) {
        final db = database.batch();
        final actions = <Future<void>>[];
        for (final item in b) {
          if (item.value == null) {
            db.delete(database.doc(item.path));
          } else {
            db.set(
              database.doc(item.path),
              item.value,
              SetOptions(merge: true),
            );
            if (item.actions != null) {
              actions.add(item.actions!());
            }
          }
        }
        return [db.commit(), ...actions];
      }),
    );
  }

  @override
  void saveOnBatch(
    ModelBatchRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    if (ref is! ListenableFirestoreModelBatchRef) {
      throw Exception("[ref] is not [ListenableFirestoreModelBatchRef].");
    }
    final converted = _convertTo(
      value,
      _FirestoreCache.getCache(options).get(_path(query.query.path)) ?? {},
    );
    ref._localBatch.add(
      _ListenableFirestoreModelBatchItem(
        path: _path(query.query.path),
        value: converted,
        actions: () async {
          await localDatabase.saveDocument(query, value, prefix: prefix);
          _FirestoreCache.getCache(options).set(_path(query.query.path), value);
        },
      ),
    );
  }

  DynamicMap _convertFrom(DynamicMap map) {
    final res = <String, dynamic>{};

    for (final tmp in map.entries) {
      final key = tmp.key;
      final val = tmp.value;
      DynamicMap? replaced;
      for (final converter in _converters) {
        replaced = converter.convertFrom(key, val, map, this);
        if (replaced != null) {
          break;
        }
      }
      if (replaced != null) {
        res.addAll(replaced);
      } else {
        res[key] = val;
      }
    }
    return res;
  }

  DynamicMap _convertTo(DynamicMap map, DynamicMap original) {
    final res = <String, dynamic>{};
    for (final tmp in map.entries) {
      final key = tmp.key;
      final val = tmp.value;
      DynamicMap? replaced;
      for (final converter in _converters) {
        replaced = converter.convertTo(key, val, map, this);
        if (replaced != null) {
          break;
        }
      }
      if (replaced != null) {
        res.addAll(replaced);
      } else {
        res[key] = val;
      }
    }
    return res;
  }

  Query<DynamicMap> _query(
    Query<DynamicMap> firestoreQuery,
    ModelAdapterCollectionQuery query,
  ) {
    final filters = query.query.filters;
    for (final filter in filters) {
      for (final converter in _converters) {
        final res = converter.filterQuery(firestoreQuery, filter, query, this);
        if (res != null) {
          firestoreQuery = res;
          break;
        }
      }
    }
    for (final filter in filters) {
      for (final converter in _converters) {
        final res = converter.orderQuery(firestoreQuery, filter, query, this);
        if (res != null) {
          firestoreQuery = res;
          break;
        }
      }
    }
    return firestoreQuery;
  }

  @override
  String _path(String original) {
    if (prefix.isEmpty) {
      return original;
    }
    final p = prefix!.trimQuery().trimString("/");
    final o = original.trimQuery().trimString("/");
    return "$p/$o";
  }

  DocumentReference<DynamicMap> _documentReference(
    ModelAdapterDocumentQuery query,
  ) =>
      database.doc(_path(query.query.path));

  List<Query<DynamicMap>> _collectionReference(
    ModelAdapterCollectionQuery query,
  ) {
    final filters = query.query.filters;
    final containsAny = filters
        .where((e) => e.type == ModelQueryFilterType.arrayContainsAny)
        .toList();
    final whereIn =
        filters.where((e) => e.type == ModelQueryFilterType.whereIn).toList();
    final whereNotIn = filters
        .where((e) => e.type == ModelQueryFilterType.whereNotIn)
        .toList();
    final geoHash =
        filters.where((e) => e.type == ModelQueryFilterType.geoHash).toList();
    assert(
      containsAny.length <= 1,
      "Multiple conditions cannot be defined for `containsAny`.",
    );
    assert(
      whereIn.length <= 1,
      "Multiple conditions cannot be defined for `where`.",
    );
    assert(
      whereNotIn.length <= 1,
      "Multiple conditions cannot be defined for `notWhere`.",
    );
    assert(
      geoHash.length <= 1,
      "Multiple conditions cannot be defined for `geo`.",
    );
    assert(
      containsAny.length +
              whereNotIn.length +
              whereIn.length +
              geoHash.length <=
          1,
      "Only one of `containsAny`, `where`, `notWhere`, or `geo` may be specified. Duplicate conditions cannot be given.",
    );
    if (containsAny.isNotEmpty) {
      final filter = containsAny.first;
      final items = filter.value;
      if (items is List && items.isNotEmpty) {
        for (final conveter in _converters) {
          final res = conveter.collectionQueries(
            items,
            () => _query(
              database.collection(_path(query.query.path)),
              query,
            ),
            filter,
            query,
            this,
          );
          if (res != null) {
            return res;
          }
        }
      }
    } else if (whereIn.isNotEmpty) {
      final filter = whereIn.first;
      final items = filter.value;
      if (items is List && items.isNotEmpty) {
        for (final conveter in _converters) {
          final res = conveter.collectionQueries(
            items,
            () => _query(
              database.collection(_path(query.query.path)),
              query,
            ),
            filter,
            query,
            this,
          );
          if (res != null) {
            return res;
          }
        }
      }
    } else if (whereNotIn.isNotEmpty) {
      final filter = whereNotIn.first;
      final items = filter.value;
      if (items is List && items.isNotEmpty) {
        for (final conveter in _converters) {
          final res = conveter.collectionQueries(
            items,
            () => _query(
              database.collection(_path(query.query.path)),
              query,
            ),
            filter,
            query,
            this,
          );
          if (res != null) {
            return res;
          }
        }
      }
    } else if (geoHash.isNotEmpty) {
      final filter = geoHash.first;
      final items = filter.value;
      if (items is List && items.isNotEmpty) {
        for (final conveter in _converters) {
          final res = conveter.collectionQueries(
            items,
            () => _query(
              database.collection(_path(query.query.path)),
              query,
            ),
            filter,
            query,
            this,
          );
          if (res != null) {
            return res;
          }
        }
      }
    }
    return [
      _query(
        database.collection(_path(query.query.path)),
        query,
      )
    ];
  }

  ModelUpdateNotificationStatus _status(DocumentChangeType type) {
    switch (type) {
      case DocumentChangeType.added:
        return ModelUpdateNotificationStatus.added;
      case DocumentChangeType.modified:
        return ModelUpdateNotificationStatus.modified;
      case DocumentChangeType.removed:
        return ModelUpdateNotificationStatus.removed;
    }
  }
}

@immutable
class ListenableFirestoreModelTransactionRef extends ModelTransactionRef {
  ListenableFirestoreModelTransactionRef._(this._transaction);
  final Transaction _transaction;
  final List<Future<void> Function()> _localTransaction = [];
}

@immutable
class ListenableFirestoreModelBatchRef extends ModelBatchRef {
  ListenableFirestoreModelBatchRef._();
  final List<_ListenableFirestoreModelBatchItem> _localBatch = [];
}

@immutable
class _ListenableFirestoreModelBatchItem {
  const _ListenableFirestoreModelBatchItem({
    required this.path,
    this.value,
    this.actions,
  });
  final String path;
  final DynamicMap? value;
  final Future<void> Function()? actions;
}
