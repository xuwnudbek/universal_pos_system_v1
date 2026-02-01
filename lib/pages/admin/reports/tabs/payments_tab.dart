import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';

class PaymentsTab extends StatelessWidget {
  const PaymentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final payments = [
      {'type': 'Naqd', 'amount': 35000000.0, 'icon': LucideIcons.wallet, 'color': Colors.green},
      {'type': 'Karta', 'amount': 28000000.0, 'icon': LucideIcons.creditCard, 'color': Colors.blue},
      {'type': 'Terminal', 'amount': 12000000.0, 'icon': LucideIcons.smartphone, 'color': Colors.purple},
      {'type': 'Qarz', 'amount': 3500000.0, 'icon': LucideIcons.coins, 'color': Colors.orange},
    ];

    final total = payments.fold<double>(0, (sum, item) => sum + (item['amount'] as double));

    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          // Payment types
          Expanded(
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
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppRadius.md),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'To\'lov turi',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Summa',
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
                      itemCount: payments.length,
                      separatorBuilder: (context, index) => Divider(height: 1),
                      itemBuilder: (context, index) {
                        final payment = payments[index];
                        return Container(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(AppSpacing.sm),
                                      decoration: BoxDecoration(
                                        color: (payment['color'] as Color).withAlpha(50),
                                        borderRadius: BorderRadius.circular(AppRadius.sm),
                                      ),
                                      child: Icon(
                                        payment['icon'] as IconData,
                                        color: payment['color'] as Color,
                                        size: 20,
                                      ),
                                    ),
                                    SizedBox(width: AppSpacing.md),
                                    Text(
                                      payment['type'] as String,
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
                                  (payment['amount'] as double).toSum,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: payment['color'] as Color,
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
          ),
        ],
      ),
    );
  }
}
