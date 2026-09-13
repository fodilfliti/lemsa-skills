import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemsa_core_kit/lemsa_core_kit.dart';

import '../../../core/app_providers.dart';
import '../../../core/backend/lab_backend.dart';
import '../../../i18n/strings.g.dart';
import '../../auth/state/session_provider.dart';
import '../../tasks/state/task_providers.dart';

@RoutePage()
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  Future<void> _sync(WidgetRef ref) async {
    final notices = ref.read(noticesProvider);
    try {
      final snapshot = await ref.read(taskSyncProvider.notifier).syncNow();
      if (snapshot.offline) {
        notices.warn(t.cache.syncOffline);
      } else {
        notices.success(
          t.cache.syncOk(
            pulled: snapshot.pulledCount,
            flushed: snapshot.flushedCount,
            pending: snapshot.pendingCount,
          ),
        );
      }
    } on AppFailure catch (e) {
      notices.showFailure(e);
    } catch (_) {
      notices.error(t.errors.unknown);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final offline = ref.watch(offlineModeProvider);
    final flaky = ref.watch(flakyApiProvider);
    final sync = ref.watch(taskSyncProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.tabs.profile)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (session != null) Text(t.auth.signedInAs(email: session.email)),
          Text(t.auth.backendLabel(backend: LabBackend.current.name)),
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text(t.cache.simulateOffline),
            subtitle: Text(t.cache.simulateOfflineHint),
            value: offline,
            onChanged: (v) {
              ref.read(offlineModeProvider.notifier).set(v);
              if (v) {
                ref.read(flakyApiProvider.notifier).set(false);
              }
            },
          ),
          SwitchListTile(
            title: Text(t.cache.flakyApi),
            subtitle: Text(t.cache.flakyApiHint),
            value: flaky,
            onChanged: offline
                ? null
                : (v) => ref.read(flakyApiProvider.notifier).set(v),
          ),
          ListTile(
            title: Text(t.cache.failNext),
            subtitle: Text(t.cache.failNextHint),
            trailing: const Icon(Icons.flash_on),
            onTap: () {
              ref.read(mockTaskSourceProvider).failNext = true;
              ref.read(noticesProvider).warn(t.cache.failNextHint);
            },
          ),
          ListTile(
            title: Text(t.cache.syncNow),
            subtitle: sync.when(
              data: (s) => Text(
                t.cache.syncStatus(
                  pending: s.pendingCount,
                  pulled: s.pulledCount,
                  flushed: s.flushedCount,
                ),
              ),
              loading: () => Text(t.cache.syncing),
              error: (_, __) => Text(t.errors.unknown),
            ),
            trailing: sync.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : IconButton(
                    icon: const Icon(Icons.sync),
                    onPressed: () => _sync(ref),
                  ),
          ),
          const SizedBox(height: 24),
          FilledButton.tonal(
            onPressed: () => ref.read(sessionProvider.notifier).signOut(),
            child: Text(t.auth.signOut),
          ),
        ],
      ),
    );
  }
}
