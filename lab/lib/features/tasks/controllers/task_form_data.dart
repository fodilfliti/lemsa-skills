import 'package:flutter/material.dart';
import 'package:flutter_page_kit/flutter_page_kit.dart';

import '../../../i18n/strings.g.dart';
import '../data/task_repository.dart';
import '../domain/task_draft.dart';
import '../domain/task_model.dart';

typedef TaskSavedCallback = void Function(TaskModel task);

const int kTitleMinLength = 3;

mixin TaskFormData<T extends StatefulWidget> on State<T>, PageData<T> {
  TaskRepository get taskRepository;

  PageNavigator get nav;

  Notices get notices;

  TaskSavedCallback? get onTaskSaved;

  late final title = text(
    validators: [Validators.required, Validators.minLength(kTitleMinLength)],
  );

  late final titleConfirm = text();

  late final titlesMatch = _TitleConfirmMatch(title, titleConfirm);

  @override
  List<Validatable> get validated => [title, titleConfirm, titlesMatch];

  // Do not override dispose() — PageData owns the field registry.

  Future<void> submit() async {
    if (!await validateForm()) {
      notices.warn(t.validation.form);
      return;
    }
    await run(
      key: 'save',
      action: () async {
        final draft = TaskDraft(title: title.value.trim());
        final task = await taskRepository.create(draft);
        onTaskSaved?.call(task);
        notices.success(t.tasks.saved);
        nav.pop(task);
      },
    );
    if (failure != null) {
      showFailureIfAny();
    }
  }

  void showFailureIfAny() => notices.showFailure(failure);
}

/// Cross-field rule: confirm must equal title. Real apps use this for
/// password/confirm, date ranges, etc.
class _TitleConfirmMatch implements Validatable {
  _TitleConfirmMatch(this.title, this.confirm);

  final FieldText title;
  final FieldText confirm;

  @override
  String? get errorCode {
    if (confirm.value != title.value) {
      return 'passwordMismatch';
    }
    return null;
  }

  @override
  bool get isValid => errorCode == null;
}
