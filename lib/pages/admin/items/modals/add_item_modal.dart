import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/models/item_category_full.dart';
import 'package:universal_pos_system_v1/data/models/items_full.dart';
import 'package:universal_pos_system_v1/models/item_form_result.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/router/app_router.dart';
import 'package:universal_pos_system_v1/widgets/button.dart';

class AddItemModal extends StatefulWidget {
  const AddItemModal({
    super.key,
    this.item,
    required this.categories,
    required this.units,
  });

  final ItemFull? item;
  final List<ItemCategoryFull> categories;
  final List<Unit> units;

  @override
  State<AddItemModal> createState() => _AddItemModalState();
}

class _AddItemModalState extends State<AddItemModal> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _barcodeCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  ItemCategoryFull? _selectedCategory;
  Unit? _selectedUnit;

  @override
  void initState() {
    final item = widget.item;

    if (item != null) {
      _nameCtrl.text = item.name;
      _barcodeCtrl.text = item.barcode;
      _priceCtrl.text = item.price.toString();

      // Find the matching category from widget.categories by ID
      _selectedCategory = widget.categories.where((c) => c.id == item.category?.id).firstOrNull;
      _selectedUnit = widget.units.where((u) => u.id == item.unit.id).firstOrNull;
    } else {
      // Auto-generate barcode for new items
      _barcodeCtrl.text = _generateBarcode();
      // _selectedCategory = widget.categories.firstOrNull;
      // _selectedUnit = widget.units.firstOrNull;
    }

    super.initState();
  }

  String _generateBarcode() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return timestamp.toString();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null || _selectedUnit == null) {
      return;
    }

    final result = ItemFormResult(
      name: _nameCtrl.text.trim(),
      barcode: _barcodeCtrl.text.trim(),
      price: double.parse(_priceCtrl.text),
      stock: 0,
      categoryId: _selectedCategory!.id,
      unitId: _selectedUnit!.id,
    );

    Navigator.of(context).pop(result);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _barcodeCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    final textTheme = theme.textTheme;

    return AlertDialog(
      constraints: BoxConstraints(
        maxWidth: mq.size.width * 0.7,
        minWidth: mq.size.width * 0.5,
        maxHeight: mq.size.height * 0.8,
      ),
      title: Text(widget.item == null ? "Yangi mahsulot" : "Mahsulotni tahrirlash"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                spacing: AppSpacing.md,
                children: [
                  Expanded(child: _field(_nameCtrl, 'Mahsulot nomi')),
                  Expanded(child: _field(_barcodeCtrl, 'Barcode', readOnly: true)),
                ],
              ),
              Row(
                spacing: AppSpacing.md,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DropdownButtonFormField<ItemCategoryFull>(
                        initialValue: _selectedCategory,
                        items: widget.categories.map((c) {
                          return DropdownMenuItem(
                            value: c,
                            child: Text(c.name),
                          );
                        }).toList(),
                        onChanged: (v) => setState(() => _selectedCategory = v!),
                        menuMaxHeight: 300,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        decoration: InputDecoration(labelText: 'Kategoriya'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: _field(
                      _priceCtrl,
                      'Sotish narxi',
                      isNumber: true,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DropdownButtonFormField<Unit>(
                        initialValue: _selectedUnit,
                        items: widget.units.map((u) {
                          return DropdownMenuItem(
                            value: u,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: u.shortName,
                                    style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(text: ' ('),
                                  TextSpan(
                                    text: u.name,
                                    style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                                  ),
                                  TextSpan(text: ')'),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (v) => setState(() => _selectedUnit = v!),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        menuMaxHeight: 300,
                        decoration: InputDecoration(labelText: 'O\'lchov birligi'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => appRouter.pop(),
          child: const Text('Bekor qilish'),
        ),
        Button(
          onPressed: _submit,
          child: const Text('Saqlash'),
        ),
      ],
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    bool isNumber = false,
    bool readOnly = false,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        readOnly: readOnly,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
          suffixIcon: readOnly ? Icon(Icons.lock_outline, size: 16) : null,
        ),
        inputFormatters: inputFormatters,
        validator: (v) => v == null || v.trim().isEmpty ? '$label ni kiritish majburiy' : null,
      ),
    );
  }
}
