import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:universal_pos_system_v1/data/repositories/items/items_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/stocks/stocks_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/transfers/transfers_repository.dart';
import 'package:universal_pos_system_v1/models/warehouse/warehouse_item.dart';
import 'package:universal_pos_system_v1/pages/admin/procurements/widgets/warehouse_data_source.dart';
import 'package:universal_pos_system_v1/pages/admin/warehouse/modals/warehouse_transfer_modal.dart';
import 'package:universal_pos_system_v1/pages/admin/warehouse/providers/warehouse_provider.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/theme/app_colors.dart';
import 'package:universal_pos_system_v1/widgets/button.dart';
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
                      // Add Transfer Button
                      Button(
                        onPressed: () async {
                          final provider = context.read<WarehouseProvider>();

                          if (!provider.isInitialized) return;

                          final result = await showDialog<TransferFormResult>(
                            context: context,
                            builder: (context) => WarehouseTransferModal(
                              warehouseItems: provider.warehouseItems,
                            ),
                          );

                          if (result != null && context.mounted) {
                            final transfersRepo = context.read<TransfersRepository>();

                            try {
                              await transfersRepo.create(
                                itemId: result.item.id,
                                fromLocation: result.fromLocation,
                                toLocation: result.toLocation,
                                quantity: result.quantity,
                                note: result.note,
                              );

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Maxsulot muvaffaqiyatli ko\'chirildi'),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                // Refresh the warehouse data
                                await provider.refresh();
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Xatolik yuz berdi: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                            Icon(LucideIcons.arrowRightLeft),
                            Text('Ko\'chirish'),
                          ],
                        ),
                      ),
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
