import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';
import 'package:universal_pos_system_v1/data/models/items_full.dart';
import 'package:universal_pos_system_v1/pages/admin/procurements/providers/procurements_provider.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/widgets/button.dart';

class AddProcurementsModal extends StatefulWidget {
  final List<ItemFull> items;

  const AddProcurementsModal({
    super.key,
    required this.items,
  });

  @override
  State<AddProcurementsModal> createState() => _AddProcurementsModalState();
}

class _AddProcurementsModalState extends State<AddProcurementsModal> {
  final _formKey = GlobalKey<FormState>();
  final _supplierNameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  LocationsEnum _selectedLocation = LocationsEnum.warehouse;

  final List<ProcurementItemRow> _items = [];

  @override
  void dispose() {
    _supplierNameController.dispose();
    for (var item in _items) {
      item.quantityController.dispose();
      item.purchasePriceController.dispose();
    }
    super.dispose();
  }

  void _addItem() {
    setState(() {
      _items.add(
        ProcurementItemRow(
          quantityController: TextEditingController(),
          purchasePriceController: TextEditingController(),
        ),
      );
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items[index].quantityController.dispose();
      _items[index].purchasePriceController.dispose();
      _items.removeAt(index);
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_items.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kamida bitta maxsulot qo\'shing')),
        );
        return;
      }

      final itemsData = _items.map((item) {
        return ProcurementItemData(
          itemId: item.selectedItem!.id,
          quantity: double.parse(item.quantityController.text),
          purchasePrice: double.parse(item.purchasePriceController.text),
        );
      }).toList();

      Navigator.of(context).pop({
        'supplierName': _supplierNameController.text,
        'procurementDate': _selectedDate,
        'location': _selectedLocation,
        'items': itemsData,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Dialog(
      child: Container(
        width: 800,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
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
                  Text(
                    'Yangi olib kelish',
                    style: textTheme.titleLarge,
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(LucideIcons.x),
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
                      // Supplier name
                      TextFormField(
                        controller: _supplierNameController,
                        decoration: InputDecoration(
                          labelText: 'Yetkazib beruvchi nomi',
                          hintText: 'Nomi kiriting',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Yetkazib beruvchi nomini kiriting';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSpacing.md),

                      // Date picker
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            setState(() => _selectedDate = date);
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Olib kelingan sana',
                            suffixIcon: Icon(LucideIcons.calendar),
                          ),
                          child: Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: textTheme.bodyLarge,
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),

                      // Location dropdown
                      DropdownButtonFormField<LocationsEnum>(
                        value: _selectedLocation,
                        decoration: InputDecoration(
                          labelText: 'Qayerga keladi',
                        ),
                        items: LocationsEnum.values.map((location) {
                          return DropdownMenuItem(
                            value: location,
                            child: Text(
                              location == LocationsEnum.warehouse ? 'Ombor' : 'Do\'kon',
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedLocation = value);
                          }
                        },
                      ),
                      SizedBox(height: AppSpacing.lg),

                      // Items section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Maxsulotlar',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Button(
                            onPressed: _addItem,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.plus, size: 16),
                                SizedBox(width: 4),
                                Text('Maxsulot qo\'shish'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.md),

                      // Items list
                      if (_items.isEmpty)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(AppSpacing.lg),
                            child: Text(
                              'Maxsulot qo\'shilmagan',
                              style: textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      else
                        ..._items.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;

                          return Card(
                            margin: EdgeInsets.only(bottom: AppSpacing.md),
                            child: Padding(
                              padding: EdgeInsets.all(AppSpacing.md),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Maxsulot ${index + 1}',
                                        style: textTheme.titleSmall,
                                      ),
                                      Spacer(),
                                      IconButton(
                                        icon: Icon(LucideIcons.trash2, size: 18),
                                        color: Colors.red,
                                        onPressed: () => _removeItem(index),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: AppSpacing.sm),
                                  DropdownButtonFormField<ItemFull>(
                                    value: item.selectedItem,
                                    decoration: InputDecoration(
                                      labelText: 'Maxsulot',
                                      isDense: true,
                                    ),
                                    items: widget.items.map((itemFull) {
                                      return DropdownMenuItem(
                                        value: itemFull,
                                        child: Text(itemFull.name),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() => item.selectedItem = value);
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Maxsulot tanlang';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: AppSpacing.sm),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: item.quantityController,
                                          decoration: InputDecoration(
                                            labelText: 'Miqdori',
                                            isDense: true,
                                          ),
                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Miqdorni kiriting';
                                            }
                                            if (double.tryParse(value) == null) {
                                              return 'Raqam kiriting';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(width: AppSpacing.sm),
                                      Expanded(
                                        child: TextFormField(
                                          controller: item.purchasePriceController,
                                          decoration: InputDecoration(
                                            labelText: 'Sotib olish narxi',
                                            isDense: true,
                                          ),
                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Narxni kiriting';
                                            }
                                            if (double.tryParse(value) == null) {
                                              return 'Raqam kiriting';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
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
                    onPressed: _submit,
                    child: Text('Saqlash'),
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

class ProcurementItemRow {
  ItemFull? selectedItem;
  final TextEditingController quantityController;
  final TextEditingController purchasePriceController;

  ProcurementItemRow({
    this.selectedItem,
    required this.quantityController,
    required this.purchasePriceController,
  });
}
