import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/utils/functions/local_storage.dart';

import '../../data/local/enums/user_roles_enum.dart';
import '../../pages/admin/admin_page.dart';
import '../../pages/admin/categories/categories_page.dart';
import '../../pages/admin/expenses/expenses_page.dart';
import '../../pages/admin/items/items_page.dart';
import '../../pages/admin/procurements/procurements_page.dart';
import '../../pages/admin/reports/reports_page.dart';
import '../../pages/admin/settings/settings_page.dart';
import '../../pages/admin/backup/backup_page.dart';
import '../../pages/admin/users/users_page.dart';
import '../../pages/admin/warehouse/warehouse_page.dart';
import '../../pages/auth/auth_page.dart';
import '../../pages/auth/provider/auth_provider.dart';
import '../../pages/splash/splash_page.dart';
import '../../pages/user/user_page.dart';
import '../../utils/router/app_route.dart';

CustomTransitionPage _rightToLeftTransition({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 100),
    reverseTransitionDuration: const Duration(milliseconds: 100),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation =
          Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          );
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

GoRouter appRouter(AuthProvider authProvider) => GoRouter(
  initialLocation: AppRoute.splash.path,
  refreshListenable: authProvider,
  redirect: (context, state) {
    final bool isAuth = context.read<AuthProvider>().isAuthorized;

    // Agar splash sahifasida bo'lsa, u yerda qolish
    if (state.matchedLocation == AppRoute.splash.path) {
      return null;
    }

    if (!isAuth) {
      return AppRoute.auth.path;
    }

    // Agar loginda bo'lsa va authorized bo'lsa, role asosida yo'naltir
    if (state.matchedLocation == AppRoute.auth.path && isAuth) {
      final userRole = LocalStorage.getUserRole();

      if (userRole != null) {
        try {
          final role = UserRolesEnum.fromString(userRole);
          if (role == UserRolesEnum.admin) {
            return AppRoute.admin.path;
          } else if (role == UserRolesEnum.cashier) {
            return AppRoute.user.path;
          }
        } catch (e) {
          // Agar role xato bo'lsa, auth sahifasiga qaytar
          return AppRoute.auth.path;
        }
      }
    }

    return null;
  },
  routes: [
    // Splash route
    GoRoute(
      path: AppRoute.splash.path,
      name: AppRoute.splash.name,
      builder: (_, _) => const SplashPage(),
    ),

    // Authentication route
    GoRoute(
      path: AppRoute.auth.path,
      name: AppRoute.auth.name,
      builder: (_, _) => const AuthPage(),
    ),

    // Logout route
    GoRoute(
      path: AppRoute.logout.path,
      name: AppRoute.logout.name,
      builder: (_, _) => const SplashPage(),
    ),

    // User route with nested routes
    GoRoute(
      path: AppRoute.user.path,
      name: AppRoute.user.name,
      builder: (_, _) => UserPage(),
    ),

    // Admin route with nested routes
    ShellRoute(
      builder: (context, state, child) {
        return AdminPage(child: child);
      },
      routes: [
        GoRoute(
          path: AppRoute.admin.path,
          name: AppRoute.admin.name,
          redirect: (_, _) => AppRoute.reports.path,
        ),
        GoRoute(
          path: AppRoute.items.path,
          name: AppRoute.items.name,
          pageBuilder: (context, state) {
            return _rightToLeftTransition(state: state, child: ItemsPage());
          },
        ),
        GoRoute(
          path: AppRoute.categories.path,
          name: AppRoute.categories.name,
          pageBuilder: (context, state) {
            return _rightToLeftTransition(state: state, child: CategoriesPage());
          },
        ),
        GoRoute(
          path: AppRoute.warehouse.path,
          name: AppRoute.warehouse.name,
          pageBuilder: (context, state) {
            return _rightToLeftTransition(state: state, child: WarehousePage());
          },
        ),
        GoRoute(
          path: AppRoute.procurement.path,
          name: AppRoute.procurement.name,
          pageBuilder: (context, state) {
            return _rightToLeftTransition(state: state, child: ProcurementsPage());
          },
        ),
        GoRoute(
          path: AppRoute.expenses.path,
          name: AppRoute.expenses.name,
          pageBuilder: (context, state) {
            return _rightToLeftTransition(state: state, child: ExpensesPage());
          },
        ),
        GoRoute(
          path: AppRoute.reports.path,
          name: AppRoute.reports.name,
          pageBuilder: (context, state) {
            return _rightToLeftTransition(state: state, child: ReportsPage());
          },
        ),
        GoRoute(
          path: AppRoute.users.path,
          name: AppRoute.users.name,
          pageBuilder: (context, state) {
            return _rightToLeftTransition(state: state, child: UsersPage());
          },
        ),
        GoRoute(
          path: AppRoute.settings.path,
          name: AppRoute.settings.name,
          pageBuilder: (context, state) {
            return _rightToLeftTransition(state: state, child: SettingsPage());
          },
        ),
        GoRoute(
          path: AppRoute.backup.path,
          name: AppRoute.backup.name,
          pageBuilder: (context, state) {
            return _rightToLeftTransition(state: state, child: BackupPage());
          },
        ),
      ],
    ),
  ],
);
