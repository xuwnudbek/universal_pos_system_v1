import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:universal_pos_system_v1/data/models/item_category_full.dart';
import 'package:universal_pos_system_v1/data/models/items_full.dart';
import 'package:universal_pos_system_v1/data/repositories/item_categories_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/items_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/units_repository.dart';
import 'package:universal_pos_system_v1/models/item_form_result.dart';
import 'package:universal_pos_system_v1/pages/admin/items/provider/items_provider.dart';
import 'package:universal_pos_system_v1/pages/admin/items/modals/add_item_modal.dart';
import 'package:universal_pos_system_v1/pages/admin/items/modals/delete_item_modal.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';
import 'package:universal_pos_system_v1/utils/functions/string_to_hex.dart';
import 'package:universal_pos_system_v1/utils/theme/app_colors.dart';
import 'package:universal_pos_system_v1/widgets/button.dart';
import 'package:universal_pos_system_v1/widgets/icon_button2.dart';
import 'package:universal_pos_system_v1/widgets/loaders/app_loader.dart';
import 'package:universal_pos_system_v1/widgets/loaders/app_shimmer_loader.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
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
          create: (_) => ItemsProvider(
            context.read<ItemsRepository>(),
            context.read<ItemCategoriesRepository>(),
            context.read<UnitsRepository>(),
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
                        "Maxsulotlar",
                        style: theme.textTheme.titleLarge,
                      ),
                      Spacer(),
                      Button(
                        onPressed: () async {
                          final itemsProvider = context.read<ItemsProvider>();

                          final result = await showDialog<ItemFormResult>(
                            context: context,
                            builder: (context) => AddItemModal(
                              categories: itemsProvider.categories,
                              units: itemsProvider.units,
                            ),
                          );

                          if (result != null && context.mounted) {
                            itemsProvider.addItem(result);
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                            Icon(LucideIcons.plus),
                            Text("Maxsulot qo'shish"),
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
                          controller: context.read<ItemsProvider>().searchController,
                          onChanged: (value) {
                            context.read<ItemsProvider>().searchQuery = value;
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
                      SizedBox(width: AppSpacing.md),
                      // Add category button
                      Expanded(
                        child: SizedBox(
                          height: AppButtonHeight.md,
                          child: Selector<ItemsProvider, (bool, List<ItemCategoryFull>, ItemCategoryFull?)>(
                            selector: (context, provider) => (provider.isInitialized, provider.categories, provider.selectedCategory),
                            builder: (context, data, _) {
                              final isInitialized = data.$1;
                              final categories = data.$2;
                              final selectedCategory = data.$3;

                              if (!isInitialized) {
                                return AppShimmerLoader();
                              }

                              return Row(
                                spacing: AppSpacing.sm,
                                children: [
                                  ChoiceChip(
                                    label: Text("Barchasi"),
                                    selected: selectedCategory == null,
                                    onSelected: (selected) {
                                      context.read<ItemsProvider>().onSelectCategory(null);
                                      _paginatorController.goToPageWithRow(0);
                                    },
                                  ),

                                  Expanded(
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: categories.length,
                                      separatorBuilder: (context, _) => SizedBox(width: AppSpacing.sm),
                                      itemBuilder: (context, index) {
                                        var category = categories[index];
                                        bool isSelected = selectedCategory?.id == category.id;

                                        return ChoiceChip(
                                          label: Text(category.name),
                                          selected: isSelected,
                                          onSelected: (selected) {
                                            context.read<ItemsProvider>().onSelectCategory(category);
                                            _paginatorController.goToPageWithRow(0);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
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
                    child: Selector<ItemsProvider, bool>(
                      selector: (_, provider) => provider.isInitialized,
                      builder: (context, isInitialized, _) {
                        if (!isInitialized) {
                          return AppLoader();
                        }

                        return Selector<ItemsProvider, List<ItemFull>>(
                          selector: (_, provider) => provider.items,
                          builder: (context, items, _) {
                            if (items.isEmpty) {
                              return Center(
                                child: Text(
                                  "Maxsulotlar mavjud emas",
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              );
                            }

                            final itemsProvider = context.read<ItemsProvider>();

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
                                  sortColumnIndex: itemsProvider.sortColumnIndex,
                                  sortAscending: itemsProvider.sortAscending,
                                  columnSpacing: AppSpacing.md,
                                  horizontalMargin: AppSpacing.lg,
                                  minWidth: 1200,
                                  headingRowHeight: 56,
                                  dataRowHeight: 60,
                                  rowsPerPage: 10,
                                  availableRowsPerPage: const [10, 20, 50, 100],
                                  sortArrowIcon: LucideIcons.arrowDown,
                                  sortArrowIconColor: theme.colorScheme.primary,
                                  border: TableBorder(),
                                  headingRowDecoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(AppRadius.md),
                                    ),
                                  ),
                                  columns: [
                                    DataColumn2(
                                      label: Text(
                                        'Maxsulot nomi',
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      size: ColumnSize.L,
                                    ),
                                    DataColumn2(
                                      label: Text(
                                        'Barcode',
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      size: ColumnSize.M,
                                    ),
                                    DataColumn2(
                                      label: Text(
                                        'Kategoriya',
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: itemsProvider.sortColumnIndex == 2 ? theme.colorScheme.primary : null,
                                        ),
                                      ),
                                      size: ColumnSize.M,
                                      onSort: (columnIndex, ascending) {
                                        itemsProvider.sortByColumn(columnIndex, ascending);
                                        _paginatorController.goToPageWithRow(0);
                                      },
                                    ),
                                    DataColumn2(
                                      label: Text(
                                        'Narx',
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      size: ColumnSize.M,
                                      numeric: true,
                                    ),
                                    DataColumn2(
                                      headingRowAlignment: MainAxisAlignment.center,
                                      label: Text(
                                        'O\'lchov',
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      size: ColumnSize.M,
                                      fixedWidth: 100,
                                    ),
                                    DataColumn2(
                                      headingRowAlignment: MainAxisAlignment.start,
                                      label: Text(
                                        'Qoldiq',
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      size: ColumnSize.M,
                                      numeric: true,
                                      fixedWidth: 80,
                                    ),
                                    DataColumn2(
                                      headingRowAlignment: MainAxisAlignment.center,
                                      label: Text(
                                        'Amallar',
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      size: ColumnSize.M,
                                      fixedWidth: 120,
                                    ),
                                  ],
                                  source: ItemsDataSource(
                                    items: items,
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

class ItemsDataSource extends DataTableSource {
  final List<ItemFull> items;
  final BuildContext context;
  final TextTheme textTheme;
  final ThemeData theme;

  ItemsDataSource({
    required this.items,
    required this.context,
    required this.textTheme,
    required this.theme,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= items.length) return null;
    final item = items[index];

    return DataRow2(
      cells: [
        // Name cell with category color indicator
        DataCell(
          Row(
            spacing: AppSpacing.sm,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                elevation: AppElevation.none,
                color: Color(hexToColor(item.category?.color?.hex)),
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

        // Category cell
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: item.category != null ? Color(hexToColor(item.category!.color!.hex)) : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              item.category?.name ?? "N/A",
              style: textTheme.bodySmall?.copyWith(
                color: item.category != null ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        // Price cell
        DataCell(
          Text(
            item.price.toSum,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Unit cell
        DataCell(
          Align(
            alignment: Alignment.center,
            child: Text(
              item.unit.shortName,
            ),
          ),
        ),
        // Stock cell
        DataCell(
          Text(
            item.stock.toString(),
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: item.stock > 0 ? Colors.green : Colors.red,
            ),
          ),
        ),
        // Actions cell
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton2(
                type: IconButton2Type.info,
                icon: Icons.edit,
                onPressed: () async {
                  final itemsProvider = context.read<ItemsProvider>();

                  var result = await showDialog<ItemFormResult>(
                    context: context,
                    builder: (context) => AddItemModal(
                      categories: itemsProvider.categories,
                      units: itemsProvider.units,
                      item: item,
                    ),
                  );

                  if (result != null && context.mounted) {
                    await itemsProvider.updateItem(item.id, result);
                  }
                },
              ),
              IconButton2(
                type: IconButton2Type.danger,
                icon: Icons.delete,
                onPressed: () async {
                  final itemsProvider = context.read<ItemsProvider>();

                  final shouldDelete = await showDialog<bool>(
                    context: context,
                    builder: (context) => DeleteItemModal(item: item),
                  );

                  if (shouldDelete == true && context.mounted) {
                    await itemsProvider.deleteItem(item.id);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => items.length;

  @override
  int get selectedRowCount => 0;
}
