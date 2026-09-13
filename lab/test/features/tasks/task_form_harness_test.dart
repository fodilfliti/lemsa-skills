import 'package:flutter/material.dart';
import 'package:flutter_page_kit/flutter_page_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemsa_core_kit/lemsa_core_kit.dart';

import 'package:lemsa_lab/core/failures/field_error_text.dart';
import 'package:lemsa_lab/features/tasks/controllers/task_form_data.dart';
import 'package:lemsa_lab/features/tasks/data/sources/mock_task_source.dart';
import 'package:lemsa_lab/features/tasks/data/task_repository.dart';
import 'package:lemsa_lab/features/tasks/domain/task_model.dart';
import 'package:lemsa_lab/features/tasks/domain/task_query.dart';
import 'package:lemsa_lab/i18n/strings.g.dart';

void main() {
  setUpAll(() => LocaleSettings.setLocale(AppLocale.en));

  testWidgets('TaskFormData submit persists via repository', (tester) async {
    final source = MockTaskSource(delay: Duration.zero);
    final repo = TaskRepositoryImpl(source);
    TaskModel? saved;
    final nav = _RecordingNav();
    final notices = _RecordingNotices();
    final key = GlobalKey<_HarnessState>();

    await PageHarness.mount(
      pumpWidget: tester.pumpWidget,
      host: _Harness(
        key: key,
        repository: repo,
        nav: nav,
        notices: notices,
        onSaved: (task) => saved = task,
      ),
      key: key,
    );

    await tester.enterText(find.byKey(const Key('title')), 'New lab task');
    await tester.enterText(
      find.byKey(const Key('titleConfirm')),
      'New lab task',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(saved?.title, 'New lab task');
    expect(nav.popped?.title, 'New lab task');
    final list = await source.list(const TaskQuery());
    expect(list.any((t) => t.title == 'New lab task'), isTrue);
  });

  testWidgets('empty title blocked with required errorText', (tester) async {
    final source = MockTaskSource(delay: Duration.zero);
    final repo = TaskRepositoryImpl(source);
    TaskModel? saved;
    final key = GlobalKey<_HarnessState>();

    final harness = await PageHarness.mount(
      pumpWidget: tester.pumpWidget,
      host: _Harness(
        key: key,
        repository: repo,
        nav: _RecordingNav(),
        notices: _RecordingNotices(),
        onSaved: (task) => saved = task,
      ),
      key: key,
    );

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(saved, isNull);
    expect(harness.controller.title.errorCode, 'required');
    expect(harness.controller.busy.of('save'), isFalse);
    expect(find.text('Required'), findsWidgets);
  });

  testWidgets('too-short title blocked with minLength errorText',
      (tester) async {
    final key = GlobalKey<_HarnessState>();
    TaskModel? saved;

    final harness = await PageHarness.mount(
      pumpWidget: tester.pumpWidget,
      host: _Harness(
        key: key,
        repository: TaskRepositoryImpl(MockTaskSource(delay: Duration.zero)),
        nav: _RecordingNav(),
        notices: _RecordingNotices(),
        onSaved: (task) => saved = task,
      ),
      key: key,
    );

    await tester.enterText(find.byKey(const Key('title')), 'ab');
    await tester.enterText(find.byKey(const Key('titleConfirm')), 'ab');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(saved, isNull);
    expect(harness.controller.title.errorCode, 'minLength');
    expect(find.text('At least 3 characters'), findsOneWidget);
  });

  testWidgets('mismatch confirm blocked with passwordMismatch', (tester) async {
    final key = GlobalKey<_HarnessState>();
    TaskModel? saved;

    final harness = await PageHarness.mount(
      pumpWidget: tester.pumpWidget,
      host: _Harness(
        key: key,
        repository: TaskRepositoryImpl(MockTaskSource(delay: Duration.zero)),
        nav: _RecordingNav(),
        notices: _RecordingNotices(),
        onSaved: (task) => saved = task,
      ),
      key: key,
    );

    await tester.enterText(find.byKey(const Key('title')), 'hello');
    await tester.enterText(find.byKey(const Key('titleConfirm')), 'world');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(saved, isNull);
    expect(harness.controller.titlesMatch.errorCode, 'passwordMismatch');
    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('busy.of(save) is independent and shows LemsaLoader',
      (tester) async {
    final source = MockTaskSource(delay: const Duration(milliseconds: 80));
    final repo = TaskRepositoryImpl(source);
    final key = GlobalKey<_HarnessState>();

    final harness = await PageHarness.mount(
      pumpWidget: tester.pumpWidget,
      host: _Harness(
        key: key,
        repository: repo,
        nav: _RecordingNav(),
        notices: _RecordingNotices(),
        onSaved: (_) {},
      ),
      key: key,
    );

    await tester.enterText(find.byKey(const Key('title')), 'Slow save');
    await tester.enterText(find.byKey(const Key('titleConfirm')), 'Slow save');
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(harness.controller.busy.of('save'), isTrue);
    expect(harness.controller.busy.of('delete'), isFalse);
    expect(find.byType(LemsaLoader), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byKey(const Key('title'))).enabled,
      isFalse,
    );
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    expect(
      tester.widget<PopScope<Object?>>(find.byType(PopScope)).canPop,
      isFalse,
    );

    await tester.pump(const Duration(milliseconds: 80));
    await tester.pump();
    expect(harness.controller.busy.of('save'), isFalse);
    expect(
      tester.widget<TextField>(find.byKey(const Key('title'))).enabled,
      isTrue,
    );
    expect(
      tester.widget<PopScope<Object?>>(find.byType(PopScope)).canPop,
      isTrue,
    );
  });

  testWidgets('flag() checkbox updates without a hand-owned notifier',
      (tester) async {
    final key = GlobalKey<_HarnessState>();
    final harness = await PageHarness.mount(
      pumpWidget: tester.pumpWidget,
      host: _Harness(
        key: key,
        repository: TaskRepositoryImpl(MockTaskSource(delay: Duration.zero)),
        nav: _RecordingNav(),
        notices: _RecordingNotices(),
        onSaved: (_) {},
      ),
      key: key,
    );

    expect(harness.controller.urgent.value, isFalse);
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(harness.controller.urgent.value, isTrue);
  });

  testWidgets('LemsaLoader renders', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: LemsaLoader())),
    );
    expect(find.byType(LemsaLoader), findsOneWidget);
  });
}

