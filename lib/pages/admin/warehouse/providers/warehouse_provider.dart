import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';
import 'package:universal_pos_system_v1/data/models/stock_full.dart';
import 'package:universal_pos_system_v1/data/repositories/items/items_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/stocks/stocks_repository.dart';
import 'package:universal_pos_system_v1/data/models/items_full.dart';
import 'package:universal_pos_system_v1/models/warehouse/warehouse_item.dart';

class WarehouseProvider extends ChangeNotifier {
  final ItemsRepository itemsRepository;
  final StocksRepository stocksRepository;

  WarehouseProvider(
    this.itemsRepository,
    this.stocksRepository,
  ) {
    _initialize();
  }

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<ItemFull> _allItems = [];
  List<StockFull> _stocks = [];

  List<WarehouseItem> _warehouseItems = [];
  List<WarehouseItem> get warehouseItems {
    if (_searchQuery.isEmpty) {
      return _warehouseItems;
    }

    // Search by item name or barcode
    return _warehouseItems.where((warehouseItem) {
      final query = _searchQuery.toLowerCase();
      return warehouseItem.item.name.toLowerCase().contains(query) || warehouseItem.item.barcode.toLowerCase().contains(query);
    }).toList();
  }

  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  final TextEditingController searchController = TextEditingController();

  Future<void> _initialize() async {
    try {
      _allItems = await itemsRepository.getAll();
      _stocks = await stocksRepository.getAll();

      _buildWarehouseItems();

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing warehouse: $e');
    }
  }

  void _buildWarehouseItems() {
    _warehouseItems = _allItems.map((item) {
      final itemStocks = _stocks.where((stock) => stock.item.id == item.id).toList();

      double warehouseQuantity = 0;
      double shopQuantity = 0;

      for (var stock in itemStocks) {
        if (stock.location == LocationsEnum.warehouse) {
          warehouseQuantity = stock.quantity;
        } else if (stock.location == LocationsEnum.shop) {
          shopQuantity = stock.quantity;
        }
      }

      return WarehouseItem(
        item: item,
        warehouseQuantity: warehouseQuantity,
        shopQuantity: shopQuantity,
        totalQuantity: warehouseQuantity + shopQuantity,
      );
    }).toList();
  }

  Future<void> refresh() async {
    try {
      _allItems = await itemsRepository.getAll();
      _stocks = await stocksRepository.getAll();
      _buildWarehouseItems();
      notifyListeners();
    } catch (e) {
      debugPrint('Error refreshing warehouse: $e');
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
