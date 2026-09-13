import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_input_kit/flutter_input_kit.dart';
import 'package:flutter_page_kit/flutter_page_kit.dart' hide Validators;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_scale_kit/flutter_scale_kit.dart';

import '../../../core/app_providers.dart';
import '../../../core/backend/lab_backend.dart';
import '../../../core/failures/field_error_text.dart';
import '../../../i18n/strings.g.dart';
import '../../tasks/state/task_providers.dart';
import '../state/session_provider.dart';

/// Demo login — EmailField + PasswordField (T23 input_kit surface).
@RoutePage()
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with PageData<LoginPage> {
  late final email = text(
    initial: 'demo@lab.dev',
    validators: [Validators.required, Validators.email],
  );
  late final password = text(
    initial: 'demo-pass',
    validators: [Validators.required],
  );
  late final obscure = flag(initial: true);

  @override
  List<Validatable> get validated => [email, password];

  Future<void> _signIn() async {
    if (!await validateForm()) {
      ref.read(noticesProvider).warn(t.validation.form);
      return;
    }
    await run(
      key: 'signIn',
      action: () async {
        ref.read(sessionProvider.notifier).signIn(email.value.trim());
        ref.read(navigatorProvider).replaceNamed('/home');
        await ref.read(taskSyncProvider.notifier).syncNow();
      },
    );
    if (failure != null) {
      ref.read(noticesProvider).showFailure(failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    final signingIn = busy.of('signIn');

    return PageScope(
      data: this,
      child: FormPage(
        title: t.auth.title,
        failure: failure,
        actions: [
          PageAction(
            id: 'signIn',
            label: t.auth.signIn,
            isPrimary: true,
            busyKey: 'signIn',
            onPressed: signingIn ? null : _signIn,
          ),
        ],
        child: SKit.pad(
          SKSize.lg,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                t.auth.backendLabel(backend: LabBackend.current.name),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SKit.vSpaceSize(SKSize.md),
              EmailField(
                email,
                label: t.auth.emailLabel,
                showErrors: showFieldErrors,
                errorText: (code) => fieldErrorText(code) ?? t.validation.form,
                enabled: !signingIn,
              ),
              SKit.vSpaceSize(SKSize.md),
              PasswordField(
                password,
                obscure: obscure,
                label: t.auth.passwordLabel,
                showErrors: showFieldErrors,
                errorText: (code) => fieldErrorText(code) ?? t.validation.form,
                enabled: !signingIn,
                textInputAction: TextInputAction.done,
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
