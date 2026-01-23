import 'package:universal_pos_system_v1/data/local/app_database.dart';

class ItemCategoryFull {
  final int id;
  final DateTime createdAt;
  String name;
  CategoryColor? color;
  List<Item>? items;

  ItemCategoryFull({
    required this.id,
    required this.createdAt,
    required this.name,
    this.color,
    this.items,
  });

  factory ItemCategoryFull.from({
    required ItemCategory category,
    CategoryColor? color,
    List<Item>? items,
  }) {
    return ItemCategoryFull(
      id: category.id,
      createdAt: category.createdAt,
      name: category.name,
      color: color,
      items: items,
    );
  }
}
