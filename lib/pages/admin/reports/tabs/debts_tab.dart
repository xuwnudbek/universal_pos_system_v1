import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';
import 'package:universal_pos_system_v1/utils/theme/app_colors.dart';

class DebtsTab extends StatelessWidget {
  const DebtsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final debts = [
      {'name': 'Alisher Valiyev', 'phone': '+998 90 123 45 67', 'amount': 850000.0, 'date': '25.01.2026'},
      {'name': 'Nodira Karimova', 'phone': '+998 91 234 56 78', 'amount': 1200000.0, 'date': '23.01.2026'},
      {'name': 'Jamshid Toshmatov', 'phone': '+998 93 345 67 89', 'amount': 650000.0, 'date': '22.01.2026'},
      {'name': 'Zilola Rahimova', 'phone': '+998 94 456 78 90', 'amount': 800000.0, 'date': '20.01.2026'},
    ];

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
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppRadius.md),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Mijoz',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Telefon',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Sana',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Qarz summasi',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: ListView.separated(
                itemCount: debts.length,
                separatorBuilder: (context, index) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final debt = debts[index];
                  return Container(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                debt['name'] as String,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            debt['phone'] as String,
                            style: textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(180),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            debt['date'] as String,
                            style: textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            (debt['amount'] as double).toSum,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
