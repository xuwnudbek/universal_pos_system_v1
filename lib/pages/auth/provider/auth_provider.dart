import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/data/repositories/users/users_repository.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/utils/functions/local_storage.dart';

class AuthProvider extends ChangeNotifier {
  final UsersRepository usersRepo;

  User? _currentUser;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider(this.usersRepo);

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
        await LocalStorage.setObject('currentUser', user.toJson());
        await LocalStorage.setInt('userId', user.id);
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
    await LocalStorage.remove('currentUser');
    await LocalStorage.remove('userId');
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
