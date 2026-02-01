import 'package:universal_pos_system_v1/data/local/daos/users/users_dao.dart';
import 'package:universal_pos_system_v1/data/local/enums/user_roles_enum.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'dart:convert';

import 'package:universal_pos_system_v1/utils/functions/bcrypt.dart';

class UsersRepository {
  final UsersDao usersDao;

  const UsersRepository(this.usersDao);

  // Get all users
  Future<List<User>> getAll() => usersDao.getAll();

  // Get user by ID
  Future<User?> getById(int id) => usersDao.getById(id);

  // Get user by username
  Future<User?> getByUsername(String username) => usersDao.getByUsername(username);

  // Authenticate user
  Future<User?> authenticate(String username, String password) async {
    final user = await getByUsername(username);

    if (user == null || !user.isActive) {
      return null;
    }

    if (verifyPassword(password, user.passwordHash)) {
      return user;
    }

    return null;
  }

  // Create new user
  Future<int> create({
    required String fullName,
    required String username,
    required String password,
    required UserRolesEnum role,
    bool isActive = true,
  }) {
    final passwordHash = hashPassword(password);

    return usersDao.insertUser(
      fullName,
      username,
      passwordHash,
      role,
      isActive,
    );
  }

  // Update user
  Future<void> update({
    required int id,
    required String fullName,
    required String username,
    required String password,
    required UserRolesEnum role,
    required bool isActive,
  }) {
    final passwordHash = hashPassword(password);

    return usersDao.updateUser(
      id,
      fullName,
      username,
      passwordHash,
      role,
      isActive,
    );
  }

  // Delete user
  Future<void> delete(int id) => usersDao.deleteUser(id);
}
