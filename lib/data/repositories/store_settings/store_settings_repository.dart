import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/local/daos/store_settings/store_settings_dao.dart';

class StoreSettingsRepository {
  final StoreSettingsDao _dao;

  StoreSettingsRepository(this._dao);

  Future<StoreSetting?> getSettings() => _dao.getSettings();

  Future<void> saveSettings({
    required String storeName,
    required String phone,
    required String address,
    required String barcodePrinter,
    required String receiptPrinter,
    required bool autoPrint,
  }) async {
    final existing = await _dao.getSettings();

    if (existing != null) {
      await _dao.updateSettings(
        id: existing.id,
        storeName: storeName,
        phone: phone,
        address: address,
        barcodePrinter: barcodePrinter,
        receiptPrinter: receiptPrinter,
        autoPrint: autoPrint,
      );
    } else {
      await _dao.insertSettings(
        storeName: storeName,
        phone: phone,
        address: address,
        barcodePrinter: barcodePrinter,
        receiptPrinter: receiptPrinter,
        autoPrint: autoPrint,
      );
    }
  }
}
