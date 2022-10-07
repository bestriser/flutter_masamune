part of katana_model;

/// Builder for transactions.
/// トランザクションを行うためのビルダー。
///
/// The invoked transaction can be `call` as is, and transaction processing can be performed by executing [ModelTransactionDocument.load], [ModelTransactionDocument.save], and [ModelTransactionDocument.delete].
/// 呼び出されたトランザクションはそのまま`call`することができ、その引数から与えられる[ModelTransactionDocument]を用いて[ModelTransactionDocument.load]、[ModelTransactionDocument.save]、[ModelTransactionDocument.delete]を実行することでトランザクション処理を行うことが可能です。
///
/// ModelTransactionRef.read] can be used to create a [ModelTransactionDocument] from another [DocumentBase] and describe the process to be performed together.
/// [ModelTransactionRef.read]を用いて他の[DocumentBase]から[ModelTransactionDocument]を作成することができ、まとめて実行する処理を記述することができます。
///
/// ```dart
/// final transaction = sourceDocument.transaction();
/// transaction((ref, doc){ // `doc`は`sourceDocument`の[ModelTransactionDocument]
///   doc.value = {"name": "test"}; // The same mechanism can be used to perform the same preservation method as usual.
///   doc.save();
/// });
/// ```
class ModelTransactionBuilder<T> {
  ModelTransactionBuilder._(this.document);

  /// Original document.
  /// 元となるドキュメント。
  final DocumentBase<T> document;

  /// [transaction] is passed as a callback to execute the transaction.
  /// [transaction]をコールバックとして渡しトランザクションを実行します。
  FutureOr<void> call(
    FutureOr<void> Function(
      ModelTransactionRef ref,
      ModelTransactionDocument<T> doc,
    )
        transaction,
  ) {
    return document.query.adapter.runTransaction<T>(
      document,
      transaction,
    );
  }
}

/// Reference class for performing transactions.
/// トランザクションを行う際のリファレンスクラス。
///
/// With [read], documents can be converted into transactional objects.
/// [read]でドキュメントをトランザクション用のオブジェクトに変換できます。
@immutable
abstract class ModelTransactionRef {
  /// Reference class for performing transactions.
  /// トランザクションを行う際のリファレンスクラス。
  ///
  /// With [read], documents can be converted into transactional objects.
  /// [read]でドキュメントをトランザクション用のオブジェクトに変換できます。
  const ModelTransactionRef();

  /// You can convert it to a [ModelTransactionDocument] by passing [document].
  /// [document]を渡すことで[ModelTransactionDocument]に変換することができます。
  ///
  /// The converted object can be retrieved, saved, and deleted with [ModelTransactionDocument.load], [ModelTransactionDocument.save], and [ModelTransactionDocument.delete] respectively. delete] to retrieve, save, and delete data, respectively.
  /// 変換されたオブジェクトは[ModelTransactionDocument.load]、[ModelTransactionDocument.save]、[ModelTransactionDocument.delete]でそれぞれデータ取得、保存、削除を行うことができます。
  ModelTransactionDocument<E> read<E>(DocumentBase<E> document) =>
      ModelTransactionDocument<E>._(this, document);

  FutureOr<DynamicMap> _load(DocumentBase document) async {
    return await document.query.adapter.loadOnTransaction(
      this,
      document.databaseQuery,
    );
  }

  FutureOr<void> _delete(DocumentBase document) async {
    await document.query.adapter.deleteOnTransaction(
      this,
      document.databaseQuery,
    );
  }

  FutureOr<void> _save(DocumentBase document, DynamicMap value) {
    return document.query.adapter.saveOnTransaction(
      this,
      document.databaseQuery,
      value,
    );
  }
}

/// Document class for transactions.
/// トランザクション用のドキュメントクラス。
///
/// Load data with [load].
/// [load]でデータをロードします。
///
/// Loaded data can be retrieved with [value].
/// ロードされたデータは[value]で取得することが可能です。
///
/// After replacing [value], the contents of [value] are saved again by executing [save].
/// [value]を置き換えた後[save]を実行することで[value]の内容が再度保存されます。
///
/// [delete] will delete the document.
/// [delete]を実行することでドキュメントが削除されます。
@immutable
class ModelTransactionDocument<T> {
  const ModelTransactionDocument._(
    ModelTransactionRef ref,
    DocumentBase<T> document,
  )   : _ref = ref,
        _document = document;

  final DocumentBase<T> _document;
  final ModelTransactionRef _ref;

  /// Document Value.
  /// ドキュメントの値。
  T? get value => _document.value;

  /// Document Value.
  /// ドキュメントの値。
  set value(T? value) => _document.value = value;

  /// Reads the corresponding document.
  /// 対応したドキュメントの読込を行います。
  ///
  /// The return value is a [T] object, and the loaded data is available as is.
  /// 戻り値は[T]オブジェクトが返され、そのまま読込済みのデータの利用が可能になります。
  ///
  /// The value is stored in [value] and can be retrieved from there.
  /// また[value]に値が保存されているためそこから値を取得することができます。
  FutureOr<T?> load() async {
    final document = _document;
    final res = await _ref._load(document);
    final aaa = await document.filterOnLoad(res);
    value = document.fromMap(aaa);
    return value;
  }

  /// Data can be saved.
  /// データの保存を行うことができます。
  ///
  /// Since it is only the content of [value] that is saved, it is necessary to change the content of [value] before saving.
  /// 保存を行うのはあくまで[value]の中身なので保存を行う前に[value]の中身を変更しておく必要があります。
  ///
  /// It is possible to wait for saving with `await`.
  /// `await`で保存を待つことが可能です。
  FutureOr<void> save() async {
    if (value == null) {
      throw Exception(
        "The value is not set. Please set the value and then execute `save`.",
      );
    }
    final document = _document;
    return _ref._save(
      document,
      await document.filterOnSave(document.toMap(value as T)),
    );
  }

  /// Data can be deleted.
  /// データの削除を行うことができます。
  ///
  /// It is the data in his document that is deleted.
  /// 削除されるのは自身のドキュメントのデータです。
  ///
  /// After deletion, the data is empty, but the object itself is still valid.
  /// 削除後はデータが空になりますが、このオブジェクト自体は有効になっています。
  ///
  /// If the database allows it, the data can be restored by re-entering the data and executing [save].
  /// データベース上可能な場合、再度データを入れ[save]を実行することでデータを復元できます。
  FutureOr<void> delete() async {
    await _ref._delete(_document);
  }
}
