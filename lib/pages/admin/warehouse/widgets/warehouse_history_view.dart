import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:universal_pos_system_v1/data/models/transfer_full.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/extensions/date_time_extension.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';
import 'package:universal_pos_system_v1/utils/theme/app_colors.dart';
import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';

class WarehouseHistoryView extends StatelessWidget {
  final List<TransferFull> transfers;
  final PaginatorController paginatorController;

  const WarehouseHistoryView({
    super.key,
    required this.transfers,
    required this.paginatorController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    if (transfers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.history,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              "Ko'chirish tarixi mavjud emas",
              style: textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
            minWidth: 1200,
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
                size: ColumnSize.M,
              ),
              // From Location
              DataColumn2(
                headingRowAlignment: MainAxisAlignment.center,
                label: Text(
                  'Qayerdan',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                size: ColumnSize.S,
              ),
              // To Location
              DataColumn2(
                headingRowAlignment: MainAxisAlignment.center,
                label: Text(
                  'Qayerga',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                size: ColumnSize.S,
              ),
              // Quantity
              DataColumn2(
                label: Text(
                  'Miqdor',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                size: ColumnSize.S,
                numeric: true,
              ),
              // Date
              DataColumn2(
                headingRowAlignment: MainAxisAlignment.center,
                label: Text(
                  'Sana',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                size: ColumnSize.M,
              ),
              // Note
              DataColumn2(
                label: Text(
                  'Izoh',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                size: ColumnSize.L,
              ),
            ],
            source: _TransferHistoryDataSource(
              transfers: transfers,
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

class _TransferHistoryDataSource extends DataTableSource {
  final List<TransferFull> transfers;
  final BuildContext context;
  final TextTheme textTheme;
  final ThemeData theme;

  _TransferHistoryDataSource({
    required this.transfers,
    required this.context,
    required this.textTheme,
    required this.theme,
  });

  String _getLocationName(LocationsEnum location) {
    return location == LocationsEnum.warehouse ? 'Ombor' : 'Do\'kon';
  }

  @override
  DataRow? getRow(int index) {
    if (index >= transfers.length) return null;

    final transferFull = transfers[index];
    final transfer = transferFull.transfer;
    final item = transferFull.item;

    return DataRow2(
      cells: [
        // Item name
        DataCell(
          Text(
            item.name,
            style: textTheme.bodyMedium,
          ),
        ),
        // From Location
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: transfer.fromLocation == LocationsEnum.warehouse ? Colors.blue.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      transfer.fromLocation == LocationsEnum.warehouse ? LucideIcons.warehouse : LucideIcons.store,
                      size: 14,
                      color: transfer.fromLocation == LocationsEnum.warehouse ? Colors.blue : Colors.green,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      _getLocationName(transfer.fromLocation),
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: transfer.fromLocation == LocationsEnum.warehouse ? Colors.blue : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // To Location
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: transfer.toLocation == LocationsEnum.warehouse ? Colors.blue.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      transfer.toLocation == LocationsEnum.warehouse ? LucideIcons.warehouse : LucideIcons.store,
                      size: 14,
                      color: transfer.toLocation == LocationsEnum.warehouse ? Colors.blue : Colors.green,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      _getLocationName(transfer.toLocation),
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: transfer.toLocation == LocationsEnum.warehouse ? Colors.blue : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Quantity
        DataCell(
          Text(
            '${transfer.quantity.intOrDouble.str} ${item.unit.shortName}',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        // Date
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.calendar,
                size: 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              SizedBox(width: AppSpacing.xs),
              Text(
                transfer.createdAt.toFormattedString(),
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ),
        // Note
        DataCell(
          Text(
            transfer.note ?? '-',
            style: textTheme.bodySmall?.copyWith(
              color: transfer.note != null ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withValues(alpha: 0.4),
              fontStyle: transfer.note == null ? FontStyle.italic : null,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => transfers.length;

  @override
  int get selectedRowCount => 0;
}
