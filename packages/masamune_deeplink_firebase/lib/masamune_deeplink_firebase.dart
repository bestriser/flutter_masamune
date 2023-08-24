// Copyright 2023 mathru. All rights reserved.

/// Masamune plugin library for using Firebase DynamicLinks to launch applications from URLs and launch internal pages.
///
/// To use, import `package:masamune_deeplink_firebase/masamune_deeplink_firebase.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_deeplink_firebase;

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:masamune/masamune.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:katana_firebase/katana_firebase.dart';

export 'package:firebase_dynamic_links/firebase_dynamic_links.dart'
    show
        DynamicLinkParameters,
        AndroidParameters,
        GoogleAnalyticsParameters,
        IOSParameters,
        ITunesConnectAnalyticsParameters,
        NavigationInfoParameters,
        SocialMetaTagParameters;

part 'adapter/firebase_deeplink_masamune_adapter.dart';
part 'src/deeplink.dart';
part 'src/firebase_deep_link_settings.dart';
