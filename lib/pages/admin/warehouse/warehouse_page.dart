import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:universal_pos_system_v1/data/models/transfer_full.dart';
import 'package:universal_pos_system_v1/data/repositories/items/items_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/stocks/stocks_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/transfers/transfers_repository.dart';
import 'package:universal_pos_system_v1/models/warehouse/warehouse_item.dart';
import 'package:universal_pos_system_v1/pages/admin/warehouse/modals/warehouse_transfer_modal.dart';
import 'package:universal_pos_system_v1/pages/admin/warehouse/providers/warehouse_provider.dart';
import 'package:universal_pos_system_v1/pages/admin/warehouse/widgets/warehouse_history_view.dart';
import 'package:universal_pos_system_v1/pages/admin/warehouse/widgets/warehouse_stock_view.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/functions/show_snackbar.dart';
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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WarehouseProvider(
            context.read<ItemsRepository>(),
            context.read<StocksRepository>(),
            context.read<TransfersRepository>(),
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
                        barrierDismissible: false,
                            builder: (context) => WarehouseTransferModal(
                              warehouseItems: provider.warehouseItems,
                            ),
                          );

                          if (result != null && context.mounted) {
                            try {
                              await provider.createTransfer(
                                itemId: result.item.id,
                                fromLocation: result.fromLocation,
                                toLocation: result.toLocation,
                                quantity: result.quantity,
                                note: result.note,
                              );

                              await provider.refresh();

                              if (context.mounted) {
                                showAppSnackBar(
                                  context,
                                  'Maxsulot muvaffaqiyatli ko\'chirildi',
                                  type: SnackBarType.success,
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                showAppSnackBar(
                                  context,
                                  'Xatolik yuz berdi: $e',
                                  type: SnackBarType.error,
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
                    spacing: AppSpacing.md,
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
                      // Tab Chips
                      Selector<WarehouseProvider, WarehouseTab>(
                        selector: (_, provider) => provider.selectedTab,
                        builder: (context, selectedTab, _) {
                          return Row(
                            spacing: AppSpacing.sm,
                            children: [
                              ChoiceChip(
                                label: Text('Qoldiqlar'),
                                selected: selectedTab == WarehouseTab.stock,
                                onSelected: (selected) {
                                  if (selected) {
                                    context.read<WarehouseProvider>().selectedTab = WarehouseTab.stock;
                                  }
                                },
                              ),
                              ChoiceChip(
                                label: Text('Tarix'),
                                selected: selectedTab == WarehouseTab.history,
                                onSelected: (selected) {
                                  if (selected) {
                                    context.read<WarehouseProvider>().selectedTab = WarehouseTab.history;
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: Selector<WarehouseProvider, bool>(
                selector: (_, provider) => provider.isInitialized,
                builder: (context, isInitialized, _) {
                  if (!isInitialized) {
                    return AppLoader();
                  }

                  return Selector<WarehouseProvider, WarehouseTab>(
                    selector: (_, provider) => provider.selectedTab,
                    builder: (context, selectedTab, _) {
                      if (selectedTab == WarehouseTab.stock) {
                        return Selector<WarehouseProvider, List<WarehouseItem>>(
                          selector: (_, provider) => provider.warehouseItems,
                          builder: (context, warehouseItems, _) {
                            return WarehouseStockView(
                              warehouseItems: warehouseItems,
                              paginatorController: _paginatorController,
                            );
                          },
                        );
                      } else {
                        return Selector<WarehouseProvider, List<TransferFull>>(
                          selector: (_, provider) => provider.transfers,
                          builder: (context, transfers, _) {
                            return WarehouseHistoryView(
                              transfers: transfers,
                              paginatorController: _paginatorController,
                            );
                          },
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
