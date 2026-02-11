import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/models/item_category_full.dart';
import 'package:universal_pos_system_v1/data/repositories/items/category_colors_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/items/item_categories_repository.dart';

class CategoriesProvider extends ChangeNotifier {
  final ItemCategoriesRepository _itemCategoriesRepo;
  final CategoryColorsRepository _categoryColorsRepo;

  List<ItemCategoryFull> _categories = [];
  List<ItemCategoryFull> get categories => _categories;

  List<CategoryColor> _colors = [];
  List<CategoryColor> get colors => _colors;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  set isInitialized(bool value) {
    _isInitialized = value;
    notifyListeners();
  }

  // Default Constructor
  CategoriesProvider(
    this._itemCategoriesRepo,
    this._categoryColorsRepo,
  ) {
    _init();
  }

  Future<void> _init() async {
    try {
      await getAllCategoryColors();
      await getAllCategories();

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing categories: $e');
    }
  }

  Future<void> getAllCategoryColors() async {
    try {
      var res = await _categoryColorsRepo.getAll();
      _colors = res;

      notifyListeners();
    } catch (e) {
      debugPrint('Error getting category colors: $e');
      rethrow;
    }
  }

  Future<void> getAllCategories() async {
    try {
      _categories = await _itemCategoriesRepo.getAll();

      notifyListeners();
    } catch (e) {
      debugPrint('Error getting categories: $e');
      rethrow;
    }
  }

  Future<void> addCategory(String name, int? colorId) async {
    try {
      await _itemCategoriesRepo.create(name, colorId);
      await getAllCategories();
    } catch (e) {
      debugPrint('Error adding category: $e');
      rethrow;
    }
  }

  Future<void> updateCategory(
    int categoryId,
    String categoryName,
    int? colorId,
  ) async {
    try {
      await _itemCategoriesRepo.update(categoryId, categoryName, colorId);
      await getAllCategories();
    } catch (e) {
      debugPrint('Error updating category: $e');
      rethrow;
    }
  }

  Future<void> removeCategory(int categoryId) async {
    try {
      await _itemCategoriesRepo.delete(categoryId);

      await getAllCategories();
    } catch (e) {
      debugPrint('Error removing category: $e');
      rethrow;
    }
  }
}
