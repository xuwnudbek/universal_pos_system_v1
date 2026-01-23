import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';

class SaleProvider extends ChangeNotifier {
  final searchController = TextEditingController();
  String get searchText => searchController.text;

  // Items
  final _items = <Item>[];

  // Categories & Selected Category
  final List<ItemCategory> _itemCategories = [];
  List<ItemCategory> get itemCategories => _itemCategories;

  ItemCategory? _selectedCategory;
  ItemCategory? get selectedCategory => _selectedCategory;
  set selectedCategory(ItemCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Items Getter
  List<Item> get items {
    if (selectedCategory == null) return _items;

    return _items.where((item) => item.categoryId == selectedCategory?.id).toList();
  }

  // Increase Cart Item Quantity
  void increaseCartItem(Item item) {}

  // Decrease Cart Item Quantity
  void decreaseCartItem(Item item) {}

  // Remove CartItem from Cart
  void removeFromCart(CartItem cartItem) {
    notifyListeners();
  }

  // Clear Cart
  void clearCart() {}
}
