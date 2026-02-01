import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/data/models/item_category_full.dart';
import 'package:universal_pos_system_v1/data/models/items_full.dart';
import 'package:universal_pos_system_v1/data/models/sale_full.dart';
import 'package:universal_pos_system_v1/data/repositories/items/item_categories_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/items/items_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/sales/sale_items_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/sales/sales_repository.dart';

class SalesProvider extends ChangeNotifier {
  final SalesRepository salesRepository;
  final SaleItemsRepository saleItemsRepository;
  final ItemsRepository itemsRepository;
  final ItemCategoriesRepository itemCategoriesRepository;

  SaleFull? _tempSale;
  SaleFull? get tempSale => _tempSale;

  // Sales History
  List<SaleFull> _sales = [];
  List<SaleFull> get sales => _sales;

  final searchController = TextEditingController();
  String get searchText => searchController.text;

  // Selected Category
  ItemCategoryFull? _selectedCategory;
  ItemCategoryFull? get selectedCategory => _selectedCategory;
  set selectedCategory(ItemCategoryFull? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Items
  List<ItemFull> _items = [];
  List<ItemFull> get items {
    if (selectedCategory == null) {
      return _items;
    }

    return _items.where((i) => i.category?.id == selectedCategory?.id).toList();
  }

  // Categories & Selected Category
  List<ItemCategoryFull> _itemCategories = [];
  List<ItemCategoryFull> get itemCategories => _itemCategories;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  set isInitialized(bool value) {
    _isInitialized = value;
    notifyListeners();
  }

  SalesProvider(
    this.salesRepository,
    this.saleItemsRepository,
    this.itemsRepository,
    this.itemCategoriesRepository,
  ) {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await loadItems();
    await loadItemCategories();

    isInitialized = true;
  }

  Future<void> loadItems() async {
    _items = await itemsRepository.getAll();
    notifyListeners();
  }

  Future<void> loadItemCategories() async {
    _itemCategories = await itemCategoriesRepository.getAll();
    notifyListeners();
  }

  // Temporary Sale Management
  Future<void> createTempSale(int userId) async {
    try {
      var maybeDraftSale = await salesRepository.getDraftByUserId(userId);

      if (maybeDraftSale != null) {
        _tempSale = maybeDraftSale;
      } else {
        _tempSale ??= await salesRepository.create(userId: userId);
      }

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addItemToTempSale(int itemId) async {
    if (_tempSale == null) {
      throw Exception('No temporary sale found. Please create a temp sale first.');
    }

    // Check if item already exists in the sale
    final existingItemIndex = _tempSale!.items.indexWhere(
      (saleItem) => saleItem.item.id == itemId,
    );

    if (existingItemIndex != -1) {
      // Item exists - increase quantity by 1
      final existingSaleItem = _tempSale!.items[existingItemIndex];
      await saleItemsRepository.updateQuantity(
        id: existingSaleItem.id,
        quantity: existingSaleItem.quantity + 1,
      );
    } else {
      // Item doesn't exist - create new sale item with quantity 1
      await saleItemsRepository.create(
        saleId: _tempSale!.id,
        itemId: itemId,
        quantity: 1,
      );
    }

    // Reload the temp sale to reflect changes
    _tempSale = await salesRepository.getBySaleId(_tempSale!.id);
    notifyListeners();
  }

  Future<void> removeItemFromTempSale(int itemId) async {
    if (_tempSale == null) {
      throw Exception('No temporary sale found. Please create a temp sale first.');
    }

    // Find the item in the sale
    final existingItemIndex = _tempSale!.items.indexWhere(
      (saleItem) => saleItem.item.id == itemId,
    );

    if (existingItemIndex == -1) {
      // Item not found in sale
      return;
    }

    final existingSaleItem = _tempSale!.items[existingItemIndex];

    if (existingSaleItem.quantity > 1) {
      // Decrease quantity by 1
      await saleItemsRepository.updateQuantity(
        id: existingSaleItem.id,
        quantity: existingSaleItem.quantity - 1,
      );
    } else {
      // Quantity is 1, delete the sale item
      await saleItemsRepository.delete(existingSaleItem.id);
    }

    // Reload the temp sale to reflect changes
    _tempSale = await salesRepository.getBySaleId(_tempSale!.id);
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
