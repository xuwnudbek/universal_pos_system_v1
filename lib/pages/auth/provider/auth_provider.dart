import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/data/local/enums/user_roles_enum.dart';
import 'package:universal_pos_system_v1/data/repositories/users/users_repository.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/utils/functions/local_storage.dart';
import 'package:universal_pos_system_v1/utils/router/app_router.dart';

class AuthProvider extends ChangeNotifier {
  final UsersRepository usersRepo;

  User? _currentUser;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider(this.usersRepo) {
    init();
  }

  Future<void> init() async {
    await _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final userId = LocalStorage.getInt('userId');
    if (userId != null) {
      _currentUser = await usersRepo.getById(userId);
      notifyListeners();

      if (_currentUser?.role == UserRolesEnum.admin) {
        appRouter.goNamed(AppRoute.admin.name);
        return;
      } else if (_currentUser?.role == UserRolesEnum.cashier) {
        appRouter.goNamed(AppRoute.user.name);
        return;
      }

      appRouter.goNamed(AppRoute.auth.name);
    }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (username.isEmpty || password.isEmpty) {
        _errorMessage = 'Username va parol kiritilishi shart';
        return false;
      }

      final user = await usersRepo.authenticate(username, password);

      if (user != null) {
        _currentUser = user;
        await LocalStorage.saveUserSession(user);
        return true;
      } else {
        _errorMessage = 'Noto\'g\'ri username yoki parol';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Xatolik yuz berdi: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    await LocalStorage.logout();
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
