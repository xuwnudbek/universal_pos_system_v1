import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/repositories/users/users_repository.dart';
import 'package:universal_pos_system_v1/utils/functions/local_storage.dart';

class AuthProvider extends ChangeNotifier {
  final UsersRepository usersRepo;

  bool _isAuthorized = false;

  bool get isAuthorized => _isAuthorized;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  set isAuthorized(bool value) {
    _isAuthorized = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set errorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  AuthProvider(this.usersRepo) {
    init();
  }

  Future<void> init() async {
    isLoading = true;

    await checkAuthentication();

    isLoading = false;
  }

  Future<bool> checkAuthentication() async {
    User? user = LocalStorage.getUserSession();
    isAuthorized = user != null;

    return isAuthorized;
  }

  Future<bool> login(
    String username,
    String password,
  ) async {
    User? user = await usersRepo.authenticate(username, password);

    if (user != null) {
      await LocalStorage.saveUserSession(user);
    }

    return await checkAuthentication();
  }

  Future<void> logout() async {
    await LocalStorage.logout();
    isAuthorized = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
