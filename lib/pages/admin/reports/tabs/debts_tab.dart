import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/pages/admin/reports/provider/reports_provider.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';

class DebtsTab extends StatelessWidget {
  const DebtsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Consumer<ReportsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final debts = provider.debtsList;

        if (debts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.checkCircle,
                  size: 64,
                  color: Colors.green.withAlpha(150),
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  'Qarz yo\'q',
                  style: textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(150),
                  ),
                ),
              ],
            ),
          );
        }

        // Calculate total debt
        final totalDebt = debts.fold<double>(
          0.0,
          (sum, item) => sum + (item['amount'] as double),
        );

        // Calculate unpaid and paid debts separately
        final unPaidDebt = debts.fold<double>(
          0.0,
          (sum, item) {
            final debt = item['debt'] as Debt;
            final amount = item['amount'] as double;
            return debt.isPaid ? sum : sum + amount;
          },
        );

        final paidDebt = debts.fold<double>(
          0.0,
          (sum, item) {
            final debt = item['debt'] as Debt;
            final amount = item['amount'] as double;
            return debt.isPaid ? sum + amount : sum;
          },
        );

        return Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              // Table
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.dividerTheme.color ?? Colors.grey,
                      width: AppBorderWidth.thin,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Column(
                    children: [
                      // Table Header
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(AppRadius.md),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 40,
                              child: Text(
                                '#',
                                style: textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Ism',
                                style: textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Telefon',
                                style: textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Izoh',
                                style: textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Summa',
                                style: textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: Center(
                                child: Text(
                                  'Holat',
                                  style: textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: Text(
                                'Sana',
                                style: textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Center(
                                child: Text(
                                  'Amallar',
                                  style: textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1),
                      // Table Rows
                      Expanded(
                        child: ListView.separated(
                          itemCount: debts.length,
                          separatorBuilder: (context, index) => Divider(height: 1),
                          itemBuilder: (context, index) {
                            final debt = debts[index]['debt'] as Debt;
                            final amount = debts[index]['amount'] as double;

                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.md,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 40,
                                    child: Text(
                                      '${index + 1}',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurface.withAlpha(150),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      debt.title,
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      debt.phone,
                                      style: textTheme.bodyMedium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      debt.description,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurface.withAlpha(150),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text.rich(
                                      TextSpan(
                                        text: amount.toSum,
                                        children: [
                                          TextSpan(
                                            text: ' UZS',
                                            style: textTheme.bodySmall?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ],
                                      ),
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: Center(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: AppSpacing.sm,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: debt.isPaid ? Colors.green.withAlpha(30) : Colors.red.withAlpha(30),
                                          borderRadius: BorderRadius.circular(AppRadius.sm),
                                        ),
                                        child: Text(
                                          debt.isPaid ? 'To\'langan' : 'To\'lanmagan',
                                          style: textTheme.bodySmall?.copyWith(
                                            color: debt.isPaid ? Colors.green : Colors.red,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      DateFormat('dd.MM.yyyy').format(debt.createdAt),
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurface.withAlpha(150),
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Center(
                                      child: debt.isPaid
                                          ? Icon(
                                              LucideIcons.checkCircle,
                                              color: Colors.green,
                                              size: 20,
                                            )
                                          : IconButton(
                                              icon: Icon(
                                                LucideIcons.dollarSign,
                                                color: Colors.blue,
                                                size: 20,
                                              ),
                                              tooltip: 'Qarzni to\'lash',
                                              onPressed: () async {
                                                // Show confirmation dialog
                                                final confirm = await showDialog<bool>(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: Text('Qarzni to\'lash'),
                                                    content: Text('${debt.title} qarzini to\'langan deb belgilaysizmi?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(context, false),
                                                        child: Text('Bekor qilish'),
                                                      ),
                                                      FilledButton(
                                                        onPressed: () => Navigator.pop(context, true),
                                                        child: Text('To\'lash'),
                                                      ),
                                                    ],
                                                  ),
                                                );

                                                if (confirm == true) {
                                                  try {
                                                    await provider.markDebtAsPaid(debt.id);
                                                    if (context.mounted) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text('Qarz to\'langan deb belgilandi'),
                                                          backgroundColor: Colors.green,
                                                        ),
                                                      );
                                                    }
                                                  } catch (e) {
                                                    if (context.mounted) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text('Xatolik yuz berdi: $e'),
                                                          backgroundColor: Colors.red,
                                                        ),
                                                      );
                                                    }
                                                  }
                                                }
                                              },
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      // Total row
                      Divider(height: 1),
                      // Unpaid debts row
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.md,
                        ),
                        color: Colors.red.withAlpha(10),
                        child: Row(
                          children: [
                            SizedBox(width: 16),
                            Text(
                              'To\'lanmagan: ',
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text.rich(
                              TextSpan(
                                text: unPaidDebt.toSum,
                                children: [
                                  TextSpan(
                                    text: ' UZS',
                                    style: textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(width: 40),
                          ],
                        ),
                      ),
                      Divider(height: 1),
                      // Paid debts row
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.md,
                        ),
                        color: Colors.green.withAlpha(10),
                        child: Row(
                          children: [
                            SizedBox(width: 16),
                            Text(
                              'To\'langan: ',
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text.rich(
                              TextSpan(
                                text: paidDebt.toSum,
                                children: [
                                  TextSpan(
                                    text: ' UZS',
                                    style: textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(width: 40),
                          ],
                        ),
                      ),
                      Divider(height: 1),
                      // Total row
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.md,
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 16),
                            Text(
                              'Jami: ',
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text.rich(
                              TextSpan(
                                text: totalDebt.toSum,
                                children: [
                                  TextSpan(
                                    text: ' UZS',
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(width: 40),
                          ],
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
  }
}
