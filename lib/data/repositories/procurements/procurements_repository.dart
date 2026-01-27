import 'package:universal_pos_system_v1/data/local/daos/procurements/procurement_items_dao.dart';
import 'package:universal_pos_system_v1/data/local/daos/procurements/procurements_dao.dart';
import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';
import 'package:universal_pos_system_v1/data/models/procurement_full.dart';

class ProcurementsRepository {
  final ProcurementsDao procurementsDao;
  final ProcurementItemsDao procurementItemsDao;

  const ProcurementsRepository(
    this.procurementsDao,
    this.procurementItemsDao,
  );

  Future<List<ProcurementFull>> getAll() async {
    final procurements = await procurementsDao.getAll();
    final procurmentsItems = await procurementItemsDao.getAllWithItems();

    return procurements.map((procurement) {
      final items = procurmentsItems
          .where(
            (item) => item.procurementId == procurement.id,
          )
          .toList();

      return ProcurementFull.from(
        procurement: procurement,
        items: items,
      );
    }).toList();
  }

  Future<ProcurementFull?> getById(int id) async {
    final procurement = await procurementsDao.getById(id);
    if (procurement == null) {
      return null;
    }
    final items = await procurementItemsDao.getByProcurementId(id);
  }

  Future<List<ProcurementFull>> getByLocation(LocationsEnum location) async {
    final procurements = await procurementsDao.getByLocation(location);
  }

  Future<List<ProcurementFull>> getByDateRange(DateTime start, DateTime end) => procurementsDao.getByDateRange(start, end);

  Future<int> create({
    required String supplierName,
    required DateTime procurementDate,
    required LocationsEnum location,
    String? note,
  }) => procurementsDao.insertProcurement(supplierName, procurementDate, location, note);

  Future<void> update({
    required int id,
    required String supplierName,
    required DateTime procurementDate,
    required LocationsEnum location,
    String? note,
  }) => procurementsDao.updateProcurement(id, supplierName, procurementDate, location, note);

  Future delete(int id) => procurementsDao.deleteProcurement(id);
}
