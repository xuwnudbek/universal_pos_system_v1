import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';
import 'package:universal_pos_system_v1/data/models/stock_full.dart';
import 'package:universal_pos_system_v1/data/models/transfer_full.dart';
import 'package:universal_pos_system_v1/data/repositories/items/items_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/stocks/stocks_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/transfers/transfers_repository.dart';
import 'package:universal_pos_system_v1/data/models/items_full.dart';
import 'package:universal_pos_system_v1/models/warehouse/warehouse_item.dart';

enum WarehouseTab { stock, history }

class WarehouseProvider extends ChangeNotifier {
  final ItemsRepository itemsRepository;
  final StocksRepository stocksRepository;
  final TransfersRepository transfersRepository;

  final TextEditingController searchController = TextEditingController();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  WarehouseTab _selectedTab = WarehouseTab.stock;
  WarehouseTab get selectedTab => _selectedTab;
  set selectedTab(WarehouseTab value) {
    _selectedTab = value;
    notifyListeners();
  }

  List<ItemFull> _allItems = [];
  List<StockFull> _stocks = [];
  List<TransferFull> _transfers = [];

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

  List<TransferFull> get transfers {
    if (_searchQuery.isEmpty) {
      return _transfers;
    }

    // Search by item name
    return _transfers.where((transferFull) {
      final query = _searchQuery.toLowerCase();
      return transferFull.item.name.toLowerCase().contains(query);
    }).toList();
  }

  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  WarehouseProvider(
    this.itemsRepository,
    this.stocksRepository,
    this.transfersRepository,
  ) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _allItems = await itemsRepository.getAll();
      _stocks = await stocksRepository.getAll();
      _transfers = await transfersRepository.getAllWithItems();

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
      _transfers = await transfersRepository.getAllWithItems();
      _buildWarehouseItems();
      notifyListeners();
    } catch (e) {
      debugPrint('Error refreshing warehouse: $e');
    }
  }

  Future<void> createTransfer({
    required int itemId,
    required LocationsEnum fromLocation,
    required LocationsEnum toLocation,
    required double quantity,
    String? note,
  }) async {
    // Create transfer record
    await transfersRepository.create(
      itemId: itemId,
      fromLocation: fromLocation,
      toLocation: toLocation,
      quantity: quantity,
      note: note,
    );

    // Update stock quantities after transfer
    await stocksRepository.updateQuantity(
      itemId,
      fromLocation,
      toLocation,
      quantity,
    );

    // Refresh only the affected item's stock
    _stocks = await stocksRepository.getAll();
    _transfers = await transfersRepository.getAllWithItems();
    _buildWarehouseItems();

    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
