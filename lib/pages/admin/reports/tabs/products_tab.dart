import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/pages/admin/reports/provider/reports_provider.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';
import 'package:universal_pos_system_v1/utils/theme/app_colors.dart';
import 'package:universal_pos_system_v1/widgets/loaders/app_loader.dart';

class ProductsTab extends StatelessWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Consumer<ReportsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return AppLoader();
        }

        final products = provider.topSellingProducts;

        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: theme.colorScheme.onSurface.withAlpha(100),
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  'Hech qanday ma\'lumot topilmadi',
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
                      final item = product['item'];
                      final quantity = product['quantity'] as int;
                      final amount = product['amount'] as double;

                      return Container(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                item.name,
                                style: textTheme.bodyMedium,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '$quantity ta',
                                style: textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                amount.toSum,
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
      },
    );
  }
}
