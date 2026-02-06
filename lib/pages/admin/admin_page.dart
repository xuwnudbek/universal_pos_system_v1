import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/data/local/daos/procurements/procurement_items_dao.dart';
import 'package:universal_pos_system_v1/data/local/daos/procurements/procurements_dao.dart';
import 'package:universal_pos_system_v1/data/local/daos/stocks/stocks_dao.dart';
import 'package:universal_pos_system_v1/data/local/daos/transfers/transfers_dao.dart';
import 'package:universal_pos_system_v1/data/local/daos/expenses/expenses_dao.dart';
import 'package:universal_pos_system_v1/data/local/daos/expenses/expense_categories_dao.dart';
import 'package:universal_pos_system_v1/data/repositories/procurements/procurement_items_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/procurements/procurements_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/stocks/stocks_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/transfers/transfers_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/expenses/expenses_repository.dart';
import 'package:universal_pos_system_v1/data/repositories/expenses/expense_categories_repository.dart';
import 'package:universal_pos_system_v1/pages/admin/sidebar/provider/app_sidebar_provider.dart';
import 'sidebar/app_sidebar.dart';

import '../../data/local/app_database.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Daos
        Provider<StocksDao>(
          create: (context) => StocksDao(context.read<AppDatabase>()),
        ),
        Provider<TransfersDao>(
          create: (context) => TransfersDao(context.read<AppDatabase>()),
        ),
        Provider<ProcurementsDao>(
          create: (context) => ProcurementsDao(context.read<AppDatabase>()),
        ),
        Provider<ProcurementItemsDao>(
          create: (context) => ProcurementItemsDao(context.read<AppDatabase>()),
        ),
        Provider<ExpenseCategoriesDao>(
          create: (context) => ExpenseCategoriesDao(context.read<AppDatabase>()),
        ),
        Provider<ExpensesDao>(
          create: (context) => ExpensesDao(context.read<AppDatabase>()),
        ),

        // Repositories
        ProxyProvider<StocksDao, StocksRepository>(
          update: (_, dao, _) => StocksRepository(dao),
        ),
        ProxyProvider<TransfersDao, TransfersRepository>(
          update: (_, dao, _) => TransfersRepository(dao),
        ),
        ProxyProvider3<ProcurementsDao, ProcurementItemsDao, StocksDao, ProcurementsRepository>(
          update: (_, dao0, dao1, dao2, _) => ProcurementsRepository(dao0, dao1, dao2),
        ),
        ProxyProvider2<ProcurementItemsDao, StocksDao, ProcurementItemsRepository>(
          update: (_, dao0, dao1, _) => ProcurementItemsRepository(dao0, dao1),
        ),
        ProxyProvider<ExpenseCategoriesDao, ExpenseCategoriesRepository>(
          update: (_, dao, _) => ExpenseCategoriesRepository(dao),
        ),
        ProxyProvider<ExpensesDao, ExpensesRepository>(
          update: (_, dao, _) => ExpensesRepository(dao),
        ),

        // Add other providers as needed
        ChangeNotifierProvider(create: (_) => AppSidebarProvider()),
      ],
      child: Scaffold(
        body: Row(
          children: [
            AppSidebar(),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
