import 'package:flutter/material.dart';
import 'package:flutter_page_kit/flutter_page_kit.dart';

import '../../../i18n/strings.g.dart';
import '../data/project_repository.dart';
import '../domain/project_model.dart';

mixin ProjectFormData<T extends StatefulWidget> on State<T>, PageData<T> {
  ProjectRepository get projectRepository;

  PageNavigator get nav;

  Notices get notices;

  void Function(ProjectModel project)? get onProjectSaved;

  late final name = text(validators: [Validators.required]);
  late final budget = money(100);
  late final due = date(DateTime.now().add(const Duration(days: 14)));

  @override
  List<Validatable> get validated => [name];

  Future<void> submit() async {
    if (!await validateForm()) {
      notices.warn(t.validation.form);
      return;
    }
    await run(
      key: 'save',
      action: () async {
        final draft = ProjectDraft(
          name: name.value.trim(),
          budget: budget.value,
          dueDate: due.value,
        );
        final project = await projectRepository.create(draft);
        onProjectSaved?.call(project);
        notices.success(t.projects.saved);
        nav.pop(project);
      },
    );
    if (failure != null) {
      notices.showFailure(failure);
    }
  }
}
