import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_input_kit/flutter_input_kit.dart';
import 'package:flutter_page_kit/flutter_page_kit.dart' hide Validators;
import 'package:flutter_page_kit/flutter_page_kit_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_scale_kit/flutter_scale_kit.dart';

import '../../../core/app_providers.dart';
import '../../../core/failures/field_error_text.dart';
import '../../../i18n/strings.g.dart';
import '../controllers/project_form_data.dart';
import '../data/project_repository.dart';
import '../domain/project_model.dart';
import '../state/project_providers.dart';

@RoutePage()
class AddProjectPage extends ConsumerStatefulWidget {
  const AddProjectPage({super.key});

  @override
  ConsumerState<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends ConsumerState<AddProjectPage>
    with PageBridge, PageData<AddProjectPage>, ProjectFormData<AddProjectPage> {
  @override
  get pageNavigatorProvider => navigatorProvider;

  @override
  get pageNoticesProvider => noticesProvider;

  @override
  ProjectRepository get projectRepository =>
      ref.read(projectRepositoryProvider);

  @override
  void Function(ProjectModel project)? get onProjectSaved => null;

  @override
  Widget build(BuildContext context) {
    return PageScope(
      data: this,
      child: FormPage(
        title: t.projects.addTitle,
        failure: failure,
        actions: [
          PageAction(
            id: 'save',
            label: t.projects.save,
            isPrimary: true,
            busyKey: 'save',
            onPressed: busy.of('save') ? null : submit,
          ),
        ],
        child: SKit.pad(
          SKSize.md,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InputField(
                spec: FieldSpec(
                  field: name,
                  label: t.projects.nameLabel,
                  showErrors: showFieldErrors,
                  errorText: (code) => fieldErrorText(code) ?? t.validation.form,
                ),
              ),
              SKit.vSpaceSize(SKSize.md),
              MoneyField(
                budget,
                label: t.projects.budgetLabel,
                showErrors: showFieldErrors,
                errorText: (code) => fieldErrorText(code) ?? t.validation.form,
              ),
              SKit.vSpaceSize(SKSize.md),
              DateField(
                due,
                label: t.projects.dueLabel,
                firstDate: DateTime(2020),
                lastDate: DateTime(2035),
                showErrors: showFieldErrors,
                errorText: (code) => fieldErrorText(code) ?? t.validation.form,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
