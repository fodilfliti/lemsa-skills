import 'package:flutter/material.dart';
import 'package:flutter_page_kit/flutter_page_kit.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lemsa_lab/features/projects/controllers/project_form_data.dart';
import 'package:lemsa_lab/features/projects/data/project_repository.dart';
import 'package:lemsa_lab/features/projects/data/sources/mock_project_source.dart';
import 'package:lemsa_lab/features/projects/domain/project_model.dart';
import 'package:lemsa_lab/i18n/strings.g.dart';

void main() {
  setUpAll(() => LocaleSettings.setLocale(AppLocale.en));

  test('MockProjectSource pages results', () async {
    final source = MockProjectSource();
    final first = await source.fetch(const ProjectQuery(page: 1, pageSize: 10));
    expect(first.items.length, 10);
    expect(first.hasMore, isTrue);
    final second =
        await source.fetch(const ProjectQuery(page: 2, pageSize: 10));
    expect(second.items, isNotEmpty);
  });

  testWidgets('ProjectFormData create via harness', (tester) async {
    final repo = ProjectRepositoryImpl(MockProjectSource());
    ProjectModel? saved;
    final key = GlobalKey<_HarnessState>();

    await PageHarness.mount(
      pumpWidget: tester.pumpWidget,
      host: _Harness(
        key: key,
        repository: repo,
        nav: _Nav(),
        notices: const NoOpNotices(),
        onSaved: (p) => saved = p,
      ),
      key: key,
    );

    await tester.enterText(find.byType(TextField).first, 'Portfolio demo');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(saved?.name, 'Portfolio demo');
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

  final ProjectRepository repository;
  final PageNavigator nav;
  final Notices notices;
  final void Function(ProjectModel) onSaved;

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness>
    with PageData<_Harness>, ProjectFormData<_Harness> {
  @override
  ProjectRepository get projectRepository => widget.repository;

  @override
  PageNavigator get nav => widget.nav;

  @override
  Notices get notices => widget.notices;

  @override
  void Function(ProjectModel project)? get onProjectSaved => widget.onSaved;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(controller: name.controller),
          FilledButton(onPressed: submit, child: const Text('Save')),
        ],
      ),
    );
  }
}

class _Nav implements PageNavigator {
  @override
  bool get canPop => true;

  @override
  void pop<R>([R? result]) {}

  @override
  Future<R?> push<R>(Object route) async => null;

  @override
  void replaceAll(List<Object> routes) {}

  @override
  void replaceNamed(String path) {}
}
