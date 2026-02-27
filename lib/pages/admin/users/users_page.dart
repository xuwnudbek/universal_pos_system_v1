import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/local/enums/user_roles_enum.dart';
import 'package:universal_pos_system_v1/data/repositories/users/users_repository.dart';
import 'package:universal_pos_system_v1/pages/admin/users/modals/add_user_modal.dart';
import 'package:universal_pos_system_v1/pages/admin/users/modals/delete_user_modal.dart';
import 'package:universal_pos_system_v1/pages/admin/users/provider/users_provider.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/functions/show_snackbar.dart';
import 'package:universal_pos_system_v1/utils/theme/app_colors.dart';
import 'package:universal_pos_system_v1/widgets/button.dart';
import 'package:universal_pos_system_v1/widgets/loaders/app_loader.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final PaginatorController _paginatorController = PaginatorController();

  @override
  void dispose() {
    _paginatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UsersProvider(
            context.read<UsersRepository>(),
          ),
        ),
      ],
      builder: (context, _) {
        return Column(
          children: [
            // Header
            Container(
              height: 60,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerTheme.color ?? Colors.grey,
                    width: AppBorderWidth.thin,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  Text(
                    'Foydalanuvchilar',
                    style: textTheme.titleLarge,
                  ),
                  Spacer(),
                  Button(
                    onPressed: () async {
                      final provider = context.read<UsersProvider>();

                      final result = await showDialog<UserFormResult>(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AddUserModal(),
                      );

                      if (result != null && context.mounted) {
                        try {
                          await provider.addUser(
                            fullName: result.fullName,
                            username: result.username,
                            password: result.password,
                            role: result.role,
                          );
                          if (context.mounted) {
                            showAppSnackBar(
                              context,
                              'Foydalanuvchi muvaffaqiyatli qo\'shildi',
                              type: SnackBarType.success,
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            showAppSnackBar(
                              context,
                              'Xatolik: $e',
                              type: SnackBarType.error,
                            );
                          }
                        }
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8,
                      children: [
                        Icon(LucideIcons.userPlus),
                        Text('Foydalanuvchi qo\'shish'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Users Table
            Expanded(
              child: Selector<UsersProvider, bool>(
                selector: (_, provider) => provider.isInitialized,
                builder: (context, isInitialized, _) {
                  if (!isInitialized) {
                    return AppLoader();
                  }

                  return Selector<UsersProvider, List<User>>(
                    selector: (_, provider) => provider.users,
                    builder: (context, users, _) {
                      if (users.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.users,
                                size: 64,
                                color: theme.colorScheme.onSurface.withAlpha(75),
                              ),
                              SizedBox(height: AppSpacing.md),
                              Text(
                                'Foydalanuvchilar topilmadi',
                                style: textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurface.withAlpha(150),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.dividerTheme.color ?? Colors.grey,
                              width: AppBorderWidth.thin,
                            ),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          padding: EdgeInsets.all(1),
                          child: PaginatedDataTable2(
                            controller: _paginatorController,
                            columnSpacing: AppSpacing.md,
                            horizontalMargin: AppSpacing.lg,
                            minWidth: 700,
                            headingRowHeight: 56,
                            dataRowHeight: 60,
                            rowsPerPage: 10,
                            availableRowsPerPage: const [10, 20, 50],
                            border: TableBorder.all(
                              color: AppColors.surface,
                            ),
                            headingRowDecoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(AppRadius.md),
                              ),
                            ),
                            columns: [
                              DataColumn2(
                                label: Text(
                                  'Ism familiya',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                size: ColumnSize.L,
                              ),
                              DataColumn2(
                                label: Text(
                                  'Username',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                size: ColumnSize.M,
                              ),
                              DataColumn2(
                                label: Text(
                                  'Rol',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                size: ColumnSize.S,
                                fixedWidth: 120,
                              ),
                              DataColumn2(
                                label: Text(
                                  'Holati',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                size: ColumnSize.S,
                                fixedWidth: 100,
                              ),
                              DataColumn2(
                                label: Text(
                                  'Amallar',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                size: ColumnSize.S,
                                fixedWidth: 100,
                              ),
                            ],
                            source: _UsersDataSource(
                              users: users,
                              context: context,
                              textTheme: textTheme,
                              theme: theme,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _UsersDataSource extends DataTableSource {
  final List<User> users;
  final BuildContext context;
  final TextTheme textTheme;
  final ThemeData theme;

  _UsersDataSource({
    required this.users,
    required this.context,
    required this.textTheme,
    required this.theme,
  });

  Color _roleColor(UserRolesEnum role) {
    switch (role) {
      case UserRolesEnum.admin:
        return Colors.purple;
      case UserRolesEnum.cashier:
        return Colors.blue;
    }
  }

  String _roleName(UserRolesEnum role) {
    switch (role) {
      case UserRolesEnum.admin:
        return 'Admin';
      case UserRolesEnum.cashier:
        return 'Kassir';
    }
  }

  IconData _roleIcon(UserRolesEnum role) {
    switch (role) {
      case UserRolesEnum.admin:
        return Icons.admin_panel_settings;
      case UserRolesEnum.cashier:
        return Icons.point_of_sale;
    }
  }

  @override
  DataRow2? getRow(int index) {
    if (index >= users.length) return null;

    final user = users[index];
    final roleColor = _roleColor(user.role);

    return DataRow2(
      cells: [
        // Full Name
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: roleColor.withAlpha(40),
                child: Text(
                  user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: roleColor,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  user.fullName,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Username
        DataCell(
          Text(
            user.username,
            style: textTheme.bodyMedium,
          ),
        ),
        // Role
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: roleColor.withAlpha(25),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: roleColor.withAlpha(80),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_roleIcon(user.role), size: 14, color: roleColor),
                SizedBox(width: 4),
                Text(
                  _roleName(user.role),
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: roleColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Status
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: user.isActive ? Colors.green.withAlpha(25) : Colors.red.withAlpha(25),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  user.isActive ? Icons.check_circle : Icons.cancel,
                  size: 14,
                  color: user.isActive ? Colors.green : Colors.red,
                ),
                SizedBox(width: 4),
                Text(
                  user.isActive ? 'Faol' : 'Nofaol',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: user.isActive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Actions
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  LucideIcons.edit,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                onPressed: () async {
                  final provider = context.read<UsersProvider>();
                  final result = await showDialog<UserFormResult>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AddUserModal(user: user),
                  );

                  if (result != null && context.mounted) {
                    try {
                      final isPasswordChanged = result.password.isNotEmpty;
                      await provider.updateUser(
                        id: user.id,
                        fullName: result.fullName,
                        username: result.username,
                        password: isPasswordChanged ? result.password : user.passwordHash,
                        role: result.role,
                        isActive: result.isActive,
                        isPasswordHashed: !isPasswordChanged,
                      );
                      if (context.mounted) {
                        showAppSnackBar(
                          context,
                          'Foydalanuvchi tahrirlandi',
                          type: SnackBarType.success,
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        showAppSnackBar(
                          context,
                          'Xatolik: $e',
                          type: SnackBarType.error,
                        );
                      }
                    }
                  }
                },
              ),
              IconButton(
                icon: Icon(
                  LucideIcons.trash2,
                  size: 18,
                  color: theme.colorScheme.error,
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => DeleteUserModal(userName: user.fullName),
                  );

                  if (confirm == true && context.mounted) {
                    try {
                      await context.read<UsersProvider>().deleteUser(user.id);
                      if (context.mounted) {
                        showAppSnackBar(
                          context,
                          'Foydalanuvchi o\'chirildi',
                          type: SnackBarType.success,
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        showAppSnackBar(
                          context,
                          'Xatolik: $e',
                          type: SnackBarType.error,
                        );
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
}
