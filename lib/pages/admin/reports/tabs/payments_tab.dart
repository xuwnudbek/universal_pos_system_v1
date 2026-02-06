import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/data/local/enums/payment_types_enum.dart';
import 'package:universal_pos_system_v1/pages/admin/reports/provider/reports_provider.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';

class PaymentsTab extends StatelessWidget {
  const PaymentsTab({super.key});

  Color _getColorForPaymentType(PaymentTypesEnum type) {
    switch (type) {
      case PaymentTypesEnum.cash:
        return Colors.green;
      case PaymentTypesEnum.card:
        return Colors.blue;
      case PaymentTypesEnum.terminal:
        return Colors.purple;
      case PaymentTypesEnum.debt:
        return Colors.orange;
    }
  }

  String _getNameForPaymentType(PaymentTypesEnum type) {
    switch (type) {
      case PaymentTypesEnum.cash:
        return 'Naqd';
      case PaymentTypesEnum.card:
        return 'Karta';
      case PaymentTypesEnum.terminal:
        return 'Terminal';
      case PaymentTypesEnum.debt:
        return 'Qarz';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Consumer<ReportsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final payments = provider.paymentStatistics;

        if (payments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.wallet,
                  size: 64,
                  color: theme.colorScheme.onSurface.withAlpha(100),
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  'Hech qanday to\'lov topilmadi',
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
                            final paymentType = payment['paymentType'];
                            final amount = payment['totalAmount'] as double;
                            final paymentTypeName = paymentType.name as PaymentTypesEnum;
                            final color = _getColorForPaymentType(paymentTypeName);
                            final name = _getNameForPaymentType(paymentTypeName);

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
                                            color: color.withAlpha(50),
                                            borderRadius: BorderRadius.circular(AppRadius.sm),
                                          ),
                                          child: Icon(
                                            paymentTypeName.iconData,
                                            color: color,
                                            size: 20,
                                          ),
                                        ),
                                        SizedBox(width: AppSpacing.md),
                                        Text(
                                          name,
                                          style: textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text.rich(
                                      TextSpan(
                                        text: amount.toSum,
                                        style: textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: color,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: ' UZS',
                                            style: textTheme.bodySmall?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: color,
                                            ),
                                          ),
                                        ],
                                      ),
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: color,
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
      },
    );
  }
}
