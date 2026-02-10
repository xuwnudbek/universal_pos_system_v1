import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/data/local/daos/expenses/expenses_dao.dart';
import 'package:universal_pos_system_v1/data/repositories/expenses/expense_categories_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/expenses/expenses_repository.dart';
import 'package:universal_pos_system_v1/pages/admin/expenses/modals/add_expense_modal.dart';
import 'package:universal_pos_system_v1/pages/admin/expenses/providers/expenses_provider.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';
import 'package:universal_pos_system_v1/utils/functions/show_snackbar.dart';
import 'package:universal_pos_system_v1/utils/theme/app_colors.dart';
import 'package:universal_pos_system_v1/widgets/button.dart';
import 'package:universal_pos_system_v1/widgets/loaders/app_loader.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final PaginatorController _paginatorController = PaginatorController();

  @override
  void dispose() {
    _paginatorController.dispose();
    super.dispose();
  }

  Future<void> _selectCustomDateRange(BuildContext context) async {
    final provider = context.read<ExpensesProvider>();

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: provider.customDateRange,
    );

    if (picked != null && context.mounted) {
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
          create: (_) => ExpensesProvider(
            context.read<ExpensesRepository>(),
            context.read<ExpenseCategoriesRepository>(),
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
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title and Add Button
                  Row(
                    children: [
                      Text(
                        'Xarajatlar',
                        style: textTheme.titleLarge,
                      ),
                      Spacer(),
                      Button(
                        onPressed: () async {
                          final provider = context.read<ExpensesProvider>();
                          if (!provider.isInitialized) return;

                          final result = await showDialog<ExpenseFormResult>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AddExpenseModal(
                              categories: provider.categories,
                            ),
                          );

                          if (result != null && context.mounted) {
                            try {
                              await provider.addExpense(
                                categoryId: result.categoryId,
                                amount: result.amount,
                                expenseDate: result.expenseDate,
                                note: result.note,
                              );

                              if (context.mounted) {
                                showAppSnackBar(
                                  context,
                                  'Xarajat muvaffaqiyatli qo\'shildi',
                                  type: SnackBarType.success,
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                showAppSnackBar(
                                  context,
                                  'Xatolik yuz berdi: $e',
                                  type: SnackBarType.error,
                                );
                              }
                            }
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                            Icon(LucideIcons.plus),
                            Text('Xarajat qo\'shish'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md),

                  // Filters
                  Selector<ExpensesProvider, ExpenseFilter>(
                    selector: (_, provider) => provider.selectedFilter,
                    builder: (context, selectedFilter, _) {
                      return Row(
                        spacing: AppSpacing.sm,
                        children: [
                          ChoiceChip(
                            label: Text('Kecha'),
                            selected: selectedFilter == ExpenseFilter.yesterday,
                            onSelected: (selected) {
                              if (selected) {
                                context.read<ExpensesProvider>().setFilter(ExpenseFilter.yesterday);
                              }
                            },
                          ),
                          ChoiceChip(
                            label: Text('Bugun'),
                            selected: selectedFilter == ExpenseFilter.today,
                            onSelected: (selected) {
                              if (selected) {
                                context.read<ExpensesProvider>().setFilter(ExpenseFilter.today);
                              }
                            },
                          ),
                          ChoiceChip(
                            label: Text('Hafta'),
                            selected: selectedFilter == ExpenseFilter.week,
                            onSelected: (selected) {
                              if (selected) {
                                context.read<ExpensesProvider>().setFilter(ExpenseFilter.week);
                              }
                            },
                          ),
                          ChoiceChip(
                            label: Text('Oylik'),
                            selected: selectedFilter == ExpenseFilter.month,
                            onSelected: (selected) {
                              if (selected) {
                                context.read<ExpensesProvider>().setFilter(ExpenseFilter.month);
                              }
                            },
                          ),
                          Selector<ExpensesProvider, DateTimeRange?>(
                            selector: (_, provider) => provider.customDateRange,
                            builder: (context, dateRange, _) {
                              return DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppRadius.lg),
                                  border: Border.all(
                                    color: selectedFilter == ExpenseFilter.custom ? theme.colorScheme.primary : AppColors.border,
                                    width: selectedFilter == ExpenseFilter.custom ? 2 : 1,
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
                                          color: selectedFilter == ExpenseFilter.custom ? theme.colorScheme.primary : theme.colorScheme.onSurface.withAlpha(180),
                                        ),
                                        SizedBox(width: AppSpacing.sm),
                                        Text(
                                          dateRange == null ? 'Sana tanlash' : '${dateRange.start.day}.${dateRange.start.month}.${dateRange.start.year} - ${dateRange.end.day}.${dateRange.end.month}.${dateRange.end.year}',
                                          style: textTheme.bodySmall?.copyWith(
                                            color: selectedFilter == ExpenseFilter.custom ? theme.colorScheme.primary : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // Total Amount
            Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withAlpha(75),
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerTheme.color ?? Colors.grey,
                    width: AppBorderWidth.thin,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.trendingDown,
                    color: theme.colorScheme.error,
                    size: 24,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    'Jami xarajat: ',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Selector<ExpensesProvider, double>(
                    selector: (_, provider) => provider.totalAmount,
                    builder: (context, total, _) {
                      return Text(
                        total.toSum,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.error,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Expenses Table
            Expanded(
              child: Selector<ExpensesProvider, bool>(
                selector: (_, provider) => provider.isInitialized,
                builder: (context, isInitialized, _) {
                  if (!isInitialized) {
                    return AppLoader();
                  }

                  return Selector<ExpensesProvider, List<ExpenseWithCategory>>(
                    selector: (_, provider) => provider.expenses,
                    builder: (context, expenses, _) {
                      if (expenses.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.receipt,
                                size: 64,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                              ),
                              SizedBox(height: AppSpacing.md),
                              Text(
                                'Xarajatlar topilmadi',
                                style: textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.dividerTheme.color ?? Colors.grey,
                              width: AppBorderWidth.thin,
                            ),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          padding: EdgeInsets.all(1),
                          child: PaginatedDataTable2(
                            controller: _paginatorController,
                            columnSpacing: AppSpacing.md,
                            horizontalMargin: AppSpacing.lg,
                            minWidth: 800,
                            headingRowHeight: 56,
                            dataRowHeight: 60,
                            rowsPerPage: 10,
                            availableRowsPerPage: const [10, 20, 50, 100],
                            border: TableBorder.all(
                              color: AppColors.surface,
                            ),
                            headingRowDecoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(AppRadius.md),
                              ),
                            ),
                            columns: [
                              DataColumn2(
                                label: Text(
                                  'Kategoriya',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                size: ColumnSize.L,
                              ),
                              DataColumn2(
                                label: Text(
                                  'Summa',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                size: ColumnSize.M,
                              ),
                              DataColumn2(
                                label: Text(
                                  'Sana',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                size: ColumnSize.M,
                              ),
                              DataColumn2(
                                label: Text(
                                  'Izoh',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                size: ColumnSize.L,
                              ),
                              DataColumn2(
                                label: Text(
                                  'Amallar',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                size: ColumnSize.S,
                                fixedWidth: 100,
                              ),
                            ],
                            source: ExpensesDataSource(
                              expenses: expenses,
                              context: context,
                              textTheme: textTheme,
                              theme: theme,
                            ),
                          ),
                        ),
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

class ExpensesDataSource extends DataTableSource {
  final List<ExpenseWithCategory> expenses;
  final BuildContext context;
  final TextTheme textTheme;
  final ThemeData theme;

  ExpensesDataSource({
    required this.expenses,
    required this.context,
    required this.textTheme,
    required this.theme,
  });

  @override
  DataRow2? getRow(int index) {
    if (index >= expenses.length) return null;

    final expenseWithCategory = expenses[index];
    final expense = expenseWithCategory.expense;
    final category = expenseWithCategory.category;

    return DataRow2(
      cells: [
        DataCell(
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  LucideIcons.tag,
                  color: theme.colorScheme.error,
                  size: 16,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  category.name,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            expense.amount.toSum,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.error,
            ),
          ),
        ),
        DataCell(
          Text(
            '${expense.expenseDate.day.toString().padLeft(2, '0')}.${expense.expenseDate.month.toString().padLeft(2, '0')}.${expense.expenseDate.year} ${expense.expenseDate.hour.toString().padLeft(2, '0')}:${expense.expenseDate.minute.toString().padLeft(2, '0')}',
            style: textTheme.bodySmall,
          ),
        ),
        DataCell(
          Tooltip(
            constraints: BoxConstraints(maxWidth: 300),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            richMessage: TextSpan(
              children: [
                TextSpan(
                  text: 'IZOH: ',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.surface,
                  ),
                ),
                TextSpan(
                  text: expense.note ?? '-',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.surface,
                  ),
                ),
              ],
            ),
            preferBelow: false,
            waitDuration: Duration(milliseconds: 300),
            mouseCursor: SystemMouseCursors.click,
            child: Text(
              expense.note ?? '-',
              style: textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  LucideIcons.edit,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                onPressed: () async {
                  final provider = context.read<ExpensesProvider>();
                  final result = await showDialog<ExpenseFormResult>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AddExpenseModal(
                      categories: provider.categories,
                      expense: expense,
                    ),
                  );

                  if (result != null && context.mounted) {
                    try {
                      await provider.updateExpense(
                        id: expense.id,
                        categoryId: result.categoryId,
                        amount: result.amount,
                        expenseDate: result.expenseDate,
                        note: result.note,
                      );

                      if (context.mounted) {
                        showAppSnackBar(
                          context,
                          'Xarajat tahrirlandi',
                          type: SnackBarType.success,
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        showAppSnackBar(
                          context,
                          'Xatolik: $e',
                          type: SnackBarType.error,
                        );
                      }
                    }
                  }
                },
              ),
              IconButton(
                icon: Icon(
                  LucideIcons.trash2,
                  size: 18,
                  color: theme.colorScheme.error,
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: Text('O\'chirish'),
                      content: Text('Ushbu xarajatni o\'chirishni xohlaysizmi?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Bekor qilish'),
                        ),
                        Button(
                          primaryColor: theme.colorScheme.error,
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('O\'chirish'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    try {
                      await context.read<ExpensesProvider>().deleteExpense(expense.id);
                      if (context.mounted) {
                        showAppSnackBar(
                          context,
                          'Xarajat o\'chirildi',
                          type: SnackBarType.success,
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        showAppSnackBar(
                          context,
                          'Xatolik: $e',
                          type: SnackBarType.error,
                        );
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => expenses.length;

  @override
  int get selectedRowCount => 0;
}
