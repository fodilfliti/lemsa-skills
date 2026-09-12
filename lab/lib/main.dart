import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/scale/scale_kit.dart';
import 'i18n/strings.g.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initLabScaleKit();
  LocaleSettings.setLocale(AppLocale.en);
  runApp(const ProviderScope(child: LemsaLabApp()));
}
