import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/data/models/procurement_full.dart';
import 'package:universal_pos_system_v1/data/repositories/items/items_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/procurements/procurement_items_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/procurements/procurements_repository.dart';
import 'package:universal_pos_system_v1/models/procurements/procurement_form_result.dart';
import 'package:universal_pos_system_v1/pages/admin/procurements/modals/add_procurements_modal.dart';
import 'package:universal_pos_system_v1/pages/admin/procurements/providers/procurements_provider.dart';
import 'package:universal_pos_system_v1/pages/admin/procurements/widgets/procurement_card.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
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
                    "Olib kelish",
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
                          crossAxisCount: 2,
                          crossAxisSpacing: AppSpacing.lg,
                          mainAxisSpacing: AppSpacing.lg,
                          mainAxisExtent: 210,
                        ),
                        itemCount: procurements.length,
                        itemBuilder: (context, index) {
                          final procurement = procurements[index];

                          return ProcurementCard(procurement: procurement);
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
