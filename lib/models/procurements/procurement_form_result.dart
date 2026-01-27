import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';
import 'procurement_item_data.dart';

class ProcurementFormResult {
  final String supplierName;
  final DateTime procurementDate;
  final LocationsEnum location;
  final List<ProcurementItemData> items;

  ProcurementFormResult({
    required this.supplierName,
    required this.procurementDate,
    required this.location,
    required this.items,
  });
}
