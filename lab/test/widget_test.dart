import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lemsa_lab/app.dart';
import 'package:lemsa_lab/core/database/lab_database.dart';
import 'package:lemsa_lab/core/scale/scale_kit.dart';
import 'package:lemsa_lab/features/tasks/state/task_providers.dart';
import 'package:lemsa_lab/i18n/strings.g.dart';

void main() {
  setUpAll(() {
    initLabScaleKit();
    LocaleSettings.setLocale(AppLocale.en);
  });

  Future<void> pumpApp(WidgetTester tester, LabDatabase db) {
    return tester.pumpWidget(
      ProviderScope(
        overrides: [labDatabaseProvider.overrideWithValue(db)],
        child: const LemsaLabApp(),
      ),
    );
  }

  testWidgets('LemsaLabApp opens on login', (tester) async {
    final db = LabDatabase.memory();
    addTearDown(db.close);

    await pumpApp(tester, db);
    await tester.pumpAndSettle();
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('demo@lab.dev'), findsOneWidget);
  });

  testWidgets('sign in reaches tasks tab', (tester) async {
    final db = LabDatabase.memory();
    addTearDown(db.close);

    await pumpApp(tester, db);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Tasks'), findsWidgets);
    expect(find.byType(FloatingActionButton), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));
  });

  testWidgets('sign out returns to login', (tester) async {
    final db = LabDatabase.memory();
    addTearDown(db.close);

    await pumpApp(tester, db);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.text('Profile'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text('Sign out'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Sign in'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));
  });
}
