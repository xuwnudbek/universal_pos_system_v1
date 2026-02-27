import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/widgets/button.dart';

class DeleteUserModal extends StatelessWidget {
  const DeleteUserModal({
    super.key,
    required this.userName,
  });

  final String userName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: theme.colorScheme.error,
                size: 48,
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                'Foydalanuvchini o\'chirish',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                '"$userName" foydalanuvchisini o\'chirishni xohlaysizmi?',
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: AppSpacing.sm,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('Bekor qilish'),
                  ),
                  Button(
                    primaryColor: theme.colorScheme.error,
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('O\'chirish'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
