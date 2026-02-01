import 'package:universal_pos_system_v1/data/local/app_database.dart';

class ExpenseFull {
  final Expense expense;
  final ExpenseCategory category;

  ExpenseFull({
    required this.expense,
    required this.category,
  });
}
