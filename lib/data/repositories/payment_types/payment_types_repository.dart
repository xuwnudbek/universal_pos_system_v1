import 'package:universal_pos_system_v1/data/local/app_database.dart';

import '../../local/daos/payment_types/payment_types_dao.dart';

class PaymentTypesRepository {
  final PaymentTypesDao paymentTypesDao;

  const PaymentTypesRepository(this.paymentTypesDao);

  Future<List<PaymentType>> getAll() async {
    return await paymentTypesDao.getAll();
  }

  Future<List<PaymentType>> getAllActive() async {
    return await paymentTypesDao.getAllActive();
  }

  Future<PaymentType?> getById(int id) async {
    return await paymentTypesDao.getById(id);
  }
}
