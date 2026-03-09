import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/data/repositories/debts/debts_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/payment_types/payment_types_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/sale_payments/sale_payments_repository.dart';
import 'package:universal_pos_system_v1/pages/auth/provider/auth_provider.dart';
import 'package:universal_pos_system_v1/pages/user/sales/modals/debt_sales_dialog.dart';
import 'package:universal_pos_system_v1/utils/extensions/mq_extension.dart';
import 'package:universal_pos_system_v1/utils/extensions/sum_extension.dart';
import 'package:universal_pos_system_v1/utils/functions/show_snackbar.dart';

import '/data/models/item_category_full.dart';
import '/data/models/items_full.dart';
import '/data/models/sale_full.dart';
import '/data/repositories/items/item_categories_repository.dart';
import '/data/repositories/items/items_repository.dart';
import '/data/repositories/sales/sale_items_repository.dart';
import '/data/repositories/sales/sales_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/stocks/stocks_repository.dart';
import '/pages/user/sales/modals/saved_sales_dialog.dart';
import '/pages/user/sales/providers/sales_provider.dart';
import '/pages/user/sales/widgets/item_card.dart';
import '/utils/constants/app_constants.dart';
import '/utils/extensions/num_extension.dart';
import '/widgets/icon_button2.dart';
import 'modals/payment_dialog.dart';
import 'modals/sales_history_dialog.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  int _gridCrossAxisCount(WindowSize size) {
    switch (size) {
      case WindowSize.lg:
        return 7;
      case WindowSize.md:
        return 5;
      case WindowSize.sm:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final mq = MediaQuery.of(context);
    final windowSize = mq.windowSize;

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
            context.read<DebtsRepository>(),
            context.read<StocksRepository>(),
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
                      // Sidebar title
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
                            // saved sales
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
                                          showSavedSalesDialog(
                                            context,
                                            provider.savedSales,
                                          );
                                        },
                                        type: IconButton2Type.warning,
                                        icon: LucideIcons.save,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            // debt sales
                            Consumer<SalesProvider>(
                              builder: (context, provider, _) {
                                int count = provider.debtSales.length;

                                return Badge(
                                  label: count > 0 ? Text(count.toString()) : null,
                                  isLabelVisible: count > 0,
                                  child: Tooltip(
                                    message: "Qarzlar",
                                    child: IconButton2(
                                      onPressed: () async {
                                        if (context.mounted) {
                                          showDebtSalesDialog(
                                            context,
                                            provider.debtSales,
                                          );
                                        }
                                      },
                                      type: IconButton2Type.info,
                                      icon: LucideIcons.wallet,
                                    ),
                                  ),
                                );
                              },
                            ),
                            // sale histories
                            Consumer<SalesProvider>(
                              builder: (context, provider, _) {
                                int count = provider.complatedSales.length;

                                return Badge(
                                  label: count > 0 ? Text(count.toString()) : null,
                                  isLabelVisible: count > 0,
                                  child: Tooltip(
                                    message: "Sotuv tarixi",
                                    child: IconButton2(
                                      onPressed: () async {
                                        if (context.mounted) {
                                          showSalesHistoryDialog(
                                            context,
                                            provider.complatedSales,
                                          );
                                        }
                                      },
                                      type: IconButton2Type.info,
                                      icon: LucideIcons.history,
                                    ),
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
                      // Sidebar items here
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

                                return Consumer<SalesProvider>(
                                  builder: (context, provider, _) {
                                    final isSelected = provider.isKeyboardVisible && provider.selectedSaleItemId == saleItem.id;

                                    return ListTile(
                                      tileColor: isSelected ? theme.colorScheme.primary.withValues(alpha: .15) : theme.colorScheme.onSurface.withValues(alpha: .05),
                                      shape: isSelected
                                          ? RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              side: BorderSide(
                                                color: theme.colorScheme.primary,
                                                width: 1.5,
                                              ),
                                            )
                                          : null,
                                      dense: true,
                                      onTap: provider.isKeyboardVisible ? () => provider.selectSaleItem(saleItem.id) : null,
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: saleItem.item.imagePath != null && File(saleItem.item.imagePath!).existsSync()
                                            ? Image.file(
                                                File(saleItem.item.imagePath!),
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.cover,
                                              )
                                            : Container(
                                                width: 40,
                                                height: 40,
                                                color: theme.colorScheme.primary.withValues(alpha: .1),
                                                child: Icon(
                                                  LucideIcons.image,
                                                  size: 20,
                                                  color: theme.colorScheme.primary,
                                                ),
                                              ),
                                      ),
                                      title: Text(
                                        saleItem.item.name,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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
                                              context.read<SalesProvider>().removeItemFromTempSale(
                                                saleItem.item.id,
                                              );
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
                                              context.read<SalesProvider>().addItemToTempSale(
                                                saleItem.item.id,
                                              );
                                              // Auto-select after quantity change
                                              context.read<SalesProvider>().forceSelectSaleItem(saleItem.id);
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
                            );
                          },
                        ),
                      ),
                      // Total / Pay / Save
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

                            // Keyboard
                            Consumer<SalesProvider>(
                              builder: (context, provider, _) {
                                if (!provider.isKeyboardVisible) {
                                  return SizedBox.shrink();
                                }

                                return _PriceKeyboard(provider: provider);
                              },
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
                                                      Icon(
                                                        LucideIcons.creditCard,
                                                      ),
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
                      // Top Bar
                      Row(
                        children: [
                          IconButton2(
                            onPressed: () {
                              context.read<SalesProvider>().toggleKeyboard();
                            },
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
                                    hintText: 'Xaridlarni qidirish...',
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
                              context.read<SalesProvider>().loadInitialData();
                            },
                            icon: LucideIcons.refreshCcw,
                          ),
                          const Spacer(),

                          IconButton2(
                            onPressed: () async {
                              await context.read<AuthProvider>().logout();
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
                                // Item Categories
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
                      // Items Grid
                      Expanded(
                        child: Selector<SalesProvider, List<ItemFull>>(
                          selector: (context, provider) => provider.items,
                          builder: (context, items, _) {
                            if (items.isEmpty) {
                              return Center(
                                child: Text(
                                  'Maxsulot topilmadi',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: _gridCrossAxisCount(windowSize),
                                crossAxisSpacing: 12.0,
                                mainAxisSpacing: 12.0,
                                mainAxisExtent: _gridCrossAxisCount(windowSize) * 30 + 20,
                              ),
                              itemCount: items.length,
                              itemBuilder: (_, index) {
                                var item = items[index];

                                return ItemCard(
                                  item: item,
                                  onTap: () {
                                    try {
                                      context.read<SalesProvider>().addItemToTempSale(item.id);
                                      // Auto-select the item in sidebar after adding
                                      Future.delayed(Duration(milliseconds: 100), () {
                                        if (context.mounted) {
                                          final provider = context.read<SalesProvider>();
                                          final tempSale = provider.tempSale;
                                          if (tempSale != null) {
                                            for (var saleItem in tempSale.items) {
                                              if (saleItem.item.id == item.id) {
                                                // Enable keyboard if not already enabled
                                                if (!provider.isKeyboardVisible) {
                                                  provider.toggleKeyboard();
                                                }
                                                // Force select the item (don't toggle)
                                                provider.forceSelectSaleItem(saleItem.id);
                                                break;
                                              }
                                            }
                                          }
                                        }
                                      });
                                    } catch (e) {
                                      showAppSnackBar(context, e.toString());
                                    }
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

class _PriceKeyboard extends StatelessWidget {
  final SalesProvider provider;

  const _PriceKeyboard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final hasSelection = provider.selectedSaleItemId != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Display
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: hasSelection ? Colors.white : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasSelection ? theme.colorScheme.primary : Colors.grey[300]!,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!hasSelection)
                Text(
                  'Maxsulot tanlang',
                  style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              if (hasSelection) ...[
                Consumer<SalesProvider>(
                  builder: (context, provider, _) {
                    final selectedItem = provider.tempSale?.items.cast<dynamic>().firstWhere(
                      (item) => item.id == provider.selectedSaleItemId,
                      orElse: () => null,
                    );
                    final selectedItemName = (selectedItem as dynamic)?.item?.name as String?;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 4.0,
                      children: [
                        if (selectedItemName != null)
                          Text(
                            'Tanlangan: $selectedItemName',
                            style: textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        Text(
                          'Miqdor',
                          style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              provider.keyboardInput.toString(),
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (provider.maxQuantityForSelectedItem > 0)
                              Text(
                                'Maks: ${provider.maxQuantityForSelectedItem.toInt()}',
                                style: textTheme.bodySmall?.copyWith(
                                  color: provider.keyboardInput > provider.maxQuantityForSelectedItem ? Colors.red : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 8),
        // Buttons grid
        LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            final sideColWidth = 48.0;
            final gap = 4.0;
            final numAreaWidth = totalWidth - sideColWidth - gap;
            final keyWidth = (numAreaWidth - gap * 2) / 3;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: gap,
              children: [
                SizedBox(
                  width: numAreaWidth,
                  child: Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      ...List.generate(9, (i) {
                        final n = i + 1;
                        return _key(context, '$n', width: keyWidth, onTap: hasSelection ? () => provider.onKeyboardNumber(n) : null);
                      }),
                      _key(context, '0', width: keyWidth, onTap: hasSelection ? () => provider.onKeyboardNumber(0) : null),
                      _key(context, '00', width: keyWidth, onTap: hasSelection ? () => provider.onKeyboardDoubleZero() : null),
                      _key(
                        context,
                        '000',
                        width: keyWidth,
                        onTap: hasSelection
                            ? () {
                                provider.onKeyboardDoubleZero();
                                provider.onKeyboardNumber(0);
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: sideColWidth,
                  child: Column(
                    spacing: gap,
                    children: [
                      _key(context, 'C', width: sideColWidth, onTap: hasSelection ? () => provider.onKeyboardClear() : null, color: Colors.redAccent),
                      _key(
                        context,
                        '',
                        width: sideColWidth,
                        icon: LucideIcons.delete,
                        onTap: hasSelection ? () => provider.onKeyboardBackspace() : null,
                        color: Colors.orangeAccent,
                      ),
                      _key(
                        context,
                        '',
                        width: sideColWidth,
                        height: 48 * 2 + gap,
                        icon: LucideIcons.check,
                        onTap: hasSelection && provider.keyboardInput > 0 ? () => provider.confirmKeyboardQuantity() : null,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _key(
    BuildContext context,
    String label, {
    IconData? icon,
    VoidCallback? onTap,
    Color? color,
    double width = 48,
    double height = 48,
  }) {
    final enabled = onTap != null;

    return SizedBox(
      width: width,
      height: height,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: !enabled ? Colors.grey[300] : color ?? Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: icon != null
              ? Icon(icon, size: 20, color: enabled ? Colors.white : Colors.grey)
              : Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: enabled ? (color != null ? Colors.white : Colors.black) : Colors.grey,
                  ),
                ),
        ),
      ),
    );
  }
}
