import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';
import 'package:universal_pos_system_v1/data/models/items_full.dart';
import 'package:universal_pos_system_v1/models/warehouse/warehouse_item.dart';
import 'package:universal_pos_system_v1/pages/admin/warehouse/widgets/searchable_warehouse_item_dialog.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';
import 'package:universal_pos_system_v1/widgets/button.dart';

class TransferFormResult {
  final ItemFull item;
  final LocationsEnum fromLocation;
  final LocationsEnum toLocation;
  final double quantity;
  final String? note;

  TransferFormResult({
    required this.item,
    required this.fromLocation,
    required this.toLocation,
    required this.quantity,
    this.note,
  });
}

class WarehouseTransferModal extends StatefulWidget {
  final List<WarehouseItem> warehouseItems;

  const WarehouseTransferModal({
    super.key,
    required this.warehouseItems,
  });

  @override
  State<WarehouseTransferModal> createState() => _WarehouseTransferModalState();
}

class _WarehouseTransferModalState extends State<WarehouseTransferModal> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _noteController = TextEditingController();

  WarehouseItem? _selectedWarehouseItem;
  LocationsEnum _fromLocation = LocationsEnum.warehouse;
  LocationsEnum _toLocation = LocationsEnum.shop;

  double _availableQuantity = 0;

  @override
  void dispose() {
    _quantityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _updateAvailableQuantity() {
    if (_selectedWarehouseItem == null) {
      _availableQuantity = 0;
      return;
    }

    if (_fromLocation == LocationsEnum.warehouse) {
      _availableQuantity = _selectedWarehouseItem!.warehouseQuantity;
    } else {
      _availableQuantity = _selectedWarehouseItem!.shopQuantity;
    }
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
                    LucideIcons.arrowRightLeft,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    'Maxsulot ko\'chirish',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(LucideIcons.x, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item Selection with Search
                      Text(
                        'Maxsulot',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      InkWell(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        onTap: () async {
                          final selectedItem = await showDialog<WarehouseItem>(
                            context: context,
                            builder: (context) => SearchableWarehouseItemDialog(
                              warehouseItems: widget.warehouseItems,
                              initialItem: _selectedWarehouseItem,
                            ),
                          );
                          if (selectedItem != null) {
                            setState(() {
                              _selectedWarehouseItem = selectedItem;
                              _updateAvailableQuantity();
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Maxsulot',
                            isDense: true,
                            suffixIcon: Icon(LucideIcons.search, size: 18),
                          ),
                          child: Text(
                            _selectedWarehouseItem?.item.name ?? 'Maxsulot tanlang',
                            style: textTheme.bodyMedium?.copyWith(
                              color: _selectedWarehouseItem == null ? Colors.grey : null,
                            ),
                          ),
                        ),
                      ),

                      if (_selectedWarehouseItem != null) ...[
                        SizedBox(height: AppSpacing.lg),
                        // Locations Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // From Location
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Qayerdan',
                                    style: textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: AppSpacing.sm),
                                  DropdownButtonFormField<LocationsEnum>(
                                    initialValue: _fromLocation,
                                    borderRadius: BorderRadius.circular(AppRadius.md),
                                    menuMaxHeight: 300,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(LucideIcons.mapPin, size: 18),
                                    ),
                                    isDense: true,
                                    items: [
                                      DropdownMenuItem(
                                        value: LocationsEnum.warehouse,
                                        child: Text('Ombor'),
                                      ),
                                      DropdownMenuItem(
                                        value: LocationsEnum.shop,
                                        child: Text('Do\'kon'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          _fromLocation = value;
                                          // Ensure toLocation is different
                                          if (_fromLocation == _toLocation) {
                                            _toLocation = _fromLocation == LocationsEnum.warehouse ? LocationsEnum.shop : LocationsEnum.warehouse;
                                          }
                                          _updateAvailableQuantity();
                                        });
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Joylashuvni tanlang';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: AppSpacing.xs),
                                  Row(
                                    children: [
                                      SizedBox(width: AppSpacing.sm),
                                      Text(
                                        'Qoldiq: ',
                                        style: textTheme.bodySmall?.copyWith(),
                                      ),
                                      Text(
                                        _fromLocation == LocationsEnum.warehouse ? _selectedWarehouseItem!.warehouseQuantity.intOrDouble.str : _selectedWarehouseItem!.shopQuantity.intOrDouble.str,
                                        style: textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      // units
                                      SizedBox(width: 4),
                                      Text(
                                        _selectedWarehouseItem!.item.unit.shortName,
                                        style: textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: AppSpacing.sm),
                            // Swap Button
                            Padding(
                              padding: EdgeInsets.only(top: 28),
                              child: IconButton(
                                icon: Icon(LucideIcons.arrowLeftRight, size: 20),
                                onPressed: () {
                                  setState(() {
                                    final temp = _fromLocation;
                                    _fromLocation = _toLocation;
                                    _toLocation = temp;
                                    _updateAvailableQuantity();
                                  });
                                },
                                tooltip: 'Almashtirish',
                                style: IconButton.styleFrom(
                                  foregroundColor: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            SizedBox(width: AppSpacing.sm),
                            // To Location
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Qayerga',
                                    style: textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: AppSpacing.sm),
                                  DropdownButtonFormField<LocationsEnum>(
                                    initialValue: _toLocation,
                                    borderRadius: BorderRadius.circular(AppRadius.md),
                                    menuMaxHeight: 300,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(LucideIcons.mapPin, size: 18),
                                    ),

                                    items: [
                                      DropdownMenuItem(
                                        value: LocationsEnum.warehouse,
                                        child: Text('Ombor'),
                                      ),
                                      DropdownMenuItem(
                                        value: LocationsEnum.shop,
                                        child: Text('Do\'kon'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          _toLocation = value;
                                        });
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Joylashuvni tanlang';
                                      }
                                      if (value == _fromLocation) {
                                        return 'Bir xil joylashuvga ko\'chirib bo\'lmaydi';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: AppSpacing.xs),
                                  Row(
                                    children: [
                                      SizedBox(width: AppSpacing.sm),
                                      Text(
                                        'Qoldiq: ',
                                        style: textTheme.bodySmall?.copyWith(),
                                      ),
                                      Text(
                                        _toLocation == LocationsEnum.warehouse ? _selectedWarehouseItem!.warehouseQuantity.intOrDouble.str : _selectedWarehouseItem!.shopQuantity.intOrDouble.str,
                                        style: textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        _selectedWarehouseItem!.item.unit.shortName,
                                        style: textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: AppSpacing.md),

                        // Quantity
                        Text(
                          'Miqdor',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        TextFormField(
                          controller: _quantityController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            hintText: 'Miqdorni kiriting',
                            prefixIcon: Icon(LucideIcons.hash, size: 18),
                            helperText: 'Maksimal: ${_availableQuantity.intOrDouble.str} ${_selectedWarehouseItem!.item.unit.shortName}',
                            helperStyle: textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Miqdorni kiriting';
                            }
                            final quantity = double.tryParse(value);
                            if (quantity == null) {
                              return 'Noto\'g\'ri miqdor';
                            }
                            if (quantity <= 0) {
                              return 'Miqdor 0 dan katta bo\'lishi kerak';
                            }
                            if (quantity > _availableQuantity) {
                              return 'Mavjud miqdordan oshib ketdi';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: AppSpacing.md),

                        // Note (optional)
                        Text(
                          'Izoh (ixtiyoriy)',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        TextFormField(
                          controller: _noteController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Izoh yozing...',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.dividerTheme.color ?? Colors.grey,
                    width: AppBorderWidth.thin,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Bekor qilish'),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Button(
                    onPressed: _selectedWarehouseItem == null
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              final result = TransferFormResult(
                                item: _selectedWarehouseItem!.item,
                                fromLocation: _fromLocation,
                                toLocation: _toLocation,
                                quantity: double.parse(_quantityController.text),
                                note: _noteController.text.isNotEmpty ? _noteController.text : null,
                              );
                              Navigator.of(context).pop(result);
                            }
                          },
                    child: Text('Ko\'chirish'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
