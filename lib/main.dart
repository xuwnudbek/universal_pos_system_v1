import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/data/local/daos/debts/debts_dao.dart';
import 'package:universal_pos_system_v1/data/repositories/debts/debts_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/payment_types/payment_types_repository.dart';

import './data/local/app_database.dart';
import './data/local/daos/colors/category_colors_dao.dart';
import './data/local/daos/item_categories/item_categories_dao.dart';
import './data/local/daos/items/items_dao.dart';
import './data/local/daos/payment_types/payment_types_dao.dart';
import './data/local/daos/sale_items/sale_items_dao.dart';
import './data/local/daos/sale_payments/sale_payments_dao.dart';
import './data/local/daos/sales/sales_dao.dart';
import './data/local/daos/units/units_dao.dart';
import './data/local/daos/users/users_dao.dart';
import './data/local/seed/base_seeder.dart';
import './data/repositories/items/category_colors_repository.dart';
import './data/repositories/items/item_categories_repository.dart';
import './data/repositories/items/items_repository.dart';
import './data/repositories/sale_payments/sale_payments_repository.dart';
import './data/repositories/sales/sale_items_repository.dart';
import './data/repositories/sales/sales_repository.dart';
import './data/repositories/units/units_repository.dart';
import './data/repositories/users/users_repository.dart';
import './pages/auth/provider/auth_provider.dart';
import './utils/functions/local_storage.dart';
import './utils/router/app_router.dart';
import './utils/theme/app_theme.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await LocalStorage.init();
      final db = AppDatabase();
      await BaseSeeder(db).seedBaseData();

      runApp(
        Provider.value(
          value: db,
          child: const MyApp(),
        ),
      );
    },
    (error, stackTrace) {
      log("Error caught: $error");
      log("Stack trace: $stackTrace");
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // @formatter:off
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Daos
        ProxyProvider<AppDatabase, UsersDao>(
          update: (_, db, _) => UsersDao(db),
        ),
        ProxyProvider<AppDatabase, ItemsDao>(
          update: (_, db, _) => ItemsDao(db),
        ),
        ProxyProvider<AppDatabase, ItemCategoriesDao>(
          update: (_, db, _) => ItemCategoriesDao(db),
        ),
        ProxyProvider<AppDatabase, CategoryColorsDao>(
          update: (_, db, _) => CategoryColorsDao(db),
        ),
        ProxyProvider<AppDatabase, UnitsDao>(
          update: (_, db, _) => UnitsDao(db),
        ),
        ProxyProvider<AppDatabase, SalesDao>(
          update: (_, db, _) => SalesDao(db),
        ),
        ProxyProvider<AppDatabase, SaleItemsDao>(
          update: (_, db, _) => SaleItemsDao(db),
        ),
        ProxyProvider<AppDatabase, SalePaymentsDao>(
          update: (_, db, _) => SalePaymentsDao(db),
        ),
        ProxyProvider<AppDatabase, PaymentTypesDao>(
          update: (_, db, _) => PaymentTypesDao(db),
        ),
        ProxyProvider<AppDatabase, DebtsDao>(
          update: (_, db, _) => DebtsDao(db),
        ),

        // Repositories
        ProxyProvider<UsersDao, UsersRepository>(
          update: (_, dao, _) => UsersRepository(dao),
        ),
        ProxyProvider4<ItemsDao, ItemCategoriesDao, CategoryColorsDao, UnitsDao, ItemsRepository>(
          update: (_, dao0, dao1, dao2, dao3, _) => ItemsRepository(dao0, dao1, dao2, dao3),
        ),
        ProxyProvider2<ItemCategoriesDao, CategoryColorsDao, ItemCategoriesRepository>(
          update: (_, dao0, dao1, _) => ItemCategoriesRepository(dao0, dao1),
        ),
        ProxyProvider<CategoryColorsDao, CategoryColorsRepository>(
          update: (_, dao, _) => CategoryColorsRepository(dao),
        ),
        ProxyProvider<UnitsDao, UnitsRepository>(
          update: (_, dao, _) => UnitsRepository(dao),
        ),
        ProxyProvider5<SalesDao, SaleItemsDao, ItemsDao, SalePaymentsDao, PaymentTypesDao, SalesRepository>(
          update: (_, dao0, dao1, dao2, dao3, dao4, _) => SalesRepository(dao0, dao1, dao2, dao3, dao4),
        ),
        ProxyProvider2<SaleItemsDao, ItemsDao, SaleItemsRepository>(
          update: (_, dao0, dao1, _) => SaleItemsRepository(dao0, dao1),
        ),
        ProxyProvider2<SalePaymentsDao, PaymentTypesDao, SalePaymentsRepository>(
          update: (_, dao0, dao1, _) => SalePaymentsRepository(dao0, dao1),
        ),
        ProxyProvider<PaymentTypesDao, PaymentTypesRepository>(
          update: (_, dao, _) => PaymentTypesRepository(dao),
        ),
        ProxyProvider<DebtsDao, DebtsRepository>(
          update: (_, dao, _) => DebtsRepository(dao),
        ),

        // Providers
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            context.read<UsersRepository>(),
          ),
        ),
      ],
      builder: (context, _) => MaterialApp.router(
        color: Colors.blue,
        debugShowCheckedModeBanner: false,
        title: 'Universal POS System',
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        locale: Locale('uz', 'UZ'),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('uz', 'UZ'),
          Locale('en', 'US'),
        ],
        routerConfig: appRouter,
      ),
    );
  }
}
