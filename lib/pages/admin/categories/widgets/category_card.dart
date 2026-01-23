import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:universal_pos_system_v1/data/models/item_category_full.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';

import 'package:universal_pos_system_v1/utils/functions/string_to_hex.dart';
import 'package:universal_pos_system_v1/utils/theme/app_colors.dart';
import 'package:universal_pos_system_v1/widgets/icon_button2.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    this.itemCount,
    required this.onDelete,
    required this.onEdit,
  });

  final ItemCategoryFull category;
  final int? itemCount;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  Color get categoryColor {
    return Color(hexToColor(category.color!.hex));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.border,
          width: AppBorderWidth.thin,
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          ListTile(
            leading: Card(
              elevation: 0.0,
              color: categoryColor,
              child: SizedBox(
                width: 40,
                height: 40,
              ),
            ),
            title: Text(category.name),
            subtitle: Text("${itemCount ?? 0} maxsulot"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 4,
            children: [
              IconButton2(
                onPressed: onEdit,
                icon: LucideIcons.edit,
                type: IconButton2Type.primary,
              ),
              IconButton2(
                onPressed: onDelete,
                icon: LucideIcons.trash2,
                type: IconButton2Type.danger,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
