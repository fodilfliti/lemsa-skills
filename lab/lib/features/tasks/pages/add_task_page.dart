import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_kit/flutter_page_kit.dart';
import 'package:flutter_page_kit/flutter_page_kit_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_scale_kit/flutter_scale_kit.dart';

import '../../../core/app_providers.dart';
import '../../../core/failures/field_error_text.dart';
import '../../../i18n/strings.g.dart';
import '../controllers/task_form_data.dart';
import '../data/task_repository.dart';
import '../domain/task_model.dart';
import '../state/task_providers.dart';

@RoutePage()
class AddTaskPage extends ConsumerStatefulWidget {
  const AddTaskPage({super.key});

  @override
  ConsumerState<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends ConsumerState<AddTaskPage>
    with PageBridge, PageData<AddTaskPage>, TaskFormData<AddTaskPage> {
  @override
  get pageNavigatorProvider => navigatorProvider;

  @override
  get pageNoticesProvider => noticesProvider;

  @override
  TaskRepository get taskRepository => ref.read(taskRepositoryProvider);

  @override
  void Function(TaskModel task)? get onTaskSaved => null;

  @override
  Widget build(BuildContext context) {
    final saving = busy.of('save');

    return PageScope(
      data: this,
      child: FormPage(
        title: t.tasks.addTitle,
        failure: failure,
        actions: [
          PageAction(
            id: 'save',
            label: t.tasks.save,
            isPrimary: true,
            busyKey: 'save',
            onPressed: saving ? null : submit,
          ),
        ],
        child: SKit.pad(
          SKSize.md,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const Key('title'),
                controller: title.controller,
                decoration: InputDecoration(
                  labelText: t.tasks.titleLabel,
                  errorText: showFieldErrors
                      ? fieldErrorText(title.errorCode, n: kTitleMinLength)
                      : null,
                ),
                enabled: !saving,
                textInputAction: TextInputAction.next,
              ),
              SKit.vSpaceSize(SKSize.md),
              TextField(
                key: const Key('titleConfirm'),
                controller: titleConfirm.controller,
                decoration: InputDecoration(
                  labelText: t.tasks.titleConfirmLabel,
                  errorText: showFieldErrors
                      ? fieldErrorText(
                          titleConfirm.errorCode ?? titlesMatch.errorCode,
                        )
                      : null,
                ),
                enabled: !saving,
                textInputAction: TextInputAction.done,
                onSubmitted: saving ? null : (_) => submit(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
