import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../core/router/app_router.dart';
import '../../../i18n/strings.g.dart';

@RoutePage()
class HomeShellPage extends StatelessWidget {
  const HomeShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        TaskListRoute(),
        ProjectListRoute(),
        LabelListRoute(),
        InboxRoute(),
        ProfileRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return NavigationBar(
          selectedIndex: tabsRouter.activeIndex,
          onDestinationSelected: tabsRouter.setActiveIndex,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.checklist),
              label: t.tabs.tasks,
            ),
            NavigationDestination(
              icon: const Icon(Icons.folder_outlined),
              label: t.tabs.projects,
            ),
            NavigationDestination(
              icon: const Icon(Icons.label_outline),
              label: t.tabs.labels,
            ),
            NavigationDestination(
              icon: const Icon(Icons.inbox_outlined),
              label: t.tabs.inbox,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person),
              label: t.tabs.profile,
            ),
          ],
        );
      },
    );
  }
}
