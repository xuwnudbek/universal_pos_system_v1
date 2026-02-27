import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/pages/admin/backup/provider/backup_provider.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/functions/show_snackbar.dart';
import 'package:universal_pos_system_v1/widgets/button.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ChangeNotifierProvider(
      create: (_) => BackupProvider(context.read<AppDatabase>()),
      builder: (context, _) {
        return Consumer<BackupProvider>(
          builder: (context, provider, _) {
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
                        'Backup',
                        style: textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Database Info Card
                        Container(
                          constraints: BoxConstraints(maxWidth: 800),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.dividerTheme.color ?? Colors.grey,
                              width: AppBorderWidth.thin,
                            ),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(AppSpacing.lg),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(AppRadius.md),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(AppSpacing.sm),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withAlpha(30),
                                        borderRadius: BorderRadius.circular(AppRadius.sm),
                                      ),
                                      child: Icon(
                                        LucideIcons.database,
                                        color: Colors.blue,
                                        size: 24,
                                      ),
                                    ),
                                    SizedBox(width: AppSpacing.md),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Database ma\'lumotlari',
                                          style: textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: AppSpacing.xs),
                                        Text(
                                          'Joriy database holati',
                                          style: textTheme.bodySmall?.copyWith(
                                            color: theme.colorScheme.onSurface.withAlpha(150),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(height: 1),
                              Padding(
                                padding: EdgeInsets.all(AppSpacing.lg),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _InfoTile(
                                        icon: LucideIcons.hardDrive,
                                        label: 'Fayl hajmi',
                                        value: provider.dbSizeFormatted,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    SizedBox(width: AppSpacing.md),
                                    Expanded(
                                      child: _InfoTile(
                                        icon: LucideIcons.clock,
                                        label: 'Oxirgi o\'zgarish',
                                        value: provider.dbLastModifiedFormatted,
                                        color: Colors.green,
                                      ),
                                    ),
                                    SizedBox(width: AppSpacing.md),
                                    Expanded(
                                      child: _InfoTile(
                                        icon: LucideIcons.fileText,
                                        label: 'Fayl nomi',
                                        value: 'app.sqlite',
                                        color: Colors.purple,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppSpacing.lg),

                        // Export & Import Cards
                        Container(
                          constraints: BoxConstraints(maxWidth: 800),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Export Card
                              Expanded(
                                child: _ActionCard(
                                  icon: LucideIcons.upload,
                                  color: Colors.green,
                                  title: 'Export (Eksport)',
                                  description: 'Database faylini kompyuterga saqlash. Bu fayl orqali ma\'lumotlarni boshqa qurilmaga ko\'chirish mumkin.',
                                  buttonLabel: provider.isExporting ? 'Saqlanmoqda...' : 'Export qilish',
                                  isLoading: provider.isExporting,
                                  onPressed: provider.isExporting
                                      ? null
                                      : () async {
                                          await provider.exportDatabase();
                                          if (context.mounted && provider.lastMessage != null) {
                                            showAppSnackBar(
                                              context,
                                              provider.lastMessage!,
                                              type: provider.lastSuccess == true ? SnackBarType.success : SnackBarType.error,
                                            );
                                            provider.clearMessage();
                                          }
                                        },
                                ),
                              ),
                              SizedBox(width: AppSpacing.lg),
                              // Import Card
                              Expanded(
                                child: _ActionCard(
                                  icon: LucideIcons.download,
                                  color: Colors.orange,
                                  title: 'Import (Import)',
                                  description: 'Avval saqlangan backup faylini yuklash. Diqqat: joriy ma\'lumotlar o\'rniga yangi fayl yuklanadi!',
                                  buttonLabel: provider.isImporting ? 'Yuklanmoqda...' : 'Import qilish',
                                  isLoading: provider.isImporting,
                                  onPressed: provider.isImporting
                                      ? null
                                      : () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text('Diqqat!'),
                                              content: Text(
                                                'Import qilganda joriy ma\'lumotlar o\'rniga yangi fayl yuklanadi. Davom etishni xohlaysizmi?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, false),
                                                  child: Text('Bekor qilish'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, true),
                                                  style: TextButton.styleFrom(foregroundColor: Colors.orange),
                                                  child: Text('Davom etish'),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (confirm == true) {
                                            await provider.importDatabase();
                                            if (context.mounted && provider.lastMessage != null) {
                                              showAppSnackBar(
                                                context,
                                                provider.lastMessage!,
                                                type: provider.lastSuccess == true ? SnackBarType.success : SnackBarType.error,
                                              );
                                              provider.clearMessage();
                                            }
                                          }
                                        },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppSpacing.lg),

                        // Warning Notice
                        Container(
                          constraints: BoxConstraints(maxWidth: 800),
                          padding: EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: Colors.amber.withAlpha(20),
                            border: Border.all(
                              color: Colors.amber.withAlpha(80),
                              width: AppBorderWidth.thin,
                            ),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                LucideIcons.alertTriangle,
                                color: Colors.amber,
                                size: 20,
                              ),
                              SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Muhim eslatma',
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.amber.shade800,
                                      ),
                                    ),
                                    SizedBox(height: AppSpacing.xs),
                                    Text(
                                      'Import qilgandan keyin ilovani qayta ishga tushirish tavsiya etiladi. Backup fayllarni xavfsiz joyda saqlang.',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: Colors.amber.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.dividerTheme.color ?? Colors.grey,
          width: AppBorderWidth.thin,
        ),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(150),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final String buttonLabel;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _ActionCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.dividerTheme.color ?? Colors.grey,
          width: AppBorderWidth.thin,
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            description,
            style: textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(150),
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: Button(
              primaryColor: color,
              onPressed: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  else
                    Icon(icon, size: 18),
                  SizedBox(width: AppSpacing.sm),
                  Text(buttonLabel),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
