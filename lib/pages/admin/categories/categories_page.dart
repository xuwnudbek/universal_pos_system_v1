import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/data/models/item_category_full.dart';
import 'package:universal_pos_system_v1/data/repositories/items/category_colors_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/items/item_categories_repository.dart';
import 'package:universal_pos_system_v1/pages/admin/categories/modals/add_category_modal.dart';
import 'package:universal_pos_system_v1/pages/admin/categories/provider/categories_provider.dart';
import 'package:universal_pos_system_v1/pages/admin/categories/widgets/category_card.dart';
import 'package:universal_pos_system_v1/pages/admin/categories/modals/delete_category_modal.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/widgets/button.dart';
import 'package:universal_pos_system_v1/widgets/loaders/app_loader.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CategoriesProvider(
            context.read<ItemCategoriesRepository>(),
            context.read<CategoryColorsRepository>(),
          ),
        ),
      ],
      builder: (context, _) {
        return Column(
          children: [
            // Header
            Container(
              height: 60,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerTheme.color ?? Colors.grey,
                    width: theme.dividerTheme.thickness ?? 0.5,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Kategoriyalar", style: theme.textTheme.titleLarge),
                  Spacer(),
                  Button(
                    onPressed: () async {
                      final provider = context.read<CategoriesProvider>();

                      ItemCategoryNameAndColor? data = await showDialog<ItemCategoryNameAndColor>(
                        context: context,
                        builder: (context) => AddCategoryModal(
                          colors: provider.colors,
                        ),
                      );

                      if (!context.mounted) return;

                      if (data != null) {
                        await provider.addCategory(
                          data.categoryName,
                          data.colorId,
                        );
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8,
                      children: [
                        Icon(LucideIcons.plus),
                        Text("Kategoriya qo'shish"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Selector<CategoriesProvider, bool>(
                selector: (_, provider) => provider.isInitialized,
                builder: (context, isInitialized, child) {
                  if (!isInitialized) {
                    return AppLoader();
                  }

                  return Selector<CategoriesProvider, List<ItemCategoryFull>>(
                    selector: (_, provider) => provider.categories,
                    builder: (context, categories, _) {
                      if (categories.isEmpty) {
                        return Center(
                          child: Text(
                            "Kategoriyalar mavjud emas",
                            style: textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        );
                      }

                      final categoriesProvider = context.read<CategoriesProvider>();

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 130,
                        ),
                        padding: EdgeInsets.all(16),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];

                          return CategoryCard(
                            category: category,
                            itemCount: category.items?.length,
                            onDelete: () async {
                              bool? isDeleted = await showDialog<bool>(
                                context: context,
                                builder: (context) => DeleteCategoryModal(category: category),
                              );

                              if (isDeleted == true) {
                                await categoriesProvider.removeCategory(category.id);
                              }
                            },
                            onEdit: () async {
                              ItemCategoryNameAndColor? data = await showDialog<ItemCategoryNameAndColor>(
                                context: context,
                                builder: (context) => AddCategoryModal(
                                  category: category,
                                  colors: categoriesProvider.colors,
                                ),
                              );

                              if (!context.mounted) return;

                              if (data != null) {
                                await categoriesProvider.updateCategory(
                                  category.id,
                                  data.categoryName,
                                  data.colorId,
                                );
                              }
                            },
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

class ItemCategoryNameAndColor {
  final String categoryName;
  final int? colorId;

  ItemCategoryNameAndColor(this.categoryName, this.colorId);
}
