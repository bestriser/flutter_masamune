part of masamune_deeplink_firebase;

/// Initial setup for handling Deeplink [MasamuneAdapter].
///
/// Deeplinkを取り扱うための初期設定を行う[MasamuneAdapter]。
class FirebaseDeeplinkMasamuneAdapter extends MasamuneAdapter {
  /// Initial setup for handling Deeplink [MasamuneAdapter].
  ///
  /// Deeplinkを取り扱うための初期設定を行う[MasamuneAdapter]。
  const FirebaseDeeplinkMasamuneAdapter({
    this.onLink,
    required this.settings,
    this.deeplink,
    FirebaseOptions? options,
    this.iosOptions,
    this.androidOptions,
    this.webOptions,
    this.windowsOptions,
    this.macosOptions,
    this.linuxOptions,
  }) : _options = options;

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

  /// Callback when the URL is launched.
  ///
  /// URLが起動されたときのコールバック。
  final FutureOr<void> Function(Uri link)? onLink;

  /// Options for handling Deeplink.
  ///
  /// Deeplinkを取り扱うためのオプション。
  final FirebaseDeepLinkSettings settings;

  /// Specify the object of [Deeplink].
  ///
  /// After specifying this, [onMaybeBoot] will automatically start monitoring.
  ///
  /// [Deeplink]のオブジェクトを指定します。
  ///
  /// これを指定した上で[onMaybeBoot]を実行すると自動で監視を開始します。
  final Deeplink? deeplink;

  /// You can retrieve the [FirebaseDeeplinkMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[FirebaseDeeplinkMasamuneAdapter]を取得することができます。
  static FirebaseDeeplinkMasamuneAdapter get primary {
    assert(
      _primary != null,
      "FirebaseDeeplinkMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static FirebaseDeeplinkMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! FirebaseDeeplinkMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<FirebaseDeeplinkMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }

  @override
  FutureOr<void> onMaybeBoot() async {
    await super.onMaybeBoot();
    await deeplink?.listen();
  }
}
