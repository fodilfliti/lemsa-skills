import 'package:flutter/material.dart';
import 'package:flutter_app_kit/flutter_app_kit.dart';
import 'package:lemsa_nav_kit/lemsa_nav_kit.dart';
import 'package:flutter_page_kit/flutter_page_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'failures/failure_text.dart';
import 'router/app_router.dart';

/// Root messenger for [MaterialNotices] — set on [MaterialApp.scaffoldMessengerKey].
final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

final navigatorProvider = Provider<PageNavigator>((ref) {
  return AutoPageNavigator(ref.watch(appRouterProvider));
});

final noticesProvider = Provider<Notices>((ref) {
  return MaterialNotices(
    messengerKey: rootScaffoldMessengerKey,
    failureText: failureText,
  );
});
