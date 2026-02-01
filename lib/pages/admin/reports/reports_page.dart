import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:universal_pos_system_v1/pages/admin/reports/tabs/debts_tab.dart';
import 'package:universal_pos_system_v1/pages/admin/reports/tabs/payments_tab.dart';
import 'package:universal_pos_system_v1/pages/admin/reports/tabs/products_tab.dart';
import 'package:universal_pos_system_v1/pages/admin/reports/tabs/returns_tab.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';
import 'package:universal_pos_system_v1/utils/theme/app_colors.dart';

enum ReportFilter { yesterday, today, week, month, custom }

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  ReportFilter _selectedFilter = ReportFilter.today;
  DateTimeRange? _customDateRange;
  int _selectedTabIndex = 0;

  Future<void> _selectCustomDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _customDateRange,
    );

    if (picked != null && mounted) {
      setState(() {
        _customDateRange = picked;
        _selectedFilter = ReportFilter.custom;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

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
                    selected: _selectedFilter == ReportFilter.yesterday,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedFilter = ReportFilter.yesterday);
                      }
                    },
                  ),
                  ChoiceChip(
                    label: Text('Bugun'),
                    selected: _selectedFilter == ReportFilter.today,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedFilter = ReportFilter.today);
                      }
                    },
                  ),
                  ChoiceChip(
                    label: Text('Hafta'),
                    selected: _selectedFilter == ReportFilter.week,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedFilter = ReportFilter.week);
                      }
                    },
                  ),
                  ChoiceChip(
                    label: Text('Oylik'),
                    selected: _selectedFilter == ReportFilter.month,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedFilter = ReportFilter.month);
                      }
                    },
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: _selectedFilter == ReportFilter.custom ? theme.colorScheme.primary : AppColors.border,
                        width: _selectedFilter == ReportFilter.custom ? 2 : 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () => _selectCustomDateRange(context),
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
                              color: _selectedFilter == ReportFilter.custom ? theme.colorScheme.primary : theme.colorScheme.onSurface.withAlpha(180),
                            ),
                            SizedBox(width: AppSpacing.sm),
                            Text(
                              _customDateRange == null ? 'Sana tanlash' : '${_customDateRange!.start.day}.${_customDateRange!.start.month}.${_customDateRange!.start.year} - ${_customDateRange!.end.day}.${_customDateRange!.end.month}.${_customDateRange!.end.year}',
                              style: textTheme.bodySmall?.copyWith(
                                color: _selectedFilter == ReportFilter.custom ? theme.colorScheme.primary : null,
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
                child: _SummaryCard(
                  title: 'Savdo',
                  amount: 125500000,
                  icon: LucideIcons.shoppingCart,
                  color: Colors.green,
                ),
              ),
              // Qarz
              Expanded(
                child: _SummaryCard(
                  title: 'Qarz',
                  amount: 3500000,
                  icon: LucideIcons.coins,
                  color: Colors.orange,
                ),
              ),
              // Xarajatlar
              Expanded(
                child: _SummaryCard(
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
                ChoiceChip(
                  label: Text('Qaytarilganlar'),
                  selected: _selectedTabIndex == 3,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedTabIndex = 3);
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
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: color.withAlpha(50),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: color.withAlpha(50),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(180),
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  amount.toSum,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
