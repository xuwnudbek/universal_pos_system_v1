import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:universal_pos_system_v1/models/warehouse/warehouse_item.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';

class SearchableWarehouseItemDialog extends StatefulWidget {
  final List<WarehouseItem> warehouseItems;
  final WarehouseItem? initialItem;

  const SearchableWarehouseItemDialog({
    super.key,
    required this.warehouseItems,
    this.initialItem,
  });

  @override
  State<SearchableWarehouseItemDialog> createState() => _SearchableWarehouseItemDialogState();
}

class _SearchableWarehouseItemDialogState extends State<SearchableWarehouseItemDialog> {
  final _searchController = TextEditingController();
  List<WarehouseItem> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.warehouseItems;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.warehouseItems;
      } else {
        _filteredItems = widget.warehouseItems.where((warehouseItem) {
          return warehouseItem.item.name.toLowerCase().contains(query.toLowerCase()) || warehouseItem.item.barcode.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Dialog(
      child: Container(
        width: 600,
        constraints: BoxConstraints(maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerTheme.color ?? Colors.grey,
                    width: AppBorderWidth.thin,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.package,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    'Maxsulot tanlash',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(LucideIcons.x),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Search Field
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: TextFormField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Maxsulot qidirish...',
                  prefixIcon: Icon(LucideIcons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(LucideIcons.x),
                          onPressed: () {
                            _searchController.clear();
                            _filterItems('');
                          },
                        )
                      : null,
                ),
                onChanged: _filterItems,
              ),
            ),

            // Items List
            Expanded(
              child: _filteredItems.isEmpty
                  ? Center(
                      child: Text(
                        'Maxsulot topilmadi',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final warehouseItem = _filteredItems[index];
                        final isSelected = widget.initialItem?.item.id == warehouseItem.item.id;

                        return ListTile(
                          selected: isSelected,
                          selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                          leading: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                            child: Icon(
                              LucideIcons.package,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            warehouseItem.item.name,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Barcode: ${warehouseItem.item.barcode}',
                                style: textTheme.bodySmall,
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    'Ombor: ${warehouseItem.warehouseQuantity.toStringAsFixed(1)}',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: warehouseItem.warehouseQuantity > 0 ? Colors.green : Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Do\'kon: ${warehouseItem.shopQuantity.toStringAsFixed(1)}',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: warehouseItem.shopQuantity > 0 ? Colors.blue : Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () => Navigator.of(context).pop(warehouseItem),
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
