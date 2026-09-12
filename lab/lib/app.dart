import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_scale_kit/flutter_scale_kit.dart';
import 'package:flutter_scale_theme_kit/flutter_scale_theme_kit.dart';

import 'core/auth/session_reevaluate.dart';
import 'core/app_providers.dart';
import 'core/router/app_router.dart';
import 'features/auth/state/session_provider.dart';
import 'features/tasks/state/task_providers.dart';
import 'core/scale/scale_kit.dart';
import 'core/theme/design.dart';
import 'i18n/strings.g.dart';

/// Root widget — matches lemsa.yaml bootstrap order:
/// ProviderScope → ScaleKitBuilder → STThemeModeScope → TranslationProvider → MaterialApp.router
class LemsaLabApp extends ConsumerWidget {
  const LemsaLabApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    ref.watch(sessionReevaluateProvider);

    ref.listen(sessionProvider, (previous, next) {
      if (previous != null && next == null) {
        ref.read(labDatabaseProvider).deleteUserData();
      }
    });

    return ScaleKitBuilder(
      designWidth: labDesignWidth,
      designHeight: labDesignHeight,
      designType: DeviceType.mobile,
      child: Builder(
        builder: (context) {
          return STThemeModeScope(
            builder: (context, mode) {
              return TranslationProvider(
                child: Builder(
                  builder: (context) {
                    return MaterialApp.router(
                      scaffoldMessengerKey: rootScaffoldMessengerKey,
                      title: t.app.title,
                      theme: appST.light.copyWith(
                        textTheme: appST.light.createResponsiveTextTheme(
                          appST.light.textTheme,
                        ),
                      ),
                      darkTheme: appST.dark.copyWith(
                        textTheme: appST.dark.createResponsiveTextTheme(
                          appST.dark.textTheme,
                        ),
                      ),
                      themeMode: mode.mode,
                      routerConfig: router.config(
                        reevaluateListenable: ref.read(sessionReevaluateProvider),
                      ),
                      locale: TranslationProvider.of(context).flutterLocale,
                      supportedLocales: AppLocaleUtils.supportedLocales,
                      localizationsDelegates:
                          GlobalMaterialLocalizations.delegates,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
