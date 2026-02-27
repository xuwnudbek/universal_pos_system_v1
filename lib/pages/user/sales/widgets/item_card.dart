import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:universal_pos_system_v1/data/models/items_full.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';
import 'package:universal_pos_system_v1/utils/extensions/sum_extension.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onSecondaryTap,
  });

  final ItemFull item;
  final VoidCallback onTap;
  final VoidCallback onSecondaryTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final isDisabled = item.shopQuantity <= 0;

    return MouseRegion(
      cursor: isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isDisabled ? null : onTap,
        onSecondaryTap: isDisabled ? null : onSecondaryTap,
        child: Opacity(
          opacity: isDisabled ? 0.45 : 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: isDisabled ? Colors.grey : colorScheme.primary,
                width: AppBorderWidth.normal,
              ),
            ),
            padding: EdgeInsets.all(AppSpacing.xs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.md,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: item.imagePath != null && File(item.imagePath!).existsSync()
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            child: Image.file(
                              File(item.imagePath!),
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Center(
                            child: Icon(
                              LucideIcons.image,
                              size: 32,
                              color: colorScheme.primary,
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: AppSpacing.md,
                      right: AppSpacing.md,
                      bottom: AppSpacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          item.salePrice.intOrDouble.str.toSumString("UZS"),
                          style: textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              'D: ${item.shopQuantity.intOrDouble.str}',
                              style: textTheme.labelSmall?.copyWith(
                                color: item.shopQuantity > 0 ? Colors.green.shade700 : Colors.red.shade400,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(width: AppSpacing.sm),
                            Text(
                              'O: ${item.warehouseQuantity.intOrDouble.str}',
                              style: textTheme.labelSmall?.copyWith(
                                color: item.warehouseQuantity > 0 ? Colors.blue.shade700 : Colors.red.shade400,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
