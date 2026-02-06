import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/models/item_category_full.dart';
import 'package:universal_pos_system_v1/data/models/items_full.dart';
import 'package:universal_pos_system_v1/data/repositories/items/item_categories_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/items/items_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/units/units_repository.dart';
import 'package:universal_pos_system_v1/models/item_form_result.dart';

class ItemsProvider extends ChangeNotifier {
  final ItemsRepository _itemsRepo;
  final ItemCategoriesRepository _categoriesRepository;
  final UnitsRepository _unitsRepository;

  final searchController = TextEditingController();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  set isInitialized(bool value) {
    _isInitialized = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  int? _sortColumnIndex;
  int? get sortColumnIndex => _sortColumnIndex;

  bool _sortAscending = true;
  bool get sortAscending => _sortAscending;

  List<ItemFull> _items = [];
  List<ItemFull> get items {
    var filteredItems = _items.where((item) {
      // Filter by category
      if (selectedCategory != null && item.category?.id != selectedCategory?.id) {
        return false;
      }

      // Filter by search query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return item.name.toLowerCase().contains(query) || item.barcode.toLowerCase().contains(query) || (item.category?.name.toLowerCase().contains(query) ?? false);
      }

      return true;
    }).toList();

    // Apply sorting
    if (_sortColumnIndex == 2) {
      // Category column
      filteredItems.sort((a, b) {
        final aCategory = a.category?.name ?? '';
        final bCategory = b.category?.name ?? '';
        return _sortAscending ? aCategory.compareTo(bCategory) : bCategory.compareTo(aCategory);
      });
    }

    return filteredItems;
  }

  List<ItemCategoryFull> _categories = [];
  List<ItemCategoryFull> get categories => _categories;

  List<Unit> _units = [];
  List<Unit> get units => _units;

  ItemCategoryFull? _selectedCategory;
  ItemCategoryFull? get selectedCategory => _selectedCategory;

  void onSelectCategory(ItemCategoryFull? value) {
    _selectedCategory = value;
    notifyListeners();
  }

  ItemsProvider(
    this._itemsRepo,
    this._categoriesRepository,
    this._unitsRepository,
  ) {
    _init();
  }

  Future<void> _init() async {
    try {
      await getAllItems();
      await getAllCategories();
      await getAllUnits();

      isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing items: $e');
    }
  }

  Future<void> getAllItems() async {
    try {
      _items = await _itemsRepo.getAll();
      notifyListeners();
    } catch (e) {
      debugPrint('Error getting items: $e');
      rethrow;
    }
  }

  Future<void> getAllUnits() async {
    try {
      _units = await _unitsRepository.getAll();
      notifyListeners();
    } catch (e) {
      debugPrint('Error getting units: $e');
      rethrow;
    }
  }

  Future<void> getAllCategories() async {
    try {
      _categories = await _categoriesRepository.getAll();
      notifyListeners();
    } catch (e) {
      debugPrint('Error getting categories: $e');
      rethrow;
    }
  }

  Future<void> addItem(ItemFormResult result) async {
    try {
      await _itemsRepo.create(
        name: result.name,
        barcode: result.barcode,
        categoryId: result.categoryId,
        unitId: result.unitId,
        salePrice: result.salePrice,
      );

      await getAllItems();
    } catch (e) {
      debugPrint('Error adding item: $e');
      rethrow;
    }
  }

  Future<void> updateItem(int id, ItemFormResult result) async {
    try {
      await _itemsRepo.update(
        id: id,
        name: result.name,
        barcode: result.barcode,
        categoryId: result.categoryId,
        unitId: result.unitId,
        salePrice: result.salePrice,
      );

      await getAllItems();
    } catch (e) {
      debugPrint('Error updating item: $e');
      rethrow;
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      await _itemsRepo.delete(id);
      await getAllItems();
    } catch (e) {
      debugPrint('Error deleting item: $e');
      rethrow;
    }
  }

  void sortByColumn(int columnIndex, bool ascending) {
    _sortColumnIndex = columnIndex;
    _sortAscending = ascending;
    notifyListeners();
  }
}
