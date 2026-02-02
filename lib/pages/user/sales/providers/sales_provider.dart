import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/data/local/enums/sale_status_enum.dart';
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
  List<SaleFull> get complatedSales => _sales.where((s) => s.status == SaleStatusEnum.completed).toList();
  List<SaleFull> get savedSales => _sales.where((s) => s.status == SaleStatusEnum.saved).toList();

  final searchController = TextEditingController();
  String get searchText => searchController.text;

  // Categories & Selected Category
  List<ItemCategoryFull> _itemCategories = [];
  List<ItemCategoryFull> get itemCategories => _itemCategories;

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
    await loadSales();

    isInitialized = true;
  }

  Future<void> loadSales() async {
    try {
      _sales = await salesRepository.getAll();
      notifyListeners();
    } catch (e) {
      log('Error loading sales: $e');
    }
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
      log('Error creating/loading temp sale: $e');
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

  // Save Temp Sale to Sales History
  Future<void> saveTempSale(int userId) async {
    if (_tempSale == null || _tempSale!.items.isEmpty) {
      throw Exception('No items in sale to save');
    }

    try {
      // Change status from draft to saved
      await salesRepository.updateStatus(
        id: _tempSale!.id,
        status: SaleStatusEnum.saved,
      );

      // Reload saved sales
      await loadSales();

      // Clear current temp sale
      _tempSale = null;

      // Create new temp sale
      await createTempSale(userId);

      notifyListeners();
    } catch (e) {
      log('Error saving temp sale: $e');
      rethrow;
    }
  }

  // Delete Temp Sale
  Future<void> deleteTempSale() async {
    if (_tempSale == null) return;

    try {
      // Delete the temp sale
      await salesRepository.delete(_tempSale!.id);

      // Clear current temp sale
      _tempSale = null;

      notifyListeners();
    } catch (e) {
      log('Error deleting temp sale: $e');
    }
  }

  // Switch to a saved sale (make it the temp sale)
  Future<void> switchToSale(int saleId, int userId) async {
    try {
      // If there's a current tempSale, delete it if it has no items
      if (_tempSale != null) {
        if (_tempSale!.items.isEmpty) {
          await salesRepository.delete(_tempSale!.id);
        } else {
          // If it has items, keep it as saved
          await salesRepository.updateStatus(
            id: _tempSale!.id,
            status: SaleStatusEnum.saved,
          );
        }
      }

      // Load the selected sale
      final selectedSale = await salesRepository.getById(saleId);
      if (selectedSale == null) {
        throw Exception('Sale not found');
      }

      // Change its status to draft
      await salesRepository.updateStatus(
        id: saleId,
        status: SaleStatusEnum.draft,
      );

      // Set it as temp sale
      _tempSale = await salesRepository.getById(saleId);

      // Reload saved sales
      await loadSales();

      notifyListeners();
    } catch (e) {
      log('Error switching to sale: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
