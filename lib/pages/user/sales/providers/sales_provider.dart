import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/local/enums/sale_status_enum.dart';
import 'package:universal_pos_system_v1/data/models/item_category_full.dart';
import 'package:universal_pos_system_v1/data/models/items_full.dart';
import 'package:universal_pos_system_v1/data/models/sale_full.dart';
import 'package:universal_pos_system_v1/data/repositories/debts/debts_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/items/item_categories_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/items/items_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/payment_types/payment_types_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/sale_payments/sale_payments_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/sales/sale_items_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/sales/sales_repository.dart';
import 'package:universal_pos_system_v1/pages/user/sales/modals/add_debt_addition.dart';
import 'package:universal_pos_system_v1/utils/functions/local_storage.dart';

class SalesProvider extends ChangeNotifier {
  final SalesRepository salesRepo;
  final SaleItemsRepository saleItemsRepo;
  final ItemsRepository itemsRepo;
  final ItemCategoriesRepository itemCategoriesRepo;
  final SalePaymentsRepository salePaymentsRepo;
  final PaymentTypesRepository paymentTypesRepo;
  final DebtsRepository debtsRepo;

  SaleFull? _tempSale;

  SaleFull? get tempSale => _tempSale;

  set tempSale(SaleFull? sale) {
    _tempSale = sale;
    notifyListeners();
  }

  // Sales History
  List<SaleFull> _sales = [];

  List<SaleFull> get complatedSales => _sales.where((s) => s.status == SaleStatusEnum.completed).toList();

  List<SaleFull> get savedSales => _sales.where((s) => s.status == SaleStatusEnum.saved).toList();

  List<PaymentType> _paymentTypes = [];

