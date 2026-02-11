import '../../local/app_database.dart';
import '../../local/daos/debts/debts_dao.dart';

class DebtsRepository {
  final DebtsDao _dao;

  DebtsRepository(this._dao);

  // 🔹 Get
  Future<List<Debt>> getAll() {
    return _dao.getAllDebts();
  }

  Future<Debt?> getById(int id) {
    return _dao.getDebtById(id);
  }

  // 🔹 Create
  Future<int> create({
    required String title,
    required String description,
    bool isPaid = false,
    required int salePaymentId,
  }) {
    return _dao.insertDebt(
      title: title,
      description: description,
      isPaid: isPaid,
      salePaymentId: salePaymentId,
    );
  }

  // 🔹 Update
  Future<int> update({
    required int id,
    required String title,
    required String description,
    required bool isPaid,
    required int salePaymentId,
  }) {
    return _dao.updateDebt(id, title, description, isPaid);
  }

  // 🔹 Delete
  Future<int> delete(int id) {
    return _dao.deleteDebt(id);
  }
}
