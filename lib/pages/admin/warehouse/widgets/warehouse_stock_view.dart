import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:universal_pos_system_v1/models/warehouse/warehouse_item.dart';
import 'package:universal_pos_system_v1/pages/admin/procurements/widgets/warehouse_data_source.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/theme/app_colors.dart';

class WarehouseStockView extends StatelessWidget {
  final List<WarehouseItem> warehouseItems;
  final PaginatorController paginatorController;

  const WarehouseStockView({
    super.key,
    required this.warehouseItems,
    required this.paginatorController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    if (warehouseItems.isEmpty) {
      return Center(
        child: Text(
          "Maxsulotlar mavjud emas",
          style: textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.border,
            width: AppBorderWidth.thin,
          ),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        padding: EdgeInsets.only(left: 1),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: PaginatedDataTable2(
            controller: paginatorController,
            columnSpacing: AppSpacing.sm,
            horizontalMargin: AppSpacing.lg,
            minWidth: 1000,
            headingRowHeight: 56,
            dataRowHeight: 50,
            rowsPerPage: 20,
            availableRowsPerPage: const [10, 20, 50, 100],
            border: TableBorder.all(
              color: AppColors.surface,
            ),
            headingRowDecoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadius.md),
              ),
            ),
            columns: [
              // Item name column
              DataColumn2(
                label: Text(
                  'Maxsulot nomi',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                size: ColumnSize.L,
              ),
              // Barcode column
              DataColumn2(
                label: Text(
                  'Barcode',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                size: ColumnSize.M,
              ),
              // Warehouse columns
              DataColumn2(
                label: Text(
                  'Ombor',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                size: ColumnSize.S,
                numeric: true,
              ),
              // Shop columns
              DataColumn2(
                label: Text(
                  'Do\'kon',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                size: ColumnSize.S,
                numeric: true,
              ),
              // Total column
              DataColumn2(
                label: Text(
                  'Jami',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
                size: ColumnSize.S,
                numeric: true,
              ),
              // Unit column
              DataColumn2(
                headingRowAlignment: MainAxisAlignment.center,
                label: Text(
                  'O\'lchov',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                size: ColumnSize.S,
              ),
            ],
            source: WarehouseDataSource(
              warehouseItems: warehouseItems,
              context: context,
              textTheme: textTheme,
              theme: theme,
            ),
          ),
        ),
      ),
    );
  }
}