  List<PaymentType> get paymentTypes => _paymentTypes;

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
    this.salesRepo,
    this.saleItemsRepo,
    this.itemsRepo,
    this.itemCategoriesRepo,
    this.salePaymentsRepo,
    this.paymentTypesRepo,
    this.debtsRepo,
  ) {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await loadItems();
    await loadItemCategories();
    await loadSales();
    await loadPaymentTypes();

    isInitialized = true;
  }

  Future<void> loadPaymentTypes() async {
    try {
      _paymentTypes = await paymentTypesRepo.getAll();
      notifyListeners();
    } catch (e) {
      log('Error loading payment types: $e');
    }
  }

  Future<void> loadSales() async {
    try {
      _sales = await salesRepo.getAll();
      notifyListeners();
    } catch (e) {
      log('Error loading sales: $e');
    }
  }

  Future<void> loadItems() async {
    _items = await itemsRepo.getAll();
    notifyListeners();
  }

  Future<void> loadItemCategories() async {
    _itemCategories = await itemCategoriesRepo.getAll();
    notifyListeners();
  }

  // Temporary Sale Management
  Future<void> createTempSale() async {
    final userId = LocalStorage.getUserId();

    if (userId == null) {
      log('No user ID found in local storage');
      return;
    }

    try {
      var maybeDraftSale = await salesRepo.getDraftByUserId(userId);

      if (maybeDraftSale != null) {
        tempSale = maybeDraftSale;
      } else {
        tempSale ??= await salesRepo.create(userId: userId);
      }

      notifyListeners();
    } catch (e) {
      log('Error creating/loading temp sale: $e');
    }
  }

  Future<void> addItemToTempSale(int itemId) async {
    if (tempSale == null) {
      throw Exception('No temporary sale found. Please create a temp sale first.');
    }

    // Check if item already exists in the sale
    final existingItemIndex = tempSale!.items.indexWhere(
      (saleItem) => saleItem.item.id == itemId,
    );

    if (existingItemIndex != -1) {
      // Item exists - increase quantity by 1
      final existingSaleItem = tempSale!.items[existingItemIndex];
      await saleItemsRepo.updateQuantity(
        id: existingSaleItem.id,
        quantity: existingSaleItem.quantity + 1,
      );
    } else {
      // Item doesn't exist - create new sale item with quantity 1
      await saleItemsRepo.create(
        saleId: tempSale!.id,
        itemId: itemId,
        quantity: 1,
      );
    }

    // Reload the temp sale to reflect changes
    tempSale = await salesRepo.getBySaleId(tempSale!.id);
    notifyListeners();
  }

  Future<void> removeItemFromTempSale(int itemId) async {
    if (tempSale == null) {
      throw Exception('No temporary sale found. Please create a temp sale first.');
    }

    // Find the item in the sale
    final existingItemIndex = tempSale!.items.indexWhere(
      (saleItem) => saleItem.item.id == itemId,
    );

    if (existingItemIndex == -1) {
      // Item not found in sale
      return;
    }

    final existingSaleItem = tempSale!.items[existingItemIndex];

    if (existingSaleItem.quantity > 1) {
      // Decrease quantity by 1
      await saleItemsRepo.updateQuantity(
        id: existingSaleItem.id,
        quantity: existingSaleItem.quantity - 1,
      );
    } else {
      // Quantity is 1, delete the sale item
      await saleItemsRepo.delete(existingSaleItem.id);
    }

    // Reload the temp sale to reflect changes
    tempSale = await salesRepo.getBySaleId(tempSale!.id);
    notifyListeners();
  }

  // Save Temp Sale to Sales History
  Future<void> saveTempSale() async {
    if (tempSale == null || tempSale!.items.isEmpty) {
      throw Exception('No items in sale to save');
    }

    try {
      // Change status from draft to saved
      await salesRepo.updateStatus(
        id: tempSale!.id,
        status: SaleStatusEnum.saved,
      );

      // Reload saved sales
      await loadSales();

      // Clear current temp sale
      tempSale = null;

      // Create new temp sale
      await createTempSale();

      notifyListeners();
    } catch (e) {
      log('Error saving temp sale: $e');
      rethrow;
    }
  }

  // Complete Temp Sale (mark as completed)
  Future<void> completeTempSale() async {
    if (tempSale == null || tempSale!.items.isEmpty) {
      throw Exception('No items in sale to complete');
    }

    try {
      // Change status from draft to completed
      await salesRepo.updateStatus(
        id: tempSale!.id,
        status: SaleStatusEnum.completed,
      );

      // Reload saved sales
      await loadSales();

      // Clear current temp sale
      tempSale = null;

      // Create new temp sale
      await createTempSale();

      notifyListeners();
    } catch (e) {
      log('Error completing temp sale: $e');
      rethrow;
    }
  }

  // Delete Temp Sale
  Future<void> deleteTempSale() async {
    if (tempSale == null) return;

    try {
      // Delete the temp sale
      await salesRepo.delete(tempSale!.id);

      // Clear current temp sale
      tempSale = null;

      notifyListeners();
    } catch (e) {
      log('Error deleting temp sale: $e');
    }
  }

  // Switch to a saved sale (make it the temp sale)
  Future<void> switchToSale(int saleId) async {
    try {
      // If there's a current tempSale, delete it if it has no items
      if (tempSale != null) {
        if (tempSale!.items.isEmpty) {
          await salesRepo.delete(tempSale!.id);
        } else {
          // If it has items, keep it as saved
          await salesRepo.updateStatus(
            id: tempSale!.id,
            status: SaleStatusEnum.saved,
          );
        }
      }

      // Load the selected sale
      final selectedSale = await salesRepo.getById(saleId);
      if (selectedSale == null) {
        throw Exception('Sale not found');
      }

      // Change its status to draft
      await salesRepo.updateStatus(
        id: saleId,
        status: SaleStatusEnum.draft,
      );

      // Set it as temp sale
      tempSale = await salesRepo.getById(saleId);

      // Reload saved sales
      await loadSales();

      notifyListeners();
    } catch (e) {
      log('Error switching to sale: $e');
      rethrow;
    }
  }

  // Pay for Sale
  Future<int?> payForSale({
    required int saleId,
    required int paymentTypeId,
    required double amount,
    DebtAdditions? debtAddition,
  }) async {
    final double totalAmount = tempSale?.totalPrice ?? 0;
    final double totalPaymentsAmount = tempSale?.payments.fold(0, (sum, p) => (sum ?? 0) + p.amount) ?? 0;

    if (amount > totalAmount - totalPaymentsAmount) {
      return 100;
    }

    int paymentId = await salePaymentsRepo.create(
      saleId: saleId,
      paymentTypeId: paymentTypeId,
      amount: amount,
    );

    if (debtAddition != null) {
      try {
        await debtsRepo.create(
          title: debtAddition.title,
          description: debtAddition.description,
          salePaymentId: paymentId,
        );
      } catch (e) {
        log("Nma bolutti: ${e.toString()}");
      }
    }

    final newSalePayment = await salePaymentsRepo.getById(paymentId);

    // Add payment to tempSale
    if (newSalePayment != null && tempSale != null) {
      tempSale = tempSale!.copyWith(
        payments: [...tempSale!.payments, newSalePayment],
      );

      if (totalPaymentsAmount + amount >= totalAmount) {
        await completeTempSale();
        return 101;
      }

      notifyListeners();
    }

    return null;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
