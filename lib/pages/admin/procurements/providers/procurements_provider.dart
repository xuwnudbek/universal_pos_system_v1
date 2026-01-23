import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/repositories/procurements_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/procurement_items_repository.dart';

class ProcurementWithItems {
  final Procurement procurement;
  final List<ProcurementItem> items;

  ProcurementWithItems({
    required this.procurement,
    required this.items,
  });
}

class ProcurementsProvider extends ChangeNotifier {
  final ProcurementsRepository procurementsRepository;
  final ProcurementItemsRepository procurementItemsRepository;

  ProcurementsProvider(
    this.procurementsRepository,
    this.procurementItemsRepository,
  ) {
    _initialize();
  }

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<ProcurementWithItems> _procurements = [];
  List<ProcurementWithItems> get procurements => _procurements;

  Future<void> _initialize() async {
    try {
      await loadProcurements();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing procurements: $e');
    }
  }

  Future<void> loadProcurements() async {
    final allProcurements = await procurementsRepository.getAll();
    _procurements = [];

    for (var procurement in allProcurements) {
      final items = await procurementItemsRepository.getByProcurementId(procurement.id);
      _procurements.add(
        ProcurementWithItems(
          procurement: procurement,
          items: items,
        ),
      );
    }

    notifyListeners();
  }

  Future<void> addProcurement({
    required String supplierName,
    required DateTime procurementDate,
    required LocationsEnum location,
    required List<ProcurementItemData> items,
    String? note,
  }) async {
    try {
      // Create procurement
      final procurementId = await procurementsRepository.create(
        supplierName: supplierName,
        procurementDate: procurementDate,
        location: location,
        note: note,
      );

      // Add items
      for (var item in items) {
        await procurementItemsRepository.create(
          procurementId: procurementId,
          itemId: item.itemId,
          quantity: item.quantity,
          purchasePrice: item.purchasePrice,
        );
      }

      await loadProcurements();
    } catch (e) {
      debugPrint('Error adding procurement: $e');
      rethrow;
    }
  }

  Future<void> deleteProcurement(int id) async {
    try {
      await procurementsRepository.delete(id);
      await loadProcurements();
    } catch (e) {
      debugPrint('Error deleting procurement: $e');
      rethrow;
    }
  }
}

class ProcurementItemData {
  final int itemId;
  final double quantity;
  final double purchasePrice;

  ProcurementItemData({
    required this.itemId,
    required this.quantity,
    required this.purchasePrice,
  });
}
