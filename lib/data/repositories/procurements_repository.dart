import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/local/dao/procurements/procurements_dao.dart';
import 'package:universal_pos_system_v1/data/local/enums/locations_enum.dart';

class ProcurementsRepository {
  final ProcurementsDao procurementsDao;

  const ProcurementsRepository(this.procurementsDao);

  Future<List<Procurement>> getAll() => procurementsDao.getAll();

  Future<Procurement?> getById(int id) => procurementsDao.getById(id);

  Future<List<Procurement>> getByLocation(LocationsEnum location) => procurementsDao.getByLocation(location);

  Future<List<Procurement>> getByDateRange(DateTime start, DateTime end) => procurementsDao.getByDateRange(start, end);

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
