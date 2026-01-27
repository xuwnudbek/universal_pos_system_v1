import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/data/models/procurement_full.dart';
import 'package:universal_pos_system_v1/data/repositories/items/items_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/procurements/procurement_items_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/procurements/procurements_repository.dart';
import 'package:universal_pos_system_v1/models/procurements/procurement_form_result.dart';
import 'package:universal_pos_system_v1/pages/admin/procurements/modals/add_procurements_modal.dart';
import 'package:universal_pos_system_v1/pages/admin/procurements/modals/delete_procurement_modal.dart';
import 'package:universal_pos_system_v1/pages/admin/procurements/providers/procurements_provider.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';
import 'package:universal_pos_system_v1/widgets/button.dart';
import 'package:universal_pos_system_v1/widgets/loaders/app_loader.dart';

class ProcurementsPage extends StatefulWidget {
  const ProcurementsPage({super.key});

  @override
  State<ProcurementsPage> createState() => _ProcurementsPageState();
}

class _ProcurementsPageState extends State<ProcurementsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProcurementsProvider(
            context.read<ProcurementsRepository>(),
            context.read<ProcurementItemsRepository>(),
          ),
        ),
      ],
      builder: (context, _) {
        return Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerTheme.color ?? Colors.grey,
                    width: AppBorderWidth.thin,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Row(
                children: [
                  Text(
                    "Olib kelishlar",
                    style: theme.textTheme.titleLarge,
                  ),
                  Spacer(),
                  Button(
                    onPressed: () async {
                      final itemsRepository = context.read<ItemsRepository>();
                      final items = await itemsRepository.getAll();

                      if (!context.mounted) return;

                      final result = await showDialog<ProcurementFormResult>(
                        context: context,
                        builder: (context) => AddProcurementsModal(items: items),
                      );

                      if (result != null && context.mounted) {
                        final provider = context.read<ProcurementsProvider>();
                        await provider.addProcurement(
                          supplierName: result.supplierName,
                          procurementDate: result.procurementDate,
                          location: result.location,
                          items: result.items,
                        );
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8,
                      children: [
                        Icon(LucideIcons.plus),
                        Text("Yangi olib kelish"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Selector<ProcurementsProvider, bool>(
                selector: (_, provider) => provider.isInitialized,
                builder: (context, isInitialized, _) {
                  if (!isInitialized) {
                    return AppLoader();
                  }

                  return Selector<ProcurementsProvider, List<ProcurementFull>>(
                    selector: (_, provider) => provider.procurements,
                    builder: (context, procurements, _) {
                      if (procurements.isEmpty) {
                        return Center(
                          child: Text(
                            "Olib kelishlar mavjud emas",
                            style: textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: AppSpacing.lg,
                          mainAxisSpacing: AppSpacing.lg,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: procurements.length,
                        itemBuilder: (context, index) {
                          final procurement = procurements[index];
                          final items = procurement.items;

                          // Calculate total
                          double totalCost = 0;
                          for (var item in items) {
                            totalCost += item.quantity * item.purchasePrice;
                          }

                          return Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header
                                Container(
                                  padding: EdgeInsets.all(AppSpacing.md),
                                  color: theme.colorScheme.primary.withOpacity(0.1),
                                  child: Row(
                                    children: [
                                      Icon(
                                        LucideIcons.package,
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
                                            SizedBox(width: 4),
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
                                            Text(
                                              procurement.location.name == 'warehouse' ? 'Ombor' : 'Do\'kon',
                                              style: textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: AppSpacing.sm),
                                        Divider(),
                                        SizedBox(height: AppSpacing.sm),
                                        Text(
                                          'Maxsulotlar: ${items.length} ta',
                                          style: textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Jami: ${totalCost.toSum}',
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
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
