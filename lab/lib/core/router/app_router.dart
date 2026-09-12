import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/pages/login_page.dart';
import '../../features/auth/state/session_provider.dart';
import '../../features/home/pages/calendar_page.dart';
import '../../features/home/pages/home_shell_page.dart';
import '../../features/home/pages/profile_page.dart';
import '../../features/home/pages/stats_page.dart';
import '../../features/tasks/pages/add_task_page.dart';
import '../../features/tasks/pages/task_list_page.dart';
import 'guards/auth_guard.dart';
import 'guards/guest_guard.dart';

part 'app_router.gr.dart';

/// Lab uses auto_route 9.x on Dart 3.7; consumer apps target 11.x on FVM 3.35.7.
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter({required this.isSignedIn});

  final bool Function() isSignedIn;

  AuthGuard get _authGuard => AuthGuard(isSignedIn);

  GuestGuard get _guestGuard => GuestGuard(isSignedIn);

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
            AutoRoute(page: CalendarRoute.page, path: 'calendar'),
            AutoRoute(page: StatsRoute.page, path: 'stats'),
            AutoRoute(page: ProfileRoute.page, path: 'profile'),
          ],
        ),
        AutoRoute(
          page: AddTaskRoute.page,
          path: '/add-task',
          guards: [_authGuard],
        ),
      ];
}

final appRouterProvider = Provider<AppRouter>((ref) {
  return AppRouter(isSignedIn: () => ref.read(sessionProvider) != null);
});
