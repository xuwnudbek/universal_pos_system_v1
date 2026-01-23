import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/models/item_category_full.dart';
import 'package:universal_pos_system_v1/data/models/items_full.dart';
import 'package:universal_pos_system_v1/data/repositories/item_categories_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/items_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/units_repository.dart';
import 'package:universal_pos_system_v1/models/item_form_result.dart';

class ItemsProvider extends ChangeNotifier {
  final ItemsRepository _itemsRepository;
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
    this._itemsRepository,
    this._categoriesRepository,
    this._unitsRepository,
  ) {
    _init();
  }

  Future<void> _init() async {
    await getAllItems();
    await getAllCategories();
    await getAllUnits();

    isInitialized = true;
  }

  Future<void> getAllItems() async {
    _items = await _itemsRepository.getAll();
    notifyListeners();
  }

  Future<void> getAllUnits() async {
    _units = await _unitsRepository.getAll();
    notifyListeners();
  }

  Future<void> getAllCategories() async {
    _categories = await _categoriesRepository.getAll();
    notifyListeners();
  }

  Future<void> addItem(ItemFormResult result) async {
    await _itemsRepository.create(
      name: result.name,
      barcode: result.barcode,
      price: result.price,
      stock: result.stock,
      categoryId: result.categoryId,
      unitId: result.unitId,
    );

    await getAllItems();
  }

  Future<void> updateItem(int id, ItemFormResult result) async {
    await _itemsRepository.update(
      id: id,
      name: result.name,
      barcode: result.barcode,
      price: result.price,
      stock: result.stock,
      categoryId: result.categoryId,
      unitId: result.unitId,
    );

    await getAllItems();
  }

  Future<void> deleteItem(int id) async {
    await _itemsRepository.delete(id);
    await getAllItems();
  }

  void sortByColumn(int columnIndex, bool ascending) {
    _sortColumnIndex = columnIndex;
    _sortAscending = ascending;
    notifyListeners();
  }
}
