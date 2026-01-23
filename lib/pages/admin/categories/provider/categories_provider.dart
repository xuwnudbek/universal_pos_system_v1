import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/models/item_category_full.dart';
import 'package:universal_pos_system_v1/data/repositories/category_colors_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/item_categories_repository.dart';

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
    await getAllCategoryColors();
    await getAllCategories();

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> getAllCategoryColors() async {
    var res = await _categoryColorsRepo.getAll();
    this._colors = res;

    notifyListeners();
  }

  Future<void> getAllCategories() async {
    this._categories = await _itemCategoriesRepo.getAll();

    notifyListeners();
  }

  Future<void> addCategory(String name, int? colorId) async {
    await _itemCategoriesRepo.create(name, colorId);
    await getAllCategories();
  }

  Future<void> updateCategory(
    int categoryId,
    String categoryName,
    int? colorId,
  ) async {
    await _itemCategoriesRepo.update(categoryId, categoryName, colorId);
    await getAllCategories();
  }

  Future<void> removeCategory(int categoryId) async {
    await _itemCategoriesRepo.delete(categoryId);

    await getAllCategories();
  }
}
