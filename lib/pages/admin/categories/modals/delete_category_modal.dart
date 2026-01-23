import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/data/models/item_category_full.dart';
import 'package:universal_pos_system_v1/utils/theme/app_colors.dart';
import 'package:universal_pos_system_v1/widgets/button.dart';

class DeleteCategoryModal extends StatefulWidget {
  const DeleteCategoryModal({
    super.key,
    required this.category,
  });

  final ItemCategoryFull category;

  @override
  State<DeleteCategoryModal> createState() => _DeleteCategoryModalState();
}

class _DeleteCategoryModalState extends State<DeleteCategoryModal> {
  void _onDelete() {
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return AlertDialog(
      constraints: BoxConstraints(
        maxWidth: mq.size.width * 0.3,
        minWidth: mq.size.width * 0.3,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text("Kategoriya o'chirish"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              text: "Haqiqatdan ham bu ",
              children: [
                TextSpan(
                  text: widget.category.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: " kategoriyasini o'chirishni xohlaysizmi?"),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
          ),
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Bekor qilish'),
        ),
        Button(
          primaryColor: AppColors.error,
          onPressed: _onDelete,
          child: const Text('O\'chirish'),
        ),
      ],
    );
  }
}
