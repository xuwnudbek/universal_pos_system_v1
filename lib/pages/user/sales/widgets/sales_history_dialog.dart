import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/data/models/sale_full.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';
import 'package:universal_pos_system_v1/utils/extensions/sum_extension.dart';

void showSalesHistoryDialog(BuildContext context, List<SaleFull> allSales) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Sotuvlar Tarixi'),
      content: SizedBox(
        width: 600,
        height: 500,
        child: allSales.isEmpty
            ? const Center(
                child: Text('Sotuvlar tarixi bo\'sh'),
              )
            : ListView.separated(
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemCount: allSales.length,
                itemBuilder: (_, index) {
                  final sale = allSales[index];
                  final totalItems = sale.items.fold(0, (sum, item) => sum + item.quantity);

                  return ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    collapsedBackgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: .05),
                    backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: .08),
                    title: Text('Sotuv #${sale.id}'),
                    subtitle: Text(
                      '${sale.createdAt.day}/${sale.createdAt.month}/${sale.createdAt.year} - $totalItems ta mahsulot',
                    ),
                    trailing: Text(
                      sale.totalPrice.intOrDouble.str.toSumString("UZS"),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Mahsulotlar:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...sale.items.map(
                              (item) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text('${item.item.name} x${item.quantity}'),
                                    ),
                                    Text(
                                      (item.item.salePrice * item.quantity).intOrDouble.str.toSumString("UZS"),
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (sale.payments.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              const Divider(),
                              const SizedBox(height: 8),
                              const Text(
                                'To\'lovlar:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...sale.payments.map(
                                (payment) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('To\'lov #${payment.id}'),
                                      Text(
                                        payment.amount.intOrDouble.str.toSumString("UZS"),
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Yopish'),
        ),
      ],
    ),
  );
}
