import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/models/item_category_full.dart';

class ItemFull {
  final int id;
  final String name;
  final String barcode;
  final Unit unit;
  final double salePrice;
  final bool isActive;
  final String? imagePath;

  final ItemCategoryFull? category;

  final double shopQuantity;
  final double warehouseQuantity;

  ItemFull({
    required this.id,
    required this.name,
    required this.barcode,
    required this.unit,
    required this.salePrice,
    required this.isActive,
    this.imagePath,
    this.category,
    this.shopQuantity = 0,
    this.warehouseQuantity = 0,
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
      isActive: item.isActive,
      unit: unit,
      salePrice: item.salePrice,
      imagePath: item.imagePath,
      category: category,
    );
  }

  ItemFull copyWith({
    double? shopQuantity,
    double? warehouseQuantity,
  }) {
    return ItemFull(
      id: id,
      name: name,
      barcode: barcode,
      unit: unit,
      salePrice: salePrice,
      isActive: isActive,
      imagePath: imagePath,
      category: category,
      shopQuantity: shopQuantity ?? this.shopQuantity,
      warehouseQuantity: warehouseQuantity ?? this.warehouseQuantity,
    );
  }
}
