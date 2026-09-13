import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_kit/flutter_page_kit.dart';
import 'package:flutter_page_kit/flutter_page_kit_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_scale_theme_kit/flutter_scale_theme_kit.dart';
import 'package:lemsa_core_kit/lemsa_core_kit.dart';

import '../../../core/app_providers.dart';
import '../../../core/failures/failure_text.dart';
import '../../../core/router/app_router.dart';
import '../../../i18n/strings.g.dart';
import '../data/task_repository.dart';
import '../domain/task_extensions.dart';
import '../domain/task_model.dart';
import '../domain/task_with_meta.dart';
import '../state/task_providers.dart';
import '../widgets/task_card.dart';

@RoutePage()
class TaskListPage extends ConsumerStatefulWidget {
  const TaskListPage({super.key});

  @override
  ConsumerState<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends ConsumerState<TaskListPage> {
  final Set<String> _toggling = {};

  Future<void> _sync() async {
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

  Future<void> _toggle(TaskModel task) async {
    if (_toggling.contains(task.id)) {
      return;
    }
    setState(() => _toggling.add(task.id));
    final notices = ref.read(noticesProvider);
    try {
      final updated = await ref.read(taskActionsProvider).toggleDone(task);
      notices.success(
        updated.isDone ? t.tasks.markDone : t.tasks.markPending,
      );
    } on AppFailure catch (e) {
      notices.showFailure(e);
    } catch (_) {
      notices.error(t.errors.unknown);
    } finally {
      if (mounted) {
        setState(() => _toggling.remove(task.id));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskListStreamProvider);
    final sync = ref.watch(taskSyncProvider);
    final nav = ref.read(navigatorProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.tasks.title),
        actions: [
          IconButton(
            tooltip: t.cache.syncNow,
            onPressed: sync.isLoading ? null : _sync,
            icon: sync.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: LemsaLoader(size: 20),
                  )
                : const Icon(Icons.sync),
          ),
          _SyncBadge(snapshot: sync.asData?.value),
          const STThemeModeSwitch(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => nav.push<TaskModel>(AddTaskRoute()),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _sync,
        child: AsyncView<List<TaskWithMeta>>(
          value: tasks,
          error: (f) => Center(child: Text(failureText(f))),
          loading: const LemsaLoader(),
          data: (list) {
            if (list.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.3),
                  Center(child: Text(t.tasks.emptyCache)),
                ],
              );
            }
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = list[index];
                return TaskCard(
                  item: item,
                  busy: _toggling.contains(item.task.id),
                  onToggleDone: () => _toggle(item.task),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _SyncBadge extends StatelessWidget {
  const _SyncBadge({this.snapshot});

  final SyncSnapshot? snapshot;

  @override
  Widget build(BuildContext context) {
    final pending = snapshot?.pendingCount ?? 0;
    if (pending == 0) {
      return const SizedBox.shrink();
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Badge(
          label: Text('$pending'),
          child: const Icon(Icons.sync_problem),
        ),
      ),
    );
  }
}
