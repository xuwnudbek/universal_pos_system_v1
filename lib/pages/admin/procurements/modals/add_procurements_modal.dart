import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';
import 'package:universal_pos_system_v1/data/models/items_full.dart';
import 'package:universal_pos_system_v1/models/procurements/procurement_form_result.dart';
import 'package:universal_pos_system_v1/models/procurements/procurement_item_data.dart';
import 'package:universal_pos_system_v1/pages/admin/procurements/widgets/searchable_item_dialog.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';
import 'package:universal_pos_system_v1/utils/formatters/sum_input_formatter.dart';
import 'package:universal_pos_system_v1/widgets/button.dart';
import 'package:universal_pos_system_v1/widgets/icon_button2.dart';

class AddProcurementsModal extends StatefulWidget {
  final List<ItemFull> items;
  final ProcurementFormResult? initialData;

  const AddProcurementsModal({
    super.key,
    required this.items,
    this.initialData,
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
  double _totalSum = 0;

  @override
  void initState() {
    super.initState();
    final initialData = widget.initialData;

    if (initialData != null) {
      _supplierNameController.text = initialData.supplierName;
      _selectedDate = initialData.procurementDate;
      _selectedLocation = initialData.location;

      if (initialData.items.isNotEmpty) {
        for (final itemData in initialData.items) {
          final matchedItems = widget.items.where((i) => i.id == itemData.itemId);
          final selectedItem = matchedItems.isNotEmpty ? matchedItems.first : null;

          final row = ProcurementItemRow(
            selectedItem: selectedItem,
            quantityController: TextEditingController(text: itemData.quantity.toString()),
            purchasePriceController: TextEditingController(text: itemData.purchasePrice.toString()),
          );
          row.quantityController.addListener(_recalculateTotal);
          row.purchasePriceController.addListener(_recalculateTotal);
          _items.add(row);
        }
        _recalculateTotal();
        return;
      }
    }

    // Default holatda 1 ta maydon qo'shish
    _addItem();
  }

  @override
  void dispose() {
    _supplierNameController.dispose();
    for (var item in _items) {
      item.quantityController.removeListener(_recalculateTotal);
      item.purchasePriceController.removeListener(_recalculateTotal);
      item.quantityController.dispose();
      item.purchasePriceController.dispose();
    }
    super.dispose();
  }

  void _addItem() {
    setState(() {
      final newItem = ProcurementItemRow(
        quantityController: TextEditingController(),
        purchasePriceController: TextEditingController(),
      );
      newItem.quantityController.addListener(_recalculateTotal);
      newItem.purchasePriceController.addListener(_recalculateTotal);
      _items.add(newItem);
    });
    _recalculateTotal();
  }

  void _removeItem(int index) {
    setState(() {
      _items[index].quantityController.removeListener(_recalculateTotal);
      _items[index].purchasePriceController.removeListener(_recalculateTotal);
      _items[index].quantityController.dispose();
      _items[index].purchasePriceController.dispose();
      _items.removeAt(index);
    });
    _recalculateTotal();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_items.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kamida bitta maxsulot qo\'shing')),
        );
        return;
      }

      // Validate all items have selected item
      for (var item in _items) {
        if (item.selectedItem == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Barcha maxsulotlarni tanlang')),
          );
          return;
        }
      }

      final itemsData = _items.map((item) {
        return ProcurementItemData(
          itemId: item.selectedItem!.id,
          quantity: double.parse(item.quantityController.text.replaceAll(' ', '')),
          purchasePrice: double.parse(item.purchasePriceController.text.replaceAll(' ', '')),
        );
      }).toList();

      Navigator.of(context).pop(
        ProcurementFormResult(
          supplierName: _supplierNameController.text,
          procurementDate: _selectedDate,
          location: _selectedLocation,
          items: itemsData,
        ),
      );
    }
  }

  double _calculateTotal() {
    double total = 0;
    for (var item in _items) {
      final quantityText = item.quantityController.text.replaceAll(' ', '');
      final priceText = item.purchasePriceController.text.replaceAll(' ', '');

      final quantity = double.tryParse(quantityText) ?? 0;
      final price = double.tryParse(priceText) ?? 0;

      total += quantity * price;
    }
    return total;
  }

  void _recalculateTotal() {
    final total = _calculateTotal();
    if (total != _totalSum) {
      setState(() => _totalSum = total);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isEditMode = widget.initialData != null;

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
                    isEditMode ? 'Olib kelishni tahrirlash' : 'Yangi olib kelish',
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Header section (supplier, date, location) - Fixed
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.lg,
                        AppSpacing.lg,
                        0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
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
                          ),
                          SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: InkWell(
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
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Olib kelingan sana',
                                  suffixIcon: Icon(
                                    LucideIcons.calendar,
                                    size: 18,
                                  ),
                                ),
                                child: Text(
                                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                  style: textTheme.bodyLarge,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: DropdownButtonFormField<LocationsEnum>(
                              initialValue: _selectedLocation,
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
                              alignment: AlignmentDirectional.bottomCenter,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              menuMaxHeight: 300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),

                    // Items section header - Fixed
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Maxsulotlar',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
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
                    ),
                    SizedBox(height: AppSpacing.md),

                    // Items list - Scrollable
                    Expanded(
                      child: _items.isEmpty
                          ? Center(child: Text('Maxsulotlar mavjud emas'))
                          : GridView.builder(
                              padding: EdgeInsets.only(
                                left: AppSpacing.lg,
                                right: AppSpacing.lg,
                                bottom: AppSpacing.lg,
                              ),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: AppSpacing.md,
                                mainAxisSpacing: AppSpacing.md,
                                mainAxisExtent: 205,
                              ),
                              itemCount: _items.length,
                              itemBuilder: (context, index) {
                                return _buildItemCard(index, _items[index]);
                              },
                            ),
                    ),
                  ],
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
                  // Total sum display
                  Row(
                    spacing: AppSpacing.sm,
                    children: [
                      Icon(
                        LucideIcons.calculator,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      Text(
                        'Jami:',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        _totalSum.toSum,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Bekor qilish'),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Button(
                    onPressed: _submit,
                    child: Text(isEditMode ? 'Yangilash' : 'Saqlash'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(int index, ProcurementItemRow item) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: AppSpacing.sm),
                Text(
                  'Maxsulot ${index + 1}',
                  style: textTheme.titleSmall,
                ),
                Spacer(),
                IconButton2(
                  icon: LucideIcons.trash2,
                  type: IconButton2Type.danger,
                  onPressed: () => _removeItem(index),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            InkWell(
              borderRadius: BorderRadius.circular(AppRadius.md),
              onTap: () async {
                final selectedItem = await showDialog<ItemFull>(
                  context: context,
                  builder: (context) => SearchableItemDialog(
                    items: widget.items,
                    initialItem: item.selectedItem,
                  ),
                );
                if (selectedItem != null) {
                  setState(() => item.selectedItem = selectedItem);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Maxsulot',
                  isDense: true,
                  suffixIcon: Icon(LucideIcons.search, size: 18),
                ),
                child: Text(
                  item.selectedItem?.name ?? 'Maxsulot tanlang',
                  style: textTheme.bodyMedium?.copyWith(
                    color: item.selectedItem == null ? Colors.grey : null,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: item.quantityController,
              decoration: InputDecoration(
                labelText: item.selectedItem != null ? 'Miqdori (${item.selectedItem!.unit.shortName})' : 'Miqdori',
                isDense: true,
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [SumInputFormatter()],
              textInputAction: TextInputAction.next,
              validator: (value) {
                value = value?.replaceAll(' ', '');

                if (value == null || value.isEmpty) {
                  return 'Miqdorni kiriting';
                }

                if (double.tryParse(value) == null) {
                  return 'Raqam kiriting';
                }
                return null;
              },
            ),
            SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: item.purchasePriceController,
              decoration: InputDecoration(
                labelText: 'Sotib olingan narxi ${item.selectedItem != null ? '( 1 ${item.selectedItem!.unit.name.toLowerCase()} )' : ''}',
                isDense: true,
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [SumInputFormatter()],
              textInputAction: index < _items.length - 1 ? TextInputAction.next : TextInputAction.done,
              validator: (value) {
                value = value?.replaceAll(' ', '');
                if (value == null || value.isEmpty) {
                  return 'Narxni kiriting';
                }
                if (double.tryParse(value.trim()) == null) {
                  return 'Raqam kiriting';
                }
                return null;
              },
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
