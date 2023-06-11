part of masamune_annotation;

/// Ensure that serializable parameters can be successfully serialized to Json.
///
/// When used with `freezed`, the values generated by freezed may not be converted to json.
///
/// Using `@JsonSerializable(explicitToJson: true)` will grant toJson, but it may not work because it is done for all parameters.
/// Therefore, please use this annotation as it will be assigned to a specific parameter.
///
/// If you want to specify the name of the key when Jsonized, specify [name].
///
/// Jsonにシリアライズ可能なパラメーターを正常にシリアライズできるようにします。
///
/// `freezed`で利用する場合、freezedで生成される値がjsonに変換できない場合があります。
///
/// `@JsonSerializable(explicitToJson: true)`を利用するとtoJsonが付与されますが、すべてのパラメーターに対して行われるのでうまく行かない場合があります。
/// そのためこのアノテーションを特定のパラメーターに付与されるためこのアノテーションを利用してください。
///
/// Json化した場合のキーの名前を指定したい場合は[name]を指定します。
///
/// ```dart
/// @freezed
/// @formValue
/// @immutable
/// @CollectionModelPath("shop")
/// class ShopModel with _$ShopModel {
///   const factory ShopModel({
///     @Default("") String name,
///     @Default("") String description,
///     @jsonParam OtherValue? other,
///   }) = _ShopModel;
///   const ShopModel._();
///
///   factory ShopModel.fromJson(Map<String, Object?> json) => _$ShopModelFromJson(json);
///
///   static const document = _$ShopModelDocumentQuery();
///
///   static const collection = _$ShopModelCollectionQuery();
/// }
/// ```
const jsonParam = JsonParam();

/// Ensure that serializable parameters can be successfully serialized to Json.
///
/// When used with `freezed`, the values generated by freezed may not be converted to json.
///
/// Using `@JsonSerializable(explicitToJson: true)` will grant toJson, but it may not work because it is done for all parameters.
/// Therefore, please use this annotation as it will be assigned to a specific parameter.
///
/// If you want to specify the name of the key when Jsonized, specify [name].
///
/// Jsonにシリアライズ可能なパラメーターを正常にシリアライズできるようにします。
///
/// `freezed`で利用する場合、freezedで生成される値がjsonに変換できない場合があります。
///
/// `@JsonSerializable(explicitToJson: true)`を利用するとtoJsonが付与されますが、すべてのパラメーターに対して行われるのでうまく行かない場合があります。
/// そのためこのアノテーションを特定のパラメーターに付与されるためこのアノテーションを利用してください。
///
/// Json化した場合のキーの名前を指定したい場合は[name]を指定します。
///
/// ```dart
/// @freezed
/// @formValue
/// @immutable
/// @CollectionModelPath("shop")
/// class ShopModel with _$ShopModel {
///   const factory ShopModel({
///     @Default("") String name,
///     @Default("") String description,
///     @jsonParam OtherValue? other,
///   }) = _ShopModel;
///   const ShopModel._();
///
///   factory ShopModel.fromJson(Map<String, Object?> json) => _$ShopModelFromJson(json);
///
///   static const document = _$ShopModelDocumentQuery();
///
///   static const collection = _$ShopModelCollectionQuery();
/// }
/// ```
class JsonParam {
  /// Ensure that serializable parameters can be successfully serialized to Json.
  ///
  /// When used with `freezed`, the values generated by freezed may not be converted to json.
  ///
  /// Using `@JsonSerializable(explicitToJson: true)` will grant toJson, but it may not work because it is done for all parameters.
  /// Therefore, please use this annotation as it will be assigned to a specific parameter.
  ///
  /// If you want to specify the name of the key when Jsonized, specify [name].
  ///
  /// Jsonにシリアライズ可能なパラメーターを正常にシリアライズできるようにします。
  ///
  /// `freezed`で利用する場合、freezedで生成される値がjsonに変換できない場合があります。
  ///
  /// `@JsonSerializable(explicitToJson: true)`を利用するとtoJsonが付与されますが、すべてのパラメーターに対して行われるのでうまく行かない場合があります。
  /// そのためこのアノテーションを特定のパラメーターに付与されるためこのアノテーションを利用してください。
  ///
  /// Json化した場合のキーの名前を指定したい場合は[name]を指定します。
  ///
  /// ```dart
  /// @freezed
  /// @formValue
  /// @immutable
  /// @CollectionModelPath("shop")
  /// class ShopModel with _$ShopModel {
  ///   const factory ShopModel({
  ///     @Default("") String name,
  ///     @Default("") String description,
  ///     @jsonParam OtherValue? other,
  ///   }) = _ShopModel;
  ///   const ShopModel._();
  ///
  ///   factory ShopModel.fromJson(Map<String, Object?> json) => _$ShopModelFromJson(json);
  ///
  ///   static const document = _$ShopModelDocumentQuery();
  ///
  ///   static const collection = _$ShopModelCollectionQuery();
  /// }
  /// ```
  const JsonParam({this.name});

  /// Specify the name of the key when Jsonized.
  ///
  /// Json化した場合のキーの名前を指定します。
  final String? name;
}
