import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_pos_system_v1/pages/admin/admin_page.dart';
import 'package:universal_pos_system_v1/pages/admin/categories/categories_page.dart';
import 'package:universal_pos_system_v1/pages/admin/items/items_page.dart';
import 'package:universal_pos_system_v1/pages/admin/procurements/procurements_page.dart';
import 'package:universal_pos_system_v1/pages/admin/warehouse/warehouse_page.dart';
import 'package:universal_pos_system_v1/pages/splash_page.dart';

enum AppRoute {
  splash,
  home,
  sales,
  items,
  categories,
  warehouse,
  procurement,
  expenses,
  reports,
  users,
  settings,
  backup,
  logout
  ;

  String get name {
    switch (this) {
      case AppRoute.splash:
        return 'splash';
      case AppRoute.home:
        return 'home';
      case AppRoute.items:
        return 'items';
      case AppRoute.sales:
        return 'sales';
      case AppRoute.categories:
        return 'categories';
      case AppRoute.warehouse:
        return 'warehouse';
      case AppRoute.procurement:
        return 'procurement';
      case AppRoute.expenses:
        return 'expenses';
      case AppRoute.reports:
        return 'reports';
      case AppRoute.users:
        return 'users';
      case AppRoute.settings:
        return 'settings';
      case AppRoute.backup:
        return 'backup';
      case AppRoute.logout:
        return 'logout';
    }
  }

  String get path {
    switch (this) {
      case AppRoute.splash:
        return '/splash';
      case AppRoute.home:
        return '/';
      case AppRoute.items:
        return '/items';
      case AppRoute.sales:
        return '/sales';
      case AppRoute.categories:
        return '/categories';
      case AppRoute.warehouse:
        return '/warehouse';
      case AppRoute.procurement:
        return '/procurement';
      case AppRoute.expenses:
        return '/expenses';
      case AppRoute.reports:
        return '/reports';
      case AppRoute.users:
        return '/users';
      case AppRoute.settings:
        return '/settings';
      case AppRoute.backup:
        return '/backup';
      case AppRoute.logout:
        return '/logout';
    }
  }
}

final appRouter = GoRouter(
  observers: [
    // Add observers if needed
  ],
  initialLocation: AppRoute.splash.path,
  routes: [
    GoRoute(
      path: AppRoute.splash.path,
      name: AppRoute.splash.name,
      builder: (_, _) => const SplashPage(),
    ),

    GoRoute(
      path: AppRoute.logout.path,
      name: AppRoute.logout.name,
      builder: (_, _) => const SplashPage(),
    ),

    ShellRoute(
      builder: (context, state, child) {
        return AdminPage(
          state: state,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: AppRoute.home.path,
          name: AppRoute.home.name,
          redirect: (context, state) => AppRoute.sales.path,
          builder: (context, state) {
            return SizedBox.shrink();
          },
        ),
        GoRoute(
          path: AppRoute.sales.path,
          name: AppRoute.sales.name,
          builder: (context, state) {
            return SizedBox.shrink();
            // return SalesPage();
          },
        ),
        GoRoute(
          path: AppRoute.items.path,
          name: AppRoute.items.name,
          builder: (context, state) {
            return ItemsPage();
          },
        ),
        GoRoute(
          path: AppRoute.categories.path,
          name: AppRoute.categories.name,
          builder: (context, state) {
            return CategoriesPage();
          },
        ),
        GoRoute(
          path: AppRoute.warehouse.path,
          name: AppRoute.warehouse.name,
          builder: (context, state) {
            return WarehousePage();
          },
        ),
        GoRoute(
          path: AppRoute.procurement.path,
          name: AppRoute.procurement.name,
          builder: (context, state) {
            return ProcurementsPage();
          },
        ),
        GoRoute(
          path: AppRoute.expenses.path,
          name: AppRoute.expenses.name,
          builder: (context, state) {
            return SizedBox.shrink();
          },
        ),
        GoRoute(
          path: AppRoute.reports.path,
          name: AppRoute.reports.name,
          builder: (context, state) {
            return SizedBox.shrink();
          },
        ),
        GoRoute(
          path: AppRoute.users.path,
          name: AppRoute.users.name,
          builder: (context, state) {
            return SizedBox.shrink();
          },
        ),
        GoRoute(
          path: AppRoute.settings.path,
          name: AppRoute.settings.name,
          builder: (context, state) {
            return SizedBox.shrink();
          },
        ),
        GoRoute(
          path: AppRoute.backup.path,
          name: AppRoute.backup.name,
          builder: (context, state) {
            return SizedBox.shrink();
          },
        ),
      ],
    ),
  ],
);
