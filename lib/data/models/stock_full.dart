import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';

class StockFull {
  final int id;
  final Item item;
  final LocationsEnum location;
  final double quantity;

  StockFull({
    required this.id,
    required this.item,
    required this.location,
    required this.quantity,
  });

  factory StockFull.from({
    required Stock stock,
    required Item item,
  }) {
    return StockFull(
      id: stock.id,
      item: item,
      location: stock.location,
      quantity: stock.quantity,
    );
  }
}
