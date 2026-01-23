import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:universal_pos_system_v1/data/repositories/items_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/stocks_repository.dart';
import 'package:universal_pos_system_v1/pages/admin/warehouse/providers/warehouse_provider.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/functions/string_to_hex.dart';
import 'package:universal_pos_system_v1/utils/theme/app_colors.dart';
import 'package:universal_pos_system_v1/widgets/loaders/app_loader.dart';

class WarehousePage extends StatefulWidget {
  const WarehousePage({super.key});

  @override
  State<WarehousePage> createState() => _WarehousePageState();
}

class _WarehousePageState extends State<WarehousePage> {
  final PaginatorController _paginatorController = PaginatorController();

  @override
  void dispose() {
    _paginatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WarehouseProvider(
            context.read<ItemsRepository>(),
            context.read<StocksRepository>(),
          ),
        ),
      ],
      builder: (context, _) {
        return Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerTheme.color ?? Colors.grey,
                    width: AppBorderWidth.thin,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Ombor",
                        style: theme.textTheme.titleLarge,
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      // Search field
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: context.read<WarehouseProvider>().searchController,
                          onChanged: (value) {
                            context.read<WarehouseProvider>().searchQuery = value;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            hintText: 'Qidirish ...',
                            prefixIcon: Icon(LucideIcons.search),
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Selector<WarehouseProvider, bool>(
                      selector: (_, provider) => provider.isInitialized,
                      builder: (context, isInitialized, _) {
                        if (!isInitialized) {
                          return AppLoader();
                        }

                        return Selector<WarehouseProvider, List<WarehouseItem>>(
                          selector: (_, provider) => provider.warehouseItems,
                          builder: (context, warehouseItems, _) {
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
                                child: PaginatedDataTable2(
                                  controller: _paginatorController,
                                  columnSpacing: AppSpacing.md,
                                  horizontalMargin: AppSpacing.lg,
                                  minWidth: 1000,
                                  headingRowHeight: 56,
                                  dataRowHeight: 60,
                                  rowsPerPage: 10,
                                  availableRowsPerPage: const [10, 20, 50, 100],
                                  border: TableBorder(),
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
                                  ],
                                  source: WarehouseDataSource(
                                    warehouseItems: warehouseItems,
                                    context: context,
                                    textTheme: textTheme,
                                    theme: theme,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class WarehouseDataSource extends DataTableSource {
  final List<WarehouseItem> warehouseItems;
  final BuildContext context;
  final TextTheme textTheme;
  final ThemeData theme;

  WarehouseDataSource({
    required this.warehouseItems,
    required this.context,
    required this.textTheme,
    required this.theme,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= warehouseItems.length) return null;
    final warehouseItem = warehouseItems[index];
    final item = warehouseItem.item;

    return DataRow2(
      cells: [
        // Name cell with category color indicator
        DataCell(
          Row(
            spacing: AppSpacing.sm,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.category != null)
                Card(
                  elevation: AppElevation.none,
                  color: Color(hexToColor(item.category!.color!.hex)),
                  child: SizedBox.square(dimension: 8),
                ),
              Flexible(
                child: Text(
                  item.name,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        // Barcode cell
        DataCell(
          Text(
            item.barcode,
            style: textTheme.bodyMedium,
          ),
        ),
        // Location quantity cells
        DataCell(
          Text(
            warehouseItem.warehouseQuantity.toStringAsFixed(1),
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: warehouseItem.warehouseQuantity > 0 ? Colors.green : Colors.grey,
            ),
          ),
        ),
        DataCell(
          Text(
            warehouseItem.shopQuantity.toStringAsFixed(1),
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: warehouseItem.shopQuantity > 0 ? Colors.blue : Colors.grey,
            ),
          ),
        ),
        // Total cell
        DataCell(
          Text(
            warehouseItem.totalQuantity.toStringAsFixed(1),
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: warehouseItem.totalQuantity > 0 ? theme.colorScheme.primary : Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => warehouseItems.length;

  @override
  int get selectedRowCount => 0;
}
