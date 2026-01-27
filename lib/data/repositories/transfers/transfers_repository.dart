import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/local/daos/transfers/transfers_dao.dart';
import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';

class TransfersRepository {
  final TransfersDao transfersDao;

  const TransfersRepository(this.transfersDao);

  Future<List<Transfer>> getAll() => transfersDao.getAll();

  Future<Transfer?> getById(int id) => transfersDao.getById(id);

  Future<List<Transfer>> getByItem(int itemId) => transfersDao.getByItem(itemId);

  Future<List<Transfer>> getByFromLocation(LocationsEnum location) => transfersDao.getByFromLocation(location);

  Future<List<Transfer>> getByToLocation(LocationsEnum location) => transfersDao.getByToLocation(location);

  Future<List<Transfer>> getByDateRange(DateTime start, DateTime end) => transfersDao.getByDateRange(start, end);

  Future<int> create({
    required int itemId,
    required LocationsEnum fromLocation,
    required LocationsEnum toLocation,
    required double quantity,
    String? note,
  }) => transfersDao.insertTransfer(itemId, fromLocation, toLocation, quantity, note);

  Future<void> update({
    required int id,
    required int itemId,
    required LocationsEnum fromLocation,
    required LocationsEnum toLocation,
    required double quantity,
    String? note,
  }) => transfersDao.updateTransfer(id, itemId, fromLocation, toLocation, quantity, note);

  Future delete(int id) => transfersDao.deleteTransfer(id);
}
