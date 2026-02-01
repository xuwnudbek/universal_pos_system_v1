import 'package:drift/drift.dart';

import '../../app_database.dart';
import '../../enums/user_roles_enum.dart';
import '../../tables/users_table.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  // Get All Users
  Future<List<User>> getAll() => (select(users)..orderBy([(u) => OrderingTerm.desc(u.createdAt)])).get();

  // Get User By Id
  Future<User?> getById(int id) => (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();

  // Get User By Username
  Future<User?> getByUsername(String username) => (select(users)..where((u) => u.username.equals(username))).getSingleOrNull();

  // Insert User
  Future<int> insertUser(
    String fullName,
    String username,
    String passwordHash,
    UserRolesEnum role,
    bool isActive,
  ) {
    return into(users).insert(
      UsersCompanion(
        fullName: Value(fullName),
        username: Value(username),
        passwordHash: Value(passwordHash),
        role: Value(role),
        isActive: Value(isActive),
      ),
    );
  }

  // Update User
  Future<int> updateUser(
    int id,
    String fullName,
    String username,
    String passwordHash,
    UserRolesEnum role,
    bool isActive,
  ) {
    final query = update(users)..where((u) => u.id.equals(id));

    return query.write(
      UsersCompanion(
        fullName: Value(fullName),
        username: Value(username),
        passwordHash: Value(passwordHash),
        role: Value(role),
        isActive: Value(isActive),
      ),
    );
  }

  // Delete User
  Future deleteUser(int id) {
    return (delete(users)..where((u) => u.id.equals(id))).go();
  }
}
