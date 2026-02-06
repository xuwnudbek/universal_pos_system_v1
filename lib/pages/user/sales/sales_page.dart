import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/data/repositories/payment_types/payment_types_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/sale_payments/sale_payments_repository.dart';
import 'package:universal_pos_system_v1/utils/extensions/sum_extension.dart';
import 'package:universal_pos_system_v1/utils/functions/show_snackbar.dart';

import '/data/models/item_category_full.dart';
import '/data/models/items_full.dart';
import '/data/models/sale_full.dart';
import '/data/repositories/items/item_categories_repository.dart';
import '/data/repositories/items/items_repository.dart';

import '/data/repositories/sales/sale_items_repository.dart';
import '/data/repositories/sales/sales_repository.dart';
import '/pages/user/sales/providers/sales_provider.dart';
import '/pages/user/sales/widgets/item_card.dart';
import '/pages/user/sales/widgets/payment_dialog.dart';
import '/pages/user/sales/widgets/saved_sales_dialog.dart';
import '/pages/user/sales/widgets/sales_history_dialog.dart';
import '/utils/constants/app_constants.dart';
import '/utils/extensions/num_extension.dart';
import '/utils/router/app_router.dart';
import '/widgets/icon_button2.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final mq = MediaQuery.of(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SalesProvider(
            context.read<SalesRepository>(),
            context.read<SaleItemsRepository>(),
            context.read<ItemsRepository>(),
            context.read<ItemCategoriesRepository>(),
            context.read<SalePaymentsRepository>(),
            context.read<PaymentTypesRepository>(),
          )..createTempSale(),
        ),
      ],
      builder: (context, asyncSnapshot) {
        return Material(
          child: Row(
            children: [
              // Inner Sidebar
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: theme.dividerTheme.color ?? Colors.grey,
                      width: theme.dividerTheme.thickness ?? 1,
                    ),
                  ),
                ),
                child: SizedBox(
                  width: mq.size.width * 0.2,
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          border: Border(
                            bottom: BorderSide(
                              color: theme.dividerTheme.color ?? Colors.grey,
                              width: theme.dividerTheme.thickness ?? 0.5,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Chek", style: theme.textTheme.titleMedium),
                            Spacer(),
                            Consumer<SalesProvider>(
                              builder: (context, provider, _) {
                                int count = provider.savedSales.length;

                                return Builder(
                                  builder: (context) {
                                    return Badge(
                                      label: count > 0 ? Text(count.toString()) : null,
                                      isLabelVisible: count > 0,
                                      child: IconButton2(
                                        onPressed: () {
                                          showSavedSalesDialog(context, provider.savedSales);
                                        },
                                        type: IconButton2Type.warning,
                                        icon: LucideIcons.save,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            Consumer<SalesProvider>(
                              builder: (context, provider, _) {
                                int count = provider.complatedSales.length;

                                return Badge(
                                  label: count > 0 ? Text(count.toString()) : null,
                                  isLabelVisible: count > 0,
                                  child: IconButton2(
                                    onPressed: () async {
                                      if (context.mounted) {
                                        showSalesHistoryDialog(context, provider.complatedSales);
                                      }
                                    },
                                    type: IconButton2Type.info,
                                    icon: LucideIcons.history,
                                  ),
                                );
                              },
                            ),

                            Selector<SalesProvider, SaleFull?>(
                              selector: (context, provider) => provider.tempSale,
                              builder: (context, tempSale, child) {
                                if (tempSale == null || tempSale.items.isEmpty) {
                                  return SizedBox.shrink();
                                }

                                return child!;
                              },
                              child: IconButton2(
                                onPressed: () {
                                  context.read<SalesProvider>().deleteTempSale();
                                },
                                type: IconButton2Type.danger,
                                icon: LucideIcons.trash2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Add sidebar items here
                      Expanded(
                        child: Selector<SalesProvider, SaleFull?>(
                          selector: (context, provider) => provider.tempSale,
                          builder: (context, tempSale, _) {
                            if (tempSale == null || tempSale.items.isEmpty) {
                              return Center(
                                child: Text(
                                  'Savatcha bo\'sh',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface.withAlpha(100),
                                  ),
                                ),
                              );
                            }

                            return ListView.separated(
                              padding: EdgeInsets.all(AppSpacing.sm),
                              separatorBuilder: (_, _) => SizedBox(height: AppSpacing.xs),
                              itemCount: tempSale.items.length,
                              itemBuilder: (_, index) {
                                var saleItem = tempSale.items[index];

                                return ListTile(
                                  tileColor: theme.colorScheme.onSurface.withValues(alpha: .05),
                                  dense: true,
                                  title: Text(
                                    saleItem.item.name,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    saleItem.item.salePrice.toSum,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 8.0,
                                    children: [
                                      IconButton2(
                                        onPressed: () {
                                          context.read<SalesProvider>().removeItemFromTempSale(saleItem.item.id);
                                        },
                                        type: IconButton2Type.warning,
                                        icon: LucideIcons.minus,
                                      ),
                                      SizedBox(
                                        width: 24,
                                        child: Center(
                                          child: Text(
                                            saleItem.quantity.toString(),
                                            style: theme.textTheme.titleSmall,
                                          ),
                                        ),
                                      ),
                                      IconButton2(
                                        onPressed: () {
                                          context.read<SalesProvider>().addItemToTempSale(saleItem.item.id);
                                        },
                                        type: IconButton2Type.success,
                                        icon: LucideIcons.plus,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      // Total
                      Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          border: Border(
                            top: BorderSide(
                              color: theme.dividerTheme.color ?? Colors.grey,
                              width: theme.dividerTheme.thickness ?? 1,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: AppSpacing.lg,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Jami:",
                                  style: textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.onSurface,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Consumer<SalesProvider>(
                                  builder: (context, salesProvider, _) {
                                    return Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: (salesProvider.tempSale?.totalPrice ?? 0).intOrDouble.str.toSumString(),
                                            style: textTheme.titleLarge?.copyWith(
                                              color: theme.colorScheme.onSurface,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " UZS",
                                            style: textTheme.titleMedium?.copyWith(
                                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),

                            Selector<SalesProvider, SaleFull?>(
                              selector: (context, provider) => provider.tempSale,
                              builder: (context, tempSale, child) {
                                bool enabled = tempSale != null && tempSale.items.isNotEmpty;

                                return AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  height: enabled ? 36 : 0,
                                  child: enabled
                                      ? Row(
                                          children: [
                                            IconButton2(
                                              type: IconButton2Type.primary,
                                              icon: LucideIcons.save,
                                              onPressed: () {
                                                context.read<SalesProvider>().saveTempSale();
                                              },
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: SizedBox(
                                                height: 36,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    if (enabled) {
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible: false,
                                                        builder: (dialogContext) => ChangeNotifierProvider.value(
                                                          value: context.read<SalesProvider>(),
                                                          child: PaymentDialog(),
                                                        ),
                                                      ).then((success) {
                                                        if (success == 101 && context.mounted) {
                                                          context.read<SalesProvider>().createTempSale();

                                                          showAppSnackBar(
                                                            context,
                                                            "To'lov muvaffaqiyatli amalga oshirildi",
                                                            type: SnackBarType.success,
                                                          );
                                                        }
                                                      });
                                                    }
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(LucideIcons.creditCard),
                                                      SizedBox(width: 8),
                                                      Text("To'lov"),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Main Content Area
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton2(
                            onPressed: () {},
                            type: IconButton2Type.primary,
                            icon: LucideIcons.keyboard,
                          ),
                          SizedBox(width: 16),
                          // Searchbar
                          SizedBox(
                            width: 300,
                            child: Selector<SalesProvider, TextEditingController>(
                              selector: (context, provider) => provider.searchController,
                              builder: (context, controller, _) {
                                return TextFormField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    hintText: 'Search sales...',
                                    prefixIcon: Icon(LucideIcons.search),
                                    isDense: true,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          IconButton2(
                            onPressed: () {
                              appRouter.pushNamed(AppRoute.settings.name);
                            },
                            icon: LucideIcons.settings,
                          ),
                          SizedBox(width: 16),
                          IconButton2(
                            onPressed: () {
                              appRouter.pushNamed(AppRoute.logout.name);
                            },
                            type: IconButton2Type.danger,
                            icon: LucideIcons.logOut,
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      // Item Categories
                      SizedBox(
                        height: 40,
                        child: Selector<SalesProvider, List<ItemCategoryFull>>(
                          selector: (context, provider) => provider.itemCategories,
                          builder: (context, categories, _) {
                            return Row(
                              children: [
                                // "All" category
                                ChoiceChip(
                                  showCheckmark: false,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 8.0,
                                  ),
                                  label: Text("Barchasi"),
                                  selected: context.watch<SalesProvider>().selectedCategory == null,
                                  onSelected: (bool selected) {
                                    context.read<SalesProvider>().selectedCategory = null;
                                  },
                                ),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    separatorBuilder: (_, _) => SizedBox(width: 8.0),
                                    itemCount: categories.length,
                                    itemBuilder: (_, index) {
                                      var category = categories[index];

                                      return ChoiceChip(
                                        showCheckmark: false,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                          vertical: 8.0,
                                        ),
                                        label: Text(category.name),
                                        selected: context.watch<SalesProvider>().selectedCategory?.id == category.id,
                                        onSelected: (bool selected) {
                                          context.read<SalesProvider>().selectedCategory = category;
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Expanded(
                        child: Selector<SalesProvider, List<ItemFull>>(
                          selector: (context, provider) => provider.items,
                          builder: (context, items, _) {
                            if (items.isEmpty) {
                              return Center(
                                child: Text(
                                  'Maxsulot topilmadi',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                  ),
                                ),
                              );
                            }

                            return GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 6,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                                mainAxisExtent: 170,
                              ),
                              itemCount: items.length,
                              itemBuilder: (_, index) {
                                var item = items[index];

                                return ItemCard(
                                  item: item,
                                  onTap: () {
                                    context.read<SalesProvider>().addItemToTempSale(item.id);
                                  },
                                  onSecondaryTap: () {
                                    context.read<SalesProvider>().removeItemFromTempSale(item.id);
                                  },
                                );
                              },
                            );
                          },
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
