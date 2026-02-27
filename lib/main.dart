import 'dart:async';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/data/local/daos/debts/debts_dao.dart';
import 'package:universal_pos_system_v1/data/local/daos/store_settings/store_settings_dao.dart';
import 'package:universal_pos_system_v1/data/repositories/debts/debts_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/store_settings/store_settings_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/payment_types/payment_types_repository.dart';

import './data/local/app_database.dart';
import './data/local/daos/colors/category_colors_dao.dart';
import './data/local/daos/item_categories/item_categories_dao.dart';
import './data/local/daos/items/items_dao.dart';
import './data/local/daos/payment_types/payment_types_dao.dart';
import './data/local/daos/sale_items/sale_items_dao.dart';
import './data/local/daos/sale_payments/sale_payments_dao.dart';
import './data/local/daos/sales/sales_dao.dart';
import './data/local/daos/stocks/stocks_dao.dart';
import './data/local/daos/units/units_dao.dart';
import './data/local/daos/users/users_dao.dart';
import './data/repositories/stocks/stocks_repository.dart';
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
import './utils/logger/app_logger.dart';
import './utils/router/app_router.dart';
import './utils/theme/app_theme.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Logger — must be first so all subsequent errors are captured
      await AppLogger.init();

      // Catch Flutter framework errors (widget build, layout, etc.)
      FlutterError.onError = (FlutterErrorDetails details) {
        AppLogger.error(
          'Flutter framework error',
          details.exception,
          details.stack,
        );
      };

      // Window manager setup
      await windowManager.ensureInitialized();
      const windowOptions = WindowOptions(
        size: Size(1280, 720),
        minimumSize: Size(800, 600),
        center: true,
        title: 'Universal POS System',
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.hidden,
      );
      await windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
        await windowManager.maximize();
        await windowManager.setFullScreen(true);
      });

      await LocalStorage.init();
      final db = AppDatabase();
      await BaseSeeder(db).seedBaseData();

      // Intercept window close to properly release DB before destroying window
      await windowManager.setPreventClose(true);
      windowManager.addListener(_AppWindowListener(db));

      runApp(
        Provider.value(
          value: db,
          child: const MyApp(),
        ),
      );
    },
    (error, stackTrace) {
      // throw error;
      AppLogger.error('Uncaught error', error, stackTrace);
    },
  );
}

/// Listens for the native window close event (X button / Alt+F4).
/// Awaits database.close() before actually destroying the window,
/// which prevents SQLite file lock and dangling processes.
class _AppWindowListener extends WindowListener {
  _AppWindowListener(this._db);

  final AppDatabase _db;

  @override
  Future<void> onWindowClose() async {
    try {
      // Flush WAL and release all SQLite file handles
      await _db.close();
    } catch (_) {
      // Ensure the window is destroyed even if close throws
    } finally {
      // Flush log file buffers before exit
      await AppLogger.dispose();
      // Allow the window to actually close now
      await windowManager.destroy();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        ProxyProvider<AppDatabase, StoreSettingsDao>(
          update: (_, db, _) => StoreSettingsDao(db),
        ),

        // Repositories
        ProxyProvider<UsersDao, UsersRepository>(
          update: (_, dao, _) => UsersRepository(dao),
        ),
        ProxyProvider4<ItemsDao, ItemCategoriesDao, CategoryColorsDao, UnitsDao, ItemsRepository>(
          update: (_, dao0, dao1, dao2, dao3, _) => ItemsRepository(dao0, dao1, dao2, dao3),
        ),
        ProxyProvider3<ItemCategoriesDao, CategoryColorsDao, ItemsDao, ItemCategoriesRepository>(
          update: (_, dao0, dao1, dao2, _) => ItemCategoriesRepository(dao0, dao1, dao2),
        ),
        ProxyProvider<CategoryColorsDao, CategoryColorsRepository>(
          update: (_, dao, _) => CategoryColorsRepository(dao),
        ),
        ProxyProvider<UnitsDao, UnitsRepository>(
          update: (_, dao, _) => UnitsRepository(dao),
        ),
        ProxyProvider6<SalesDao, SaleItemsDao, ItemsDao, SalePaymentsDao, PaymentTypesDao, DebtsDao, SalesRepository>(
          update: (_, dao0, dao1, dao2, dao3, dao4, dao5, _) => SalesRepository(dao0, dao1, dao2, dao3, dao4, dao5),
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
        ProxyProvider<StoreSettingsDao, StoreSettingsRepository>(
          update: (_, dao, _) => StoreSettingsRepository(dao),
        ),
        ProxyProvider<AppDatabase, StocksDao>(
          update: (_, db, _) => StocksDao(db),
        ),
        ProxyProvider<StocksDao, StocksRepository>(
          update: (_, dao, _) => StocksRepository(dao),
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
        routerConfig: appRouter(context.read<AuthProvider>()),
      ),
    );
  }
}
