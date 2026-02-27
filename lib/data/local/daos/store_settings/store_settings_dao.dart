import 'package:drift/drift.dart';

import '../../app_database.dart';
import '../../tables/store_settings_table.dart';

part 'store_settings_dao.g.dart';

@DriftAccessor(tables: [StoreSettings])
class StoreSettingsDao extends DatabaseAccessor<AppDatabase> with _$StoreSettingsDaoMixin {
  StoreSettingsDao(super.db);

  Future<StoreSetting?> getSettings() => (select(storeSettings)..limit(1)).getSingleOrNull();

  Future<int> insertSettings({
    required String storeName,
    required String phone,
    required String address,
    required String barcodePrinter,
    required String receiptPrinter,
    required bool autoPrint,
  }) {
    return into(storeSettings).insert(
      StoreSettingsCompanion.insert(
        storeName: Value(storeName),
        phone: Value(phone),
        address: Value(address),
        barcodePrinter: Value(barcodePrinter),
        receiptPrinter: Value(receiptPrinter),
        autoPrint: Value(autoPrint),
      ),
    );
  }

  Future<int> updateSettings({
    required int id,
    required String storeName,
    required String phone,
    required String address,
    required String barcodePrinter,
    required String receiptPrinter,
    required bool autoPrint,
  }) {
    final query = update(storeSettings)..where((tbl) => tbl.id.equals(id));
    return query.write(
      StoreSettingsCompanion(
        storeName: Value(storeName),
        phone: Value(phone),
        address: Value(address),
        barcodePrinter: Value(barcodePrinter),
        receiptPrinter: Value(receiptPrinter),
        autoPrint: Value(autoPrint),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
