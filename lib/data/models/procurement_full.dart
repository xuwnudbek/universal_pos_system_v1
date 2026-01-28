import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';

class ProcurementFull {
  final int id;
  final String supplierName;
  final DateTime procurementDate;
  final LocationsEnum location;
  final String? note;
  final DateTime createdAt;
  final int itemsCount;
  final double totalCost;

  ProcurementFull({
    required this.id,
    required this.supplierName,
    required this.procurementDate,
    required this.location,
    required this.note,
    required this.createdAt,
    required this.itemsCount,
    required this.totalCost,
  });

  factory ProcurementFull.from({
    required Procurement procurement,
    required int itemsCount,
    required double totalCost,
  }) {
    return ProcurementFull(
      id: procurement.id,
      supplierName: procurement.supplierName,
      procurementDate: procurement.procurementDate,
      location: procurement.location,
      note: procurement.note,
      createdAt: procurement.createdAt,
      itemsCount: itemsCount,
      totalCost: totalCost,
    );
  }
}
