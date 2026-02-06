import 'package:universal_pos_system_v1/data/local/enums/payment_types_enum.dart';

String getPaymentName(PaymentTypesEnum type) {
  switch (type) {
    case PaymentTypesEnum.cash:
      return 'Naqd';
    case PaymentTypesEnum.card:
      return 'Plastik karta';
    case PaymentTypesEnum.terminal:
      return 'Terminal';
    case PaymentTypesEnum.debt:
      return 'Qarz';
  }
}
