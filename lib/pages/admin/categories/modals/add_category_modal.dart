import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart' show CategoryColor;
import 'package:universal_pos_system_v1/data/models/item_category_full.dart';
import 'package:universal_pos_system_v1/pages/admin/categories/categories_page.dart';
import 'package:universal_pos_system_v1/utils/router/app_router.dart';
import 'package:universal_pos_system_v1/widgets/button.dart';

class AddCategoryModal extends StatefulWidget {
  const AddCategoryModal({
    super.key,
    this.category,
    required this.colors,
  });

  final ItemCategoryFull? category;
  final List<CategoryColor> colors;

  @override
  State<AddCategoryModal> createState() => _AddCategoryModalState();
}

class _AddCategoryModalState extends State<AddCategoryModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();

      if (_selectedColor == null) {
        return;
      }

      final itemCategoryNameAndColor = ItemCategoryNameAndColor(
        name,
        _selectedColor!.id,
      );

      Navigator.of(context).pop(itemCategoryNameAndColor);
    }
  }

  CategoryColor? _selectedColor;
  void _selectColor(CategoryColor? color) {
    setState(() {
      _selectedColor = color;
    });
  }

  @override
  void initState() {
    _nameController.text = widget.category?.name ?? "";
    _selectedColor = widget.category?.color ?? widget.colors.firstOrNull;

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return AlertDialog(
      constraints: BoxConstraints(
        maxWidth: mq.size.width * 0.5,
        minWidth: mq.size.width * 0.3,
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(widget.category == null ? "Yangi kategoriya" : "Kategoriya tahrirlash"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(
                fillColor: Color(0x0000007b),
                labelText: 'Kategoriya nomi',
                hintText: 'Masalan: Kiyim',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Kategoriya nomi bo\'lishi shart';
                }
                return null;
              },
              onFieldSubmitted: (_) => _submit(),
            ),
          ),
          SizedBox(height: 16),
          // Select Color
          SizedBox(
            width: mq.size.width * 0.3,
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: widget.colors.length,
              itemBuilder: (context, index) {
                final color = widget.colors[index];

                bool isSelected = _selectedColor == color;
                Color checkColor = isSelected ? Colors.white : Colors.black;

                return GestureDetector(
                  onTap: () => _selectColor(color),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(int.parse(color.hex, radix: 16)).withValues(alpha: 1),
                    ),
                    child: isSelected ? Icon(LucideIcons.check, color: checkColor) : null,
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 8),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          onPressed: () => appRouter.pop(),
          child: const Text('Bekor qilish'),
        ),
        Button(
          onPressed: _submit,
          child: const Text('Qo\'shish'),
        ),
      ],
    );
  }
}
