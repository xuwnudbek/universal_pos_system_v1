import 'package:intl/intl.dart';

extension NumExtension on num {
  String get toSum {
    return NumberFormat('#,###').format(this);
  }

  ({num value, String str}) get intOrDouble {
    if (this % 1 == 0) {
      return (value: this.toInt(), str: "${this.toInt()}");
    } else {
      return (value: toDouble(), str: (toDouble().toStringAsFixed(1)));
    }
  }
}
