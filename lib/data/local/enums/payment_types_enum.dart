import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum PaymentTypesEnum {
  cash,
  card,
  terminal,
  debt
  ;

  IconData get iconData {
    switch (this) {
      case PaymentTypesEnum.cash:
        return LucideIcons.banknote;
      case PaymentTypesEnum.card:
        return LucideIcons.creditCard;
      case PaymentTypesEnum.terminal:
        return LucideIcons.smartphone;
      case PaymentTypesEnum.debt:
        return LucideIcons.wallet;
    }
  }
}
