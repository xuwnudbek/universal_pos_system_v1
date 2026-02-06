import 'package:drift/drift.dart';
import 'package:universal_pos_system_v1/data/local/enums/user_roles_enum.dart';
import 'package:universal_pos_system_v1/utils/functions/bcrypt.dart';
import 'package:universal_pos_system_v1/utils/functions/local_storage.dart';

import '../app_database.dart';
import '../enums/payment_types_enum.dart';

class BaseSeeder {
  final AppDatabase db;

  BaseSeeder(this.db);

  Future<void> seedBaseData() {
    bool baseSeeded = false;

    baseSeeded = LocalStorage.getBool('base_seeded') ?? false;

    if (baseSeeded) {
      return Future.value();
    }

    return this.db.transaction(() async {
      await _seedUsers();
      await _seedUnits();
      await _seedPaymentTypes();
      await _seedCategoryColors();
      await _seedItemCategories();
      await _seedExpenseCategories();

      await LocalStorage.setBool('base_seeded', true);
    });
  }

  Future<void> _seedUsers() async {
    if ((await db.users.count().getSingle()) > 0) {
      return Future.value();
    }

    await LocalStorage.logout();

    return db.batch((b) {
      b.insertAll(db.users, [
        UsersCompanion.insert(
          fullName: 'Admin User',
          username: 'admin',
          passwordHash: hashPassword('admin'),
          role: UserRolesEnum.admin,
        ),
        UsersCompanion.insert(
          fullName: 'Regular User',
          username: 'user',
          passwordHash: hashPassword('user'),
          role: UserRolesEnum.cashier,
        ),
      ]);
    });
  }

  Future<void> _seedUnits() async {
    if ((await db.units.count().getSingle()) > 0) {
      return Future.value();
    }

    return db.batch((b) {
      b.insertAll(db.units, [
        UnitsCompanion.insert(name: 'Dona', shortName: 'dona'),
        UnitsCompanion.insert(name: 'Kilogramm', shortName: 'kg'),
        UnitsCompanion.insert(name: 'Gramm', shortName: 'g'),
        UnitsCompanion.insert(name: 'Litr', shortName: 'l'),
        UnitsCompanion.insert(name: 'Millilitr', shortName: 'ml'),
        UnitsCompanion.insert(name: 'Quti', shortName: 'quti'),
        UnitsCompanion.insert(name: 'Pachka', shortName: 'pachka'),
        UnitsCompanion.insert(name: 'Juft', shortName: 'juft'),
        UnitsCompanion.insert(name: 'To\'plam', shortName: 'to\'plam'),
        UnitsCompanion.insert(name: 'Metr', shortName: 'metr'),
        UnitsCompanion.insert(name: 'Rulon', shortName: 'rulon'),
      ]);
    });
  }

  Future<void> _seedPaymentTypes() async {
    if ((await db.paymentTypes.count().getSingle()) > 0) {
      return Future.value();
    }

    return db.batch((b) {
      b.insertAll(db.paymentTypes, [
        PaymentTypesCompanion.insert(name: PaymentTypesEnum.cash),
        PaymentTypesCompanion.insert(name: PaymentTypesEnum.card),
        PaymentTypesCompanion.insert(name: PaymentTypesEnum.terminal),
        PaymentTypesCompanion.insert(name: PaymentTypesEnum.debt),
      ]);
    });
  }

  Future<void> _seedCategoryColors() async {
    if ((await db.categoryColors.count().getSingle()) > 0) {
      return Future.value();
    }

    return db.batch((b) {
      b.insertAll(db.categoryColors, [
        CategoryColorsCompanion.insert(hex: 'FF6B6B'),
        CategoryColorsCompanion.insert(hex: 'F7B801'),
        CategoryColorsCompanion.insert(hex: '6BCB77'),
        CategoryColorsCompanion.insert(hex: '4D96FF'),
        CategoryColorsCompanion.insert(hex: '9D4EDD'),
        CategoryColorsCompanion.insert(hex: 'FF922B'),
        CategoryColorsCompanion.insert(hex: '20C997'),
        CategoryColorsCompanion.insert(hex: 'E64980'),
        CategoryColorsCompanion.insert(hex: '495057'),
        CategoryColorsCompanion.insert(hex: 'ADB5BD'),
      ]);
    });
  }

  Future<void> _seedItemCategories() async {
    if ((await db.itemCategories.count().getSingle()) > 0) {
      return Future.value();
    }

    return db.batch((b) {
      b.insertAll(db.itemCategories, [
        ItemCategoriesCompanion.insert(name: 'Ichimliklar', colorId: Value(1)),
        ItemCategoriesCompanion.insert(name: 'Oziq-ovqat', colorId: Value(2)),
        ItemCategoriesCompanion.insert(name: 'Meva-sabzavot', colorId: Value(3)),
        ItemCategoriesCompanion.insert(name: 'Maishiy', colorId: Value(4)),
        ItemCategoriesCompanion.insert(name: 'Shirinliklar', colorId: Value(5)),
        ItemCategoriesCompanion.insert(name: 'Sut mahsulotlari', colorId: Value(6)),
      ]);
    });
  }

  Future<void> _seedExpenseCategories() async {
    if ((await db.expenseCategories.count().getSingle()) > 0) {
      return Future.value();
    }

    return db.batch((b) {
      b.insertAll(db.expenseCategories, [
        ExpenseCategoriesCompanion.insert(name: 'Ijara'),
        ExpenseCategoriesCompanion.insert(name: 'Ish haqi'),
        ExpenseCategoriesCompanion.insert(name: 'Kommunal'),
        ExpenseCategoriesCompanion.insert(name: 'Transport'),
        ExpenseCategoriesCompanion.insert(name: 'Ofis xarajatlari'),
        ExpenseCategoriesCompanion.insert(name: 'Ta\'mirlash'),
        ExpenseCategoriesCompanion.insert(name: 'Marketing'),
        ExpenseCategoriesCompanion.insert(name: 'Boshqa'),
      ]);
    });
  }
}
