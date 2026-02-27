import '../../local/app_database.dart';
import '../../local/daos/debts/debts_dao.dart';

class DebtsRepository {
  final DebtsDao _dao;

  DebtsRepository(this._dao);

  // 🔹 Get
  Future<List<Debt>> getAll() {
    return _dao.getAllDebts();
  }

  Future<List<Debt>> getByDateRange(DateTime start, DateTime end) {
    start = DateTime(start.year, start.month, start.day, 0, 0, 0);
    end = DateTime(end.year, end.month, end.day, 23, 59, 59);

    return _dao.getDebtsByDateRange(start, end);
  }

  Future<Debt?> getById(int id) {
    return _dao.getDebtById(id);
  }

  // 🔹 Create
  Future<int> create({
    required String title,
    required String description,
    required String phone,
    required int salePaymentId,
  }) {
    return _dao.insertDebt(
      title: title,
      description: description,
      phone: phone,
      salePaymentId: salePaymentId,
    );
  }

  // 🔹 Update
  Future<int> update({
    required int id,
    required String title,
    required String description,
    required String phone,
    required int salePaymentId,
  }) {
    return _dao.updateDebt(id, title, description, phone);
  }

  // 🔹 Delete
  Future<int> delete(int id) {
    return _dao.deleteDebt(id);
  }

  // 🔹 Mark as Paid
  Future<int> markAsPaid(int id) {
    return _dao.markAsPaid(id);
  }
}
