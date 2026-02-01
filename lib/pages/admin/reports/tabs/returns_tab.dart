import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';
import 'package:universal_pos_system_v1/utils/theme/app_colors.dart';

class ReturnsTab extends StatelessWidget {
  const ReturnsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final returns = [
      {'product': 'Coca Cola 1.5L', 'quantity': 2, 'amount': 50000.0, 'reason': 'Shisha yorilib ketgan', 'date': '28.01.2026'},
      {'product': 'Pepsi 0.5L', 'quantity': 5, 'amount': 50000.0, 'reason': 'Muddati o\'tgan', 'date': '27.01.2026'},
      {'product': 'Fanta 1L', 'quantity': 3, 'amount': 45000.0, 'reason': 'Sifatsiz mahsulot', 'date': '26.01.2026'},
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
                      'Maxsulot',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Soni',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Izoh',
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
                itemCount: returns.length,
                separatorBuilder: (context, index) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final returnItem = returns[index];
                  return Container(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            returnItem['product'] as String,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${returnItem['quantity']} ta',
                            style: textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.help,
                            child: Tooltip(
                              richMessage: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Qaytarish sababi:\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  TextSpan(
                                    text: returnItem['reason'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(AppSpacing.md),
                              margin: EdgeInsets.only(top: 8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              preferBelow: true,
                              waitDuration: Duration(milliseconds: 300),
                              child: Text(
                                returnItem['reason'] as String,
                                style: textTheme.bodySmall?.copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.dotted,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            returnItem['date'] as String,
                            style: textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            (returnItem['amount'] as double).toSum,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
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
