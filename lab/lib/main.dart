import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_app_kit/flutter_app_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/app_providers.dart';
import 'core/backend/lab_backend.dart';
import 'core/failures/failure_text.dart';
import 'core/scale/scale_kit.dart';
import 'i18n/strings.g.dart';

Future<void> main() async {
  final backend = LabBackend.current;

  Future<void> Function()? initFirebase;
  Future<void> Function()? initSupabase;

  if (backend == LabBackend.firebase) {
    initFirebase = () async {
      developer.log(
        'Firebase init skipped — add credentials to enable live Firebase',
        name: 'lemsa_lab',
      );
    };
  }
  if (backend == LabBackend.supabase) {
    initSupabase = () async {
      developer.log(
        'Supabase init skipped — set SUPABASE_URL/ANON_KEY in .env to enable',
        name: 'lemsa_lab',
      );
    };
  }

  final boot = await bootstrap(
    AppConfig(
      loadEnv: backend.needsSecrets,
      envOptional: true,
      flavor: AppFlavor.dev,
      failureText: failureText,
      messengerKey: rootScaffoldMessengerKey,
      initFirebase: initFirebase,
      initSupabase: initSupabase,
    ),
  );

  initLabScaleKit();
  LocaleSettings.setLocale(AppLocale.en);

  runApp(
    ProviderScope(
      overrides: [
        noticesProvider.overrideWithValue(boot.notices),
      ],
      child: const LemsaLabApp(),
    ),
  );
}
