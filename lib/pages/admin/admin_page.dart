import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/data/local/daos/procurements/procurement_items_dao.dart';
import 'package:universal_pos_system_v1/data/local/daos/procurements/procurements_dao.dart';
import 'package:universal_pos_system_v1/data/local/daos/stocks/stocks_dao.dart';
import 'package:universal_pos_system_v1/data/local/daos/transfers/transfers_dao.dart';
import 'package:universal_pos_system_v1/data/local/daos/units/units_dao.dart';
import 'package:universal_pos_system_v1/data/repositories/items/category_colors_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/items/item_categories_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/items/items_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/procurements/procurement_items_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/procurements/procurements_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/stocks/stocks_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/transfers/transfers_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/units/units_repository.dart';
import 'sidebar/app_sidebar.dart' as admin_sidebar;

import '../../data/local/app_database.dart';
import '../../data/local/daos/colors/category_colors_dao.dart';
import '../../data/local/daos/item_categories/item_categories_dao.dart';
import '../../data/local/daos/items/items_dao.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({
    super.key,
    required this.state,
    required this.child,
  });

  final Widget child;
  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>(
          create: (_) => AppDatabase(),
          dispose: (_, db) => db.close(),
        ),
        // Daos
        ProxyProvider<AppDatabase, ItemCategoriesDao>(
          update: (_, db, _) => ItemCategoriesDao(db),
          lazy: true,
        ),
        ProxyProvider<AppDatabase, ItemsDao>(
          update: (_, db, _) => ItemsDao(db),
          lazy: true,
        ),
        ProxyProvider<AppDatabase, UnitsDao>(
          update: (_, db, _) => UnitsDao(db),
          lazy: true,
        ),
        ProxyProvider<AppDatabase, CategoryColorsDao>(
          update: (_, db, _) => CategoryColorsDao(db),
          lazy: true,
        ),
        ProxyProvider<AppDatabase, StocksDao>(
          update: (_, db, _) => StocksDao(db),
          lazy: true,
        ),
        ProxyProvider<AppDatabase, TransfersDao>(
          update: (_, db, _) => TransfersDao(db),
          lazy: true,
        ),
        ProxyProvider<AppDatabase, ProcurementsDao>(
          update: (_, db, _) => ProcurementsDao(db),
          lazy: true,
        ),
        ProxyProvider<AppDatabase, ProcurementItemsDao>(
          update: (_, db, _) => ProcurementItemsDao(db),
          lazy: true,
        ),
        // Repositories
        ProxyProvider<UnitsDao, UnitsRepository>(
          update: (_, dao, _) => UnitsRepository(dao),
          lazy: true,
        ),
        ProxyProvider2<ItemCategoriesDao, CategoryColorsDao, ItemCategoriesRepository>(
          update: (_, dao0, dao1, _) => ItemCategoriesRepository(dao0, dao1),
          lazy: true,
        ),
        ProxyProvider<CategoryColorsDao, CategoryColorsRepository>(
          update: (_, dao, _) => CategoryColorsRepository(dao),
          lazy: true,
        ),
        ProxyProvider4<ItemsDao, ItemCategoriesDao, CategoryColorsDao, UnitsDao, ItemsRepository>(
          update: (_, dao0, dao1, dao2, dao3, _) => ItemsRepository(dao0, dao1, dao2, dao3),
          lazy: true,
        ),
        ProxyProvider<StocksDao, StocksRepository>(
          update: (_, dao, _) => StocksRepository(dao),
          lazy: true,
        ),
        ProxyProvider<TransfersDao, TransfersRepository>(
          update: (_, dao, _) => TransfersRepository(dao),
          lazy: true,
        ),
        ProxyProvider2<ProcurementsDao, ProcurementItemsDao, ProcurementsRepository>(
          update: (_, dao0, dao1, _) => ProcurementsRepository(dao0, dao1),
          lazy: true,
        ),
        ProxyProvider2<ProcurementItemsDao, ItemsRepository, ProcurementItemsRepository>(
          update: (_, dao, itemsRepository, _) => ProcurementItemsRepository(dao, itemsRepository),
          lazy: true,
        ),
      ],
      child: Scaffold(
        body: Row(
          children: [
            admin_sidebar.AppSidebar(),
            Builder(
              builder: (context) {
                return Expanded(child: child);
              },
            ),
          ],
        ),
      ),
    );
  }
}
