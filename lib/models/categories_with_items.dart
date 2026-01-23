import 'package:universal_pos_system_v1/data/models/item_category_full.dart';

class ItemCategoryWithColorAndItems {
  final ItemCategoryFull category;
  final List<dynamic> items;

  ItemCategoryWithColorAndItems({
    required this.category,
    required this.items,
  });
}
