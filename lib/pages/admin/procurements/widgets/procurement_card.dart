import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/data/models/procurement_full.dart';
import 'package:universal_pos_system_v1/data/repositories/procurements/procurement_items_repository.dart';
import 'package:universal_pos_system_v1/pages/admin/procurements/modals/delete_procurement_modal.dart';
import 'package:universal_pos_system_v1/pages/admin/procurements/modals/procurement_detail_dialog.dart';
import 'package:universal_pos_system_v1/pages/admin/procurements/providers/procurements_provider.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';
import 'package:universal_pos_system_v1/utils/theme/app_colors.dart';

class ProcurementCard extends StatefulWidget {
  const ProcurementCard({
    super.key,
    required this.procurement,
  });

  final ProcurementFull procurement;

  @override
  State<ProcurementCard> createState() => _ProcurementCardState();
}

class _ProcurementCardState extends State<ProcurementCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final procurement = widget.procurement;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(80),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(30),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            side: BorderSide(
              color: isHovered ? theme.colorScheme.primary.withAlpha(100) : AppColors.border,
              width: AppBorderWidth.thin,
            ),
          ),
          child: InkWell(
            onTap: () => showProcurementDetailDialog(
              context,
              procurement,
              context.read<ProcurementItemsRepository>(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with gradient
                Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary.withAlpha(200),
                        theme.colorScheme.primary.withAlpha(100),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(200),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Icon(
                          LucideIcons.packageOpen,
                          color: theme.colorScheme.primary,
                          size: 18,
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          procurement.supplierName,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: isHovered ? 1.0 : 0.6,
                        duration: Duration(milliseconds: 200),
                        child: IconButton(
                          icon: Icon(LucideIcons.trash2, size: 18),
                          color: Colors.white,
                          visualDensity: VisualDensity.compact,
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => DeleteProcurementModal(procurement: procurement),
                            );

                            if (confirm == true && context.mounted) {
                              await context.read<ProcurementsProvider>().deleteProcurement(procurement.id);
                            }
                          },
                        ),
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
                        // Date row
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blue.withAlpha(30),
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                              ),
                              child: Icon(LucideIcons.calendar, size: 14, color: Colors.blue),
                            ),
                            SizedBox(width: AppSpacing.sm),
                            Text(
                              '${procurement.procurementDate.day}/${procurement.procurementDate.month}/${procurement.procurementDate.year}',
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.md),

                        // Location badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm / 2,
                          ),
                          decoration: BoxDecoration(
                            color: procurement.location.name == 'warehouse' ? Colors.green.withAlpha(100) : Colors.orange.withAlpha(100),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            border: Border.all(
                              color: procurement.location.name == 'warehouse' ? Colors.green : Colors.orange,
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                procurement.location.name == 'warehouse' ? LucideIcons.warehouse : LucideIcons.store,
                                size: 14,
                                color: procurement.location.name == 'warehouse' ? Colors.green : Colors.orange,
                              ),
                              SizedBox(width: 6),
                              Text(
                                procurement.location.name == 'warehouse' ? 'Ombor' : 'Do\'kon',
                                style: textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: procurement.location.name == 'warehouse' ? Colors.green.shade700 : Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: AppSpacing.md),
                        Divider(height: 1),
                        SizedBox(height: AppSpacing.md),

                        // Items count
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Maxsulotlar',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface.withAlpha(150),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(LucideIcons.box, size: 16, color: theme.colorScheme.primary),
                                    SizedBox(width: 6),
                                    Text(
                                      '${procurement.itemsCount} ta',
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Jami summa',
                                  style: textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '${procurement.totalCost.toSum} UZS',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
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
