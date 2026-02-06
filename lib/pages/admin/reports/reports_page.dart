import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/data/repositories/sales/sale_items_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/sale_payments/sale_payments_repository.dart';
import 'package:universal_pos_system_v1/pages/admin/reports/provider/reports_provider.dart';
import 'package:universal_pos_system_v1/pages/admin/reports/tabs/debts_tab.dart';
import 'package:universal_pos_system_v1/pages/admin/reports/tabs/payments_tab.dart';
import 'package:universal_pos_system_v1/pages/admin/reports/tabs/products_tab.dart';
import 'package:universal_pos_system_v1/pages/admin/reports/tabs/returns_tab.dart';
import 'package:universal_pos_system_v1/pages/admin/sidebar/summary_card.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/theme/app_colors.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  int _selectedTabIndex = 0;

  Future<void> _selectCustomDateRange(BuildContext context) async {
    final provider = Provider.of<ReportsProvider>(context, listen: false);

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: provider.customDateRange,
    );

    if (picked != null && mounted) {
      provider.setCustomDateRange(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ReportsProvider(
            context.read<SaleItemsRepository>(),
            context.read<SalePaymentsRepository>(),
          ),
        ),
      ],
      builder: (context, _) {
        return Consumer<ReportsProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                // Header with filters
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: theme.dividerTheme.color ?? Colors.grey,
                        width: AppBorderWidth.thin,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hisobotlar',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      Row(
                        spacing: AppSpacing.sm,
                        children: [
                          ChoiceChip(
                            label: Text('Kecha'),
                            selected: provider.selectedFilter == ReportFilter.yesterday,
                            onSelected: (selected) {
                              if (selected) {
                                provider.setFilter(ReportFilter.yesterday);
                              }
                            },
                          ),
                          ChoiceChip(
                            label: Text('Bugun'),
                            selected: provider.selectedFilter == ReportFilter.today,
                            onSelected: (selected) {
                              if (selected) {
                                provider.setFilter(ReportFilter.today);
                              }
                            },
                          ),
                          ChoiceChip(
                            label: Text('Hafta'),
                            selected: provider.selectedFilter == ReportFilter.week,
                            onSelected: (selected) {
                              if (selected) {
                                provider.setFilter(ReportFilter.week);
                              }
                            },
                          ),
                          ChoiceChip(
                            label: Text('Oylik'),
                            selected: provider.selectedFilter == ReportFilter.month,
                            onSelected: (selected) {
                              if (selected) {
                                provider.setFilter(ReportFilter.month);
                              }
                            },
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                              border: Border.all(
                                color: provider.selectedFilter == ReportFilter.custom ? theme.colorScheme.primary : AppColors.border,
                                width: provider.selectedFilter == ReportFilter.custom ? 2 : 1,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                _selectCustomDateRange(context);
                              },
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      LucideIcons.calendar,
                                      size: 16,
                                      color: provider.selectedFilter == ReportFilter.custom ? theme.colorScheme.primary : theme.colorScheme.onSurface.withAlpha(180),
                                    ),
                                    SizedBox(width: AppSpacing.sm),
                                    Text(
                                      provider.customDateRange == null ? 'Sana tanlash' : '${provider.customDateRange!.start.day}.${provider.customDateRange!.start.month}.${provider.customDateRange!.start.year} - ${provider.customDateRange!.end.day}.${provider.customDateRange!.end.month}.${provider.customDateRange!.end.year}',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: provider.selectedFilter == ReportFilter.custom ? theme.colorScheme.primary : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Summary Cards
                Container(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    spacing: AppSpacing.md,
                    children: [
                      // Savdo
                      Expanded(
                        child: SummaryCard(
                          title: 'Savdo',
                          amount: 125500000,
                          icon: LucideIcons.shoppingCart,
                          color: Colors.green,
                        ),
                      ),
                      // Qarz
                      Expanded(
                        child: SummaryCard(
                          title: 'Qarz',
                          amount: 3500000,
                          icon: LucideIcons.coins,
                          color: Colors.orange,
                        ),
                      ),
                      // Xarajatlar
                      Expanded(
                        child: SummaryCard(
                          title: 'Xarajatlar',
                          amount: 15000000,
                          icon: LucideIcons.trendingDown,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),

                // Tabs
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: theme.dividerTheme.color ?? Colors.grey,
                        width: AppBorderWidth.thin,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    child: Row(
                      spacing: AppSpacing.sm,
                      children: [
                        ChoiceChip(
                          label: Text('Maxsulotlar'),
                          selected: _selectedTabIndex == 0,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedTabIndex = 0);
                            }
                          },
                        ),
                        ChoiceChip(
                          label: Text('To\'lovlar'),
                          selected: _selectedTabIndex == 1,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedTabIndex = 1);
                            }
                          },
                        ),
                        ChoiceChip(
                          label: Text('Qarzlar'),
                          selected: _selectedTabIndex == 2,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedTabIndex = 2);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Tab Content
                Expanded(
                  child: IndexedStack(
                    index: _selectedTabIndex,
                    children: [
                      ProductsTab(),
                      PaymentsTab(),
                      DebtsTab(),
                      ReturnsTab(),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
