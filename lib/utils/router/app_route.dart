enum AppRoute {
  admin,
  user,
  auth,
  splash,
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
      case AppRoute.admin:
        return 'admin';
      case AppRoute.user:
        return 'user';
      case AppRoute.auth:
        return 'auth';
      case AppRoute.splash:
        return 'splash';
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
      case AppRoute.admin:
        return '/admin';
      case AppRoute.user:
        return '/user';
      case AppRoute.auth:
        return '/auth';
      case AppRoute.splash:
        return '/splash';
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
