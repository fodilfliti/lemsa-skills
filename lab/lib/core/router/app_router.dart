import 'package:auto_route/auto_route.dart';
import 'package:flutter_nav_kit/flutter_nav_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/pages/login_page.dart';
import '../../features/auth/state/session_provider.dart';
import '../../features/home/pages/home_shell_page.dart';
import '../../features/home/pages/profile_page.dart';
import '../../features/inbox/pages/inbox_page.dart';
import '../../features/labels/pages/label_list_page.dart';
import '../../features/projects/pages/add_project_page.dart';
import '../../features/projects/pages/project_list_page.dart';
import '../../features/tasks/pages/add_task_page.dart';
import '../../features/tasks/pages/task_list_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter({required this.isSignedIn});

  final bool Function() isSignedIn;

  AuthGuard get _authGuard => AuthGuard(isSignedIn: isSignedIn);

  GuestGuard get _guestGuard => GuestGuard(isSignedIn: isSignedIn);

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: LoginRoute.page,
          path: '/login',
          initial: true,
          guards: [_guestGuard],
        ),
        AutoRoute(
          page: HomeShellRoute.page,
          path: '/home',
          guards: [_authGuard],
          children: [
            AutoRoute(page: TaskListRoute.page, path: 'tasks', initial: true),
            AutoRoute(page: ProjectListRoute.page, path: 'projects'),
            AutoRoute(page: LabelListRoute.page, path: 'labels'),
            AutoRoute(page: InboxRoute.page, path: 'inbox'),
            AutoRoute(page: ProfileRoute.page, path: 'profile'),
          ],
        ),
        AutoRoute(
          page: AddTaskRoute.page,
          path: '/add-task',
          guards: [_authGuard],
        ),
        AutoRoute(
          page: AddProjectRoute.page,
          path: '/add-project',
          guards: [_authGuard],
        ),
      ];
}

final appRouterProvider = Provider<AppRouter>((ref) {
  return AppRouter(isSignedIn: () => ref.read(sessionProvider) != null);
});
