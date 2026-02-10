import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/pages/admin/reports/provider/reports_provider.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';

class DebtsTab extends StatelessWidget {
  const DebtsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Consumer<ReportsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final debtAmount = provider.debtAmount;

        return Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 500),
              padding: EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.dividerTheme.color ?? Colors.grey,
                  width: AppBorderWidth.thin,
                ),
                borderRadius: BorderRadius.circular(AppRadius.md),
                color: Colors.orange.withAlpha(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: Colors.orange.withAlpha(50),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Icon(
                      LucideIcons.coins,
                      size: 64,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl),
                  Text(
                    'Umumiy qarz summasi',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withAlpha(180),
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    debtAmount.toSum,
                    style: textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'UZS',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.orange.withAlpha(180),
                    ),
                  ),
                  if (debtAmount == 0) ...[
                    SizedBox(height: AppSpacing.lg),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha(30),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.checkCircle,
                            color: Colors.green,
                            size: 20,
                          ),
                          SizedBox(width: AppSpacing.sm),
                          Text(
                            'Qarz yo\'q',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
