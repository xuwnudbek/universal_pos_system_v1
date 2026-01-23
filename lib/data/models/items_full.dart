import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/models/item_category_full.dart';

class ItemFull {
  final int id;
  final String name;
  final String barcode;
  final double price;
  final Unit unit;
  final double stock;
  final bool isActive;

  final ItemCategoryFull? category;

  ItemFull({
    required this.id,
    required this.name,
    required this.barcode,
    required this.price,
    required this.unit,
    required this.stock,
    required this.isActive,
    this.category,
  });

  factory ItemFull.from({
    required Item item,
    required Unit unit,
    ItemCategoryFull? category,
  }) {
    return ItemFull(
      id: item.id,
      name: item.name,
      barcode: item.barcode,
      price: item.price,
      stock: item.stock,
      isActive: item.isActive,
      unit: unit,
      category: category,
    );
  }
}
