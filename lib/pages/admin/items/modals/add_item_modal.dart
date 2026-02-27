import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/models/item_category_full.dart';
import 'package:universal_pos_system_v1/data/models/items_full.dart';
import 'package:universal_pos_system_v1/models/item_form_result.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';
import 'package:universal_pos_system_v1/utils/extensions/sum_extension.dart';
import 'package:universal_pos_system_v1/utils/formatters/sum_input_formatter.dart';
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
  final _salePriceCtrl = TextEditingController();

  ItemCategoryFull? _selectedCategory;
  Unit? _selectedUnit;

  String? _imagePath;
  File? _imageFile;

  @override
  void initState() {
    final item = widget.item;

    if (item != null) {
      _nameCtrl.text = item.name;
      _barcodeCtrl.text = item.barcode;
      _salePriceCtrl.text = item.salePrice.intOrDouble.str.toSumString();
      // Find the matching category from widget.categories by ID
      _selectedCategory = widget.categories.where((c) => c.id == item.category?.id).firstOrNull;
      _selectedUnit = widget.units.where((u) => u.id == item.unit.id).firstOrNull;
      _imagePath = item.imagePath;
      if (_imagePath != null && File(_imagePath!).existsSync()) {
        _imageFile = File(_imagePath!);
      }
    } else {
      // Auto-generate barcode for new items
      _barcodeCtrl.text = _generateBarcode();
    }

    super.initState();
  }

  String _generateBarcode() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return timestamp.toString();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      final pickedFile = File(result.files.single.path!);
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(p.join(appDir.path, 'upossystem', 'item_images'));

      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final ext = p.extension(pickedFile.path);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}$ext';
      final savedFile = await pickedFile.copy(p.join(imagesDir.path, fileName));

      setState(() {
        _imagePath = savedFile.path;
        _imageFile = savedFile;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _imagePath = null;
      _imageFile = null;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null || _selectedUnit == null) {
      return;
    }

    final result = ItemFormResult(
      name: _nameCtrl.text.trim(),
      barcode: _barcodeCtrl.text.trim(),
      categoryId: _selectedCategory!.id,
      unitId: _selectedUnit!.id,
      salePrice: double.tryParse(_salePriceCtrl.text.replaceAll(' ', '')) ?? 0,
      imagePath: _imagePath,
    );

    Navigator.of(context).pop(result);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _barcodeCtrl.dispose();
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
      title: Row(
        children: [
          Expanded(
            child: Text(widget.item == null ? "Yangi mahsulot" : "Mahsulotni tahrirlash"),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image picker section
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: theme.colorScheme.outline,
                            width: AppBorderWidth.thin,
                          ),
                        ),
                        child: _imageFile != null
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(AppRadius.md),
                                    child: Image.file(
                                      _imageFile!,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: _removeImage,
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          LucideIcons.x,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    LucideIcons.imagePlus,
                                    size: 32,
                                    color: theme.colorScheme.onSurface.withValues(alpha: .5),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Rasm tanlash',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface.withValues(alpha: .5),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                spacing: AppSpacing.md,
                children: [
                  Expanded(flex: 3, child: _field(_nameCtrl, 'Mahsulot nomi')),
                  Expanded(
                    flex: 2,
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
                        decoration: InputDecoration(
                          labelText: 'Kategoriya',
                        ),
                      ),
                    ),
                  ),
                  Expanded(flex: 2, child: _field(_barcodeCtrl, 'Barcode')),
                ],
              ),
              Row(
                spacing: AppSpacing.md,
                children: [
                  Expanded(
                    child: _field(_salePriceCtrl, 'Sotish narxi', isNumber: true, inputFormatters: [SumInputFormatter()]),
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
          onPressed: () => context.pop(),
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
