import 'package:intl/intl.dart';

extension NumExtension on num {
  String get toSum {
    return NumberFormat('#,###').format(this);
  }
}