class _Harness extends StatefulWidget {
  const _Harness({
    super.key,
    required this.repository,
    required this.nav,
    required this.notices,
    required this.onSaved,
  });

  final TaskRepository repository;
  final PageNavigator nav;
  final Notices notices;
  final void Function(TaskModel task) onSaved;

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness>
    with PageData<_Harness>, TaskFormData<_Harness> {
  late final urgent = flag();

  @override
  TaskRepository get taskRepository => widget.repository;

  @override
  PageNavigator get nav => widget.nav;

  @override
  Notices get notices => widget.notices;

  @override
  void Function(TaskModel task)? get onTaskSaved => widget.onSaved;

  @override
  Widget build(BuildContext context) {
    final saving = busy.of('save');
    return PopScope(
      canPop: !saving,
      child: Scaffold(
        body: Column(
          children: [
            TextField(
              key: const Key('title'),
              controller: title.controller,
              enabled: !saving,
              decoration: InputDecoration(
                errorText: showFieldErrors
                    ? fieldErrorText(title.errorCode, n: kTitleMinLength)
                    : null,
              ),
              textInputAction: TextInputAction.next,
            ),
            TextField(
              key: const Key('titleConfirm'),
              controller: titleConfirm.controller,
              enabled: !saving,
              decoration: InputDecoration(
                errorText: showFieldErrors
                    ? fieldErrorText(
                        titleConfirm.errorCode ?? titlesMatch.errorCode,
                      )
                    : null,
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: saving ? null : (_) => submit(),
            ),
            CheckboxListTile(
              title: const Text('Urgent'),
              value: urgent.value,
              onChanged: saving
                  ? null
                  : (value) => setState(() => urgent.value = value ?? false),
            ),
            if (saving) const LemsaLoader(),
            FilledButton(
              onPressed: saving ? null : submit,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordingNav implements PageNavigator {
  TaskModel? popped;

  @override
  bool get canPop => true;

  @override
  void pop<R>([R? result]) {
    popped = result as TaskModel?;
  }

  @override
  Future<R?> push<R>(Object route) async => null;

  @override
  void replaceAll(List<Object> routes) {}

  @override
  void replaceNamed(String path) {}
}

class _RecordingNotices implements Notices {
  String? lastError;

  @override
  void error(String message) => lastError = message;

  @override
  void info(String message) {}

  @override
  void showFailure(AppFailure? failure) {}

  @override
  void success(String message) {}

  @override
  void warn(String message) {}
}
