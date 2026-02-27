import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/local/enums/user_roles_enum.dart';
import 'package:universal_pos_system_v1/data/repositories/users/users_repository.dart';

class UsersProvider extends ChangeNotifier {
  final UsersRepository _usersRepo;

  List<User> _users = [];
  List<User> get users => _users;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  UsersProvider(this._usersRepo) {
    _init();
  }

  Future<void> _init() async {
    try {
      await loadUsers();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing users: $e');
    }
  }

  Future<void> loadUsers() async {
    try {
      _users = await _usersRepo.getAll();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading users: $e');
      rethrow;
    }
  }

  Future<void> addUser({
    required String fullName,
    required String username,
    required String password,
    required UserRolesEnum role,
  }) async {
    try {
      await _usersRepo.create(
        fullName: fullName,
        username: username,
        password: password,
        role: role,
      );
      await loadUsers();
    } catch (e) {
      debugPrint('Error adding user: $e');
      rethrow;
    }
  }

  Future<void> updateUser({
    required int id,
    required String fullName,
    required String username,
    required String password,
    required UserRolesEnum role,
    required bool isActive,
    bool isPasswordHashed = false,
  }) async {
    try {
      await _usersRepo.update(
        id: id,
        fullName: fullName,
        username: username,
        password: password,
        role: role,
        isActive: isActive,
        isPasswordHashed: isPasswordHashed,
      );
      await loadUsers();
    } catch (e) {
      debugPrint('Error updating user: $e');
      rethrow;
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await _usersRepo.delete(id);
      await loadUsers();
    } catch (e) {
      debugPrint('Error deleting user: $e');
      rethrow;
    }
  }
}
