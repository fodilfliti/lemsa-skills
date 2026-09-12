import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_providers.dart';
import '../../../i18n/strings.g.dart';
import '../state/session_provider.dart';
import '../../tasks/state/task_providers.dart';

/// Demo login — prefilled email, mock sign-in (S09).
@RoutePage()
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  static const _demoEmail = 'demo@lab.dev';

  late final TextEditingController _emailController =
      TextEditingController(text: _demoEmail);

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ref.read(noticesProvider).error(t.auth.emailRequired);
      return;
    }
    ref.read(sessionProvider.notifier).signIn(email);
    ref.read(navigatorProvider).replaceNamed('/home');
    await ref.read(taskSyncProvider.notifier).syncNow();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.auth.title)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: t.auth.emailLabel),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _signIn(),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _signIn,
              child: Text(t.auth.signIn),
            ),
          ],
        ),
      ),
    );
  }
}
