import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';
import 'package:universal_pos_system_v1/utils/theme/app_colors.dart';

class ProductsTab extends StatelessWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // Mock data
    final products = [
      {'name': 'Coca Cola 1.5L', 'quantity': 450, 'amount': 11250000.0},
      {'name': 'Pepsi 0.5L', 'quantity': 380, 'amount': 3800000.0},
      {'name': 'Fanta 1L', 'quantity': 320, 'amount': 4800000.0},
      {'name': 'Sprite 1.5L', 'quantity': 280, 'amount': 7000000.0},
      {'name': 'Non', 'quantity': 250, 'amount': 1250000.0},
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
                  top: Radius.circular(AppRadius.lg),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Eng ko\'p sotilgan maxsulotlar',
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
                itemCount: products.length,
                separatorBuilder: (context, index) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Container(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            product['name'] as String,
                            style: textTheme.bodyMedium,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${product['quantity']} ta',
                            style: textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            (product['amount'] as double).toSum,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
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
