import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_kit/flutter_data_kit.dart';
import 'package:flutter_page_kit/flutter_page_kit.dart';
import 'package:flutter_page_kit/flutter_page_kit_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_scale_kit/flutter_scale_kit.dart';
import 'package:lemsa_core_kit/lemsa_core_kit.dart';

import '../../../core/app_providers.dart';
import '../../../core/failures/failure_text.dart';
import '../../../core/router/app_router.dart';
import '../../../i18n/strings.g.dart';
import '../domain/project_model.dart';
import '../state/project_providers.dart';

@RoutePage()
class ProjectListPage extends ConsumerWidget {
  const ProjectListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(projectListProvider);
    final notifier = ref.read(projectListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.projects.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => notifier.refresh(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created =
              await ref.read(navigatorProvider).push<ProjectModel>(
                    const AddProjectRoute(),
                  );
          if (created != null) {
            notifier.upsert(created);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: AsyncView<PagedState<ProjectModel>>(
        value: async,
        error: (failure) => Center(child: Text(failureText(failure))),
        data: (state) {
          if (state.items.isEmpty) {
            return Center(child: Text(t.projects.empty));
          }
          return RefreshIndicator(
            onRefresh: notifier.refresh,
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: state.items.length + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.items.length) {
                  return Padding(
                    padding: EdgeInsets.all(16.h),
                    child: Center(
                      child: state.isLoadingMore
                          ? const LemsaLoader()
                          : TextButton(
                              onPressed: notifier.loadMore,
                              child: Text(t.projects.loadMore),
                            ),
                    ),
                  );
                }
                final project = state.items[index];
                return ListTile(
                  title: Text(project.name),
                  subtitle: Text(
                    t.projects.budgetLine(amount: project.budget.toString()),
                  ),
                  trailing: project.dueDate == null
                      ? null
                      : Text(project.dueDate!.toDate.toString().split(' ').first),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
