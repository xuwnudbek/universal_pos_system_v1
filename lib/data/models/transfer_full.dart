import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/models/items_full.dart';

class TransferFull {
  final Transfer transfer;
  final ItemFull item;

  TransferFull({
    required this.transfer,
    required this.item,
  });
}
