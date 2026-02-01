import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/local/enums/payment_types_enum.dart';

class SalePaymentFull {
  final SalePayment salePayment;
  final PaymentType paymentType;

  SalePaymentFull({
    required this.salePayment,
    required this.paymentType,
  });

  factory SalePaymentFull.from({
    required SalePayment salePayment,
    required PaymentType paymentType,
  }) {
    return SalePaymentFull(
      salePayment: salePayment,
      paymentType: paymentType,
    );
  }

  int get id => salePayment.id;
  int get saleId => salePayment.saleId;
  int get paymentTypeId => salePayment.paymentTypeId;
  double get amount => salePayment.amount;
  DateTime get createdAt => salePayment.createdAt;

  PaymentTypesEnum get paymentTypeName => paymentType.name;
}
