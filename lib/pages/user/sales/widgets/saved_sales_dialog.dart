import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/data/models/sale_full.dart';
import 'package:universal_pos_system_v1/pages/auth/provider/auth_provider.dart';
import 'package:universal_pos_system_v1/pages/user/sales/providers/sales_provider.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';
import 'package:universal_pos_system_v1/utils/extensions/sum_extension.dart';

void showSavedSalesDialog(BuildContext context, List<SaleFull> savedSales) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Saqlangan Sotuvlar'),
      content: SizedBox(
        width: 500,
        height: 400,
        child: savedSales.isEmpty
            ? const Center(
                child: Text('Saqlangan sotuvlar yo\'q'),
              )
            : ListView.separated(
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemCount: savedSales.length,
                itemBuilder: (_, index) {
                  final sale = savedSales[index];
                  final totalItems = sale.items.fold(0, (sum, item) => sum + item.quantity);

                  return ListTile(
                    tileColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: .05),
                    title: Text('Sotuv #${sale.id}'),
                    subtitle: Text('$totalItems ta mahsulot'),
                    trailing: Text(
                      sale.totalPrice.intOrDouble.str.toSumString("UZS"),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () async {
                      final userId = context.read<AuthProvider>().currentUser!.id;
                      await context.read<SalesProvider>().switchToSale(sale.id, userId);
                      if (dialogContext.mounted) {
                        Navigator.of(dialogContext).pop();
                      }
                    },
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
