import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/data/models/procurement_full.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/widgets/button.dart';

class DeleteProcurementModal extends StatelessWidget {
  const DeleteProcurementModal({
    super.key,
    required this.procurement,
  });

  final ProcurementFull procurement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(
              "Olib kelishni o'chirish",
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ushbu olib kelishni o'chirishni xohlaysizmi?",
            style: textTheme.bodyLarge,
          ),
          SizedBox(height: AppSpacing.md),
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Yetkazib beruvchi:",
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        procurement.supplierName,
                        style: textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Text(
                      "Sana:",
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      '${procurement.procurementDate.day}/${procurement.procurementDate.month}/${procurement.procurementDate.year}',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Text(
                      "Joylashgan:",
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      procurement.location.name == 'warehouse' ? 'Ombor' : 'Do\'kon',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Container(
            padding: EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_rounded,
                  color: theme.colorScheme.error,
                  size: 20,
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    "Bu amalni qaytarib bo'lmaydi!",
                    style: textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Bekor qilish'),
        ),
        Button(
          primaryColor: theme.colorScheme.error,
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('O\'chirish'),
        ),
      ],
    );
  }
}
