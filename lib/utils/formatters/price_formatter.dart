import 'package:intl/intl.dart';

/// O'zbek so'mi uchun formatter
/// Misol: 1000000 -> 1 000 000 so'm
class SumFormatter {
  static final _formatter = NumberFormat('#,###', 'en_US');

  /// Sonni O'zbek so'mi formatida qaytaradi
  /// [amount] - formatlash kerak bo'lgan son
  static String format(num amount) {
    final formatted = _formatter.format(amount.floor()).replaceAll(',', ' ');
    return formatted;
  }
}

/// Extension for easier usage
extension SumExtension on num {
  String get toSum => SumFormatter.format(this);
}
