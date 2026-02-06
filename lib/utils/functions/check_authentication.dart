import 'package:universal_pos_system_v1/utils/functions/local_storage.dart';
import 'package:universal_pos_system_v1/utils/router/app_router.dart';

AppRoute checkAuthentication() {
  String? role = LocalStorage.getUserRole();

  switch (role) {
    case "admin":
      return AppRoute.admin;
    case "cashier":
      return AppRoute.user;
    default:
      return AppRoute.auth;
  }
}
