import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'nav/auto_page_navigator.dart';
import 'notices/material_notices.dart';
import 'router/app_router.dart';
import '../stubs/notices.dart';
import '../stubs/page_navigator.dart';

/// Root messenger for [MaterialNotices] — set on [MaterialApp.scaffoldMessengerKey].
final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

final navigatorProvider = Provider<PageNavigator>((ref) {
  return AutoPageNavigator(ref.watch(appRouterProvider));
});

final noticesProvider = Provider<Notices>((ref) {
  return MaterialNotices(rootScaffoldMessengerKey);
});
