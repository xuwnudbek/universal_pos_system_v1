import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/utils/functions/local_storage.dart';
import 'package:universal_pos_system_v1/utils/router/app_route.dart';

AppRoute checkAuthentication() {
  try {
    User? user = LocalStorage.getUserSession();

    switch (user?.role.name) {
      case "admin":
        return AppRoute.admin;
      case "cashier":
        return AppRoute.user;
      default:
        return AppRoute.auth;
    }
  } catch (err) {
    return AppRoute.auth;
  }
}
