part of masamune;

const double kMobileBreakPoint = 768;

extension TextEditingControllerExtensions on TextEditingController? {
  bool get isEmpty {
    if (this == null) {
      return true;
    }
    return this!.text.isEmpty;
  }

  bool get isNotEmpty {
    if (this == null) {
      return false;
    }
    return this!.text.isNotEmpty;
  }
}

extension ButtonStyleExtension on ButtonStyle {
  ButtonStyle addState({
    Color? backgroundColor,
    Color? foregroundColor,
    Set<MaterialState> state = const {
      MaterialState.focused,
      MaterialState.hovered,
      MaterialState.pressed,
      MaterialState.selected,
    },
  }) {
    return copyWith(
      backgroundColor: MaterialStateProperty.resolveWith((st) {
        if (st.containsAny(state)) {
          return backgroundColor ?? this.backgroundColor?.resolve(st);
        }
        return this.backgroundColor?.resolve(st);
      }),
      foregroundColor: MaterialStateProperty.resolveWith((st) {
        if (st.containsAny(state)) {
          return foregroundColor ?? this.foregroundColor?.resolve(st);
        }
        return this.foregroundColor?.resolve(st);
      }),
    );
  }
}

extension PlatformBuildContextExtensions on BuildContext {
  bool get isMobile => Config.isMobile;

  bool get isMobileOrSmall {
    if (isMobile) {
      return true;
    }
    return mediaQuery.size.width <= kMobileBreakPoint;
  }

  bool get isDesktop => Config.isDesktop;

  bool get isModal {
    return ModalRoute.of(this) is UIModalRoute;
  }

  bool get isMobileOrModal => isModal || isMobile;

  bool get isFullscreen {
    final parentRoute = ModalRoute.of(this);
    return parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
  }
}

extension NetworkOrAssetDynamicMapExtensions on DynamicMap {
  ImageProvider getAsImage(
    String key, [
    ImageSize size = ImageSize.full,
    String defaultURI = "assets/default.png",
  ]) {
    final uri = get(key, "");
    return NetworkOrAsset.image(uri, size, defaultURI);
  }

  VideoProvider getAsVideo(String key,
      [String defaultURI = "assets/default.mp4"]) {
    final uri = get(key, "");
    return NetworkOrAsset.video(uri, defaultURI);
  }
}

extension ListenableMapListExtensions on List<ListenableMap<String, dynamic>> {
  /// Merge user data for all documents in a particular collection.
  ///
  /// The path to the user collection can be specified in [userCollectionPath].
  ///
  /// By specifying [userKey], a key containing the uid of the user of the original document can be specified.
  ///
  /// [keyPrefix] can be specified to prefix user data keys.
  List<ListenableMap<String, dynamic>> mergeUserInformation(
    WidgetRef ref, {
    String userCollectionPath = "user",
    String userKey = "user",
    String keyPrefix = "user",
  }) {
    final user = ref.watchCollectionModel(
      ModelQuery(
        userCollectionPath,
        key: Const.uid,
        whereIn: map((e) => e.get(userKey, "")).distinct(),
      ).value,
    );
    return setWhereListenable(
      user,
      test: (o, a) => o.get(userKey, "") == a.uid,
      apply: (o, a) =>
          o.mergeListenable(a, convertKeys: (key) => "$keyPrefix$key"),
      orElse: (o) => o,
    ).toList();
  }

  /// Merge other collection data for all documents in a particular collection.
  ///
  /// The path to the other collection can be specified in [collectionPath].
  ///
  /// By specifying [idKey], a key containing the uid of the user of the original document can be specified.
  ///
  /// [keyPrefix] can be specified to prefix user data keys.
  List<ListenableMap<String, dynamic>> mergeDetailInformation(
    WidgetRef ref,
    String collectionPath, {
    String idKey = Const.uid,
    String keyPrefix = "",
  }) {
    final collection = ref.watchCollectionModel(
      ModelQuery(
        collectionPath,
        key: Const.uid,
        whereIn: map((e) => e.get(idKey, "")).distinct(),
      ).value,
    );
    return setWhereListenable(
      collection,
      test: (o, a) => o.get(idKey, "") == a.uid,
      apply: (o, a) =>
          o.mergeListenable(a, convertKeys: (key) => "$keyPrefix$key"),
      orElse: (o) => o,
    ).toList();
  }
}
