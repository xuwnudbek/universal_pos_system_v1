import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/local/daos/units/units_dao.dart';

class UnitsRepository {
  final UnitsDao unitsDao;

  UnitsRepository(this.unitsDao);

  Future<List<Unit>> getAll() => unitsDao.getAll();

  Future<Unit?> getById(int id) => unitsDao.getById(id);

  Future<int> insert(
    String name,
    String shortName,
    bool isActive,
  ) => unitsDao.insertUnit(name, shortName, isActive);

  Future<int> update(
    int id,
    String name,
    String shortName,
    bool isActive,
  ) => unitsDao.updateUnit(id, name, shortName, isActive);

  Future delete(int id) => unitsDao.deleteUnit(id);
}
