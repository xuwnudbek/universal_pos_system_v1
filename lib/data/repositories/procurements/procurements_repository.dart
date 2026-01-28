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
    final allProcurements = await procurementsDao.getAll();
    return allProcurements;
  }

  Future<ProcurementFull?> getById(int id) async {
    return procurementsDao.getById(id);
  }

  Future<List<ProcurementFull>> getByLocation(LocationsEnum location) async {
    return procurementsDao.getByLocation(location);
  }

  Future<List<ProcurementFull>> getByDateRange(DateTime start, DateTime end) async {
    return procurementsDao.getByDateRange(start, end);
  }

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
