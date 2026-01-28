import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';
import 'package:universal_pos_system_v1/data/models/procurement_full.dart';
import 'package:universal_pos_system_v1/data/repositories/procurements/procurement_items_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/procurements/procurements_repository.dart';
import 'package:universal_pos_system_v1/models/procurements/procurement_item_data.dart';

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

  List<ProcurementFull> _procurements = [];
  List<ProcurementFull> get procurements => _procurements;

  Future<void> _initialize() async {
    try {
      await loadAllProcurements();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing procurements: $e');
    }
  }

  Future<void> loadAllProcurements() async {
    try {
      final allProcurements = await procurementsRepository.getAll();

      _procurements = allProcurements;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading procurements: $e');
      rethrow;
    }
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

      await loadAllProcurements();
    } catch (e) {
      debugPrint('Error adding procurement: $e');
      rethrow;
    }
  }

  Future<void> deleteProcurement(int id) async {
    try {
      await procurementsRepository.delete(id);
      await loadAllProcurements();
    } catch (e) {
      debugPrint('Error deleting procurement: $e');
      rethrow;
    }
  }
}
