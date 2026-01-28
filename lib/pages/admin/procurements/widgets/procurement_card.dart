import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/data/models/procurement_full.dart';
import 'package:universal_pos_system_v1/pages/admin/procurements/modals/delete_procurement_modal.dart';
import 'package:universal_pos_system_v1/pages/admin/procurements/providers/procurements_provider.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';
import 'package:universal_pos_system_v1/utils/theme/app_colors.dart';

class ProcurementCard extends StatelessWidget {
  const ProcurementCard({
    super.key,
    required this.procurement,
  });

  final ProcurementFull procurement;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: AppColors.border,
          width: AppBorderWidth.thin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.user,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    procurement.supplierName,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(LucideIcons.trash2, size: 18),
                  color: Colors.red,
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => DeleteProcurementModal(procurement: procurement),
                    );

                    if (confirm == true && context.mounted) {
                      await context.read<ProcurementsProvider>().deleteProcurement(procurement.id);
                    }
                  },
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.calendar, size: 16, color: Colors.grey),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        '${procurement.procurementDate.day}/${procurement.procurementDate.month}/${procurement.procurementDate.year}',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(LucideIcons.mapPin, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm / 2),
                          child: Text(
                            procurement.location.name == 'warehouse' ? 'Ombor' : 'Do\'kon',
                            style: textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Divider(),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'Maxsulotlar: ${procurement.itemsCount} ta',
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Jami: ${procurement.totalCost.toSum}',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
