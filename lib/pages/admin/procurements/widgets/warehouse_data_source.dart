import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:universal_pos_system_v1/models/warehouse/warehouse_item.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';
import 'package:universal_pos_system_v1/utils/functions/string_to_hex.dart';

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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.md,
            children: [
              if (item.category?.color != null)
                Icon(
                  LucideIcons.box,
                  size: 16,
                  color: Color(hexToColor(item.category!.color!.hex)),
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
            warehouseItem.warehouseQuantity.intOrDouble.str,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: warehouseItem.warehouseQuantity > 0 ? Colors.green : Colors.grey,
            ),
          ),
        ),
        DataCell(
          Text(
            warehouseItem.shopQuantity.intOrDouble.str,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: warehouseItem.shopQuantity > 0 ? Colors.blue : Colors.grey,
            ),
          ),
        ),
        // Total cell
        DataCell(
          Text(
            warehouseItem.totalQuantity.intOrDouble.str,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: warehouseItem.totalQuantity > 0 ? theme.colorScheme.primary : Colors.red,
            ),
          ),
        ),
        // Unit cell
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.unit.shortName,
                style: textTheme.bodyMedium,
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
  int get rowCount => warehouseItems.length;

  @override
  int get selectedRowCount => 0;
}
