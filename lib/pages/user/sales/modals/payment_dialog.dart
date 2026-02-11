import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/data/local/enums/payment_types_enum.dart';
import 'package:universal_pos_system_v1/pages/user/sales/modals/add_debt_addition.dart';
import 'package:universal_pos_system_v1/pages/user/sales/providers/sales_provider.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';
import 'package:universal_pos_system_v1/utils/extensions/sum_extension.dart';
import 'package:universal_pos_system_v1/utils/functions/get_payment_type_name.dart';
import 'package:universal_pos_system_v1/widgets/icon_button2.dart';

class PaymentDialog extends StatefulWidget {
  const PaymentDialog({super.key});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  late FocusNode _keyboardFocusNode;

  // Selected payment type
  PaymentType? _selectedPaymentType;

  PaymentType? get selectedPaymentType => _selectedPaymentType;

  DebtAdditions? _debtAddition;

  DebtAdditions? get debtAddition => _debtAddition;

  set selectedPaymentType(PaymentType? type) {
    setState(() {
      _selectedPaymentType = type;
    });
  }

  int _calculatorInput = 0;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  set errorMessage(String? message) {
    setState(() {
      _errorMessage = message;
    });
  }

  @override
  void initState() {
    _keyboardFocusNode = FocusNode();

    super.initState();
  }

  void _onSelectPaymentType(PaymentType type) {
    setState(() {
      selectedPaymentType = type;
    });
  }

  void _onSelectDebtAddition(DebtAdditions? value) {
    setState(() {
      _debtAddition = value;
    });
  }

  void _onDeleteDebtAddition() {
    setState(() {
      _debtAddition = null;
    });
  }

  void _onSubmitted(SalesProvider provider) async {
    if (selectedPaymentType != null) {
      final tempSale = provider.tempSale;

      var result = await provider.payForSale(
        saleId: tempSale!.id,
        paymentTypeId: selectedPaymentType!.id,
        amount: _calculatorInput.toDouble(),
        debtAddition: debtAddition,
      );

      if (result == 100) {
        errorMessage = 'To\'lov miqdori qoldiqdan katta bo\'lishi mumkin emas.';
        Future.delayed(
          const Duration(seconds: 3),
          () {
            errorMessage = null;
          },
        );

        return;
      }

      setState(() {
        selectedPaymentType = null;
        _calculatorInput = 0;
        _debtAddition = null;
      });

      if (result == 101) {
        Navigator.of(context).pop(101);
      }
    } else {
      errorMessage = 'Iltimos, to\'lov turini tanlang.';

      Future.delayed(
        const Duration(seconds: 3),
        () {
          errorMessage = null;
        },
      );
    }
  }

  void _onNumberKeyPressed(int value) {
    setState(() {
      _calculatorInput = _calculatorInput * 10 + value;
    });
  }

  void _onBackspacePressed() {
    setState(() {
      _calculatorInput = _calculatorInput ~/ 10;
    });
  }

  void _onKeyEvent(
    KeyEvent event,
    SalesProvider provider,
  ) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey.keyLabel;

      // faqat raqamlar
      if (RegExp(r'^[0-9]$').hasMatch(key)) {
        _onNumberKeyPressed(int.parse(key));
        return;
      }

      // backspace
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        _onBackspacePressed();
      }

      // enter
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        _onSubmitted(provider);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final mq = MediaQuery.of(context);

    return Consumer<SalesProvider>(
      builder: (context, provider, _) {
        final totalAmount = provider.tempSale?.totalPrice ?? 0.0;
        final salePayments = provider.tempSale?.payments ?? [];

        final totalPaymentsAmount = salePayments.fold<double>(
          0.0,
          (p, e) => p + e.amount,
        );

        return AlertDialog(
          constraints: BoxConstraints(
            maxWidth: 700,
            minWidth: 700,
            maxHeight: 800,
            minHeight: 700,
          ),
          // @formatter:off
          title: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('To\'lov'),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              if (errorMessage != null)
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: Text(
                      errorMessage!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          // @formatter:on
          content: KeyboardListener(
            autofocus: true,
            focusNode: _keyboardFocusNode,
            onKeyEvent: (value) {
              _onKeyEvent(value, provider);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.lg,
              children: [
                Row(
                  spacing: AppSpacing.lg,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Column(
                        spacing: AppSpacing.sm,
                        children: [
                          _buildAmountCard(totalAmount, typeValue: 0),
                          _buildAmountCard(totalPaymentsAmount, typeValue: 1),
                          _buildAmountCard(
                            totalAmount - totalPaymentsAmount,
                            typeValue: 2,
                          ),
                        ],
                      ),
                    ),
                    // To'lovlar tarixi
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 218,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        child: salePayments.isEmpty
                            ? Center(
                                child: Text(
                                  'Hech qanday to\'lov amalga oshirilmagan.',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.max,
                                children: salePayments.map((payment) {
                                  final index = salePayments.indexOf(payment) + 1;

                                  return _buildPaymentRow(
                                    index: index,
                                    paymentType: payment.paymentType,
                                    amount: payment.amount.intOrDouble.str.toSumString(),
                                  );
                                }).toList(),
                              ),
                      ),
                    ),
                  ],
                ),
                // Payment Types Buttons & Calculator
                Row(
                  spacing: AppSpacing.lg,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        spacing: AppSpacing.sm,
                        children: [
                          ...provider.paymentTypes.map(
                            (paymentType) {
                              final isSelected = selectedPaymentType == paymentType;

                              final isDebt = paymentType.name == PaymentTypesEnum.debt;

                              return _buildPaymentTypeButton(
                                title: getPaymentName(paymentType.name),
                                iconData: paymentType.name.iconData,
                                selected: isSelected,
                                onTap: () async {
                                  if (isDebt) {
                                    final result = await showDialog<DebtAdditions?>(
                                      context: context,
                                      builder: (context) {
                                        return AddDebtAdditions();
                                      },
                                    );

                                    if (result != null) {
                                      inspect(result);
                                      _onSelectDebtAddition(result);
                                    } else {
                                      return;
                                    }
                                  } else {
                                    _onSelectDebtAddition(null);
                                  }

                                  _onSelectPaymentType(paymentType);
                                },
                              );
                            },
                          ),
                          if (debtAddition != null)
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(debtAddition?.title ?? ""),
                                      Text(
                                        debtAddition?.description ?? "",
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                        overflow: TextOverflow.fade,
                                      ),
                                      SizedBox(height: AppSpacing.sm),
                                      Text(
                                        _calculatorInput.intOrDouble.str.toSumString("UZS"),
                                        style: textTheme.headlineSmall?.copyWith(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton2(
                                      icon: LucideIcons.trash2,
                                      type: IconButton2Type.danger,
                                      onPressed: _onDeleteDebtAddition,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      width: 328,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        spacing: AppSpacing.md,
                        children: [
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  _calculatorInput.intOrDouble.str.toSumString(),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                ),
                              ],
                            ),
                          ),

                          // Calculator buttons can be added here
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: AppSpacing.sm,
                            children: [
                              SizedBox(
                                width: 226,
                                height: 300,
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  spacing: AppSpacing.sm,
                                  runSpacing: AppSpacing.sm,
                                  children: [
                                    ...List.generate(9, (index) {
                                      final number = index + 1;
                                      return _buildCalculatorButton(
                                        number.toString(),
                                        onPressed: () {
                                          setState(() {
                                            _calculatorInput = _calculatorInput * 10 + number;
                                          });
                                        },
                                      );
                                    }),
                                    _buildCalculatorButton(
                                      '0',
                                      onPressed: () {
                                        setState(() {
                                          _calculatorInput = _calculatorInput * 10;
                                        });
                                      },
                                    ),
                                    _buildCalculatorButton(
                                      '00',
                                      onPressed: () {
                                        setState(() {
                                          _calculatorInput = _calculatorInput * 100;
                                        });
                                      },
                                    ),
                                    _buildCalculatorButton(
                                      'T',
                                      onPressed: () {
                                        setState(() {
                                          _calculatorInput = (totalAmount - totalPaymentsAmount).round();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                spacing: AppSpacing.sm,
                                children: [
                                  _buildCalculatorButton(
                                    'C',
                                    onPressed: () {
                                      setState(() {
                                        _calculatorInput = 0;
                                      });
                                    },
                                  ),
                                  // backspace button
                                  _buildCalculatorButton(
                                    '',
                                    onPressed: () {
                                      _onBackspacePressed();
                                    },
                                    icon: LucideIcons.delete,
                                  ),
                                  _buildCalculatorButton(
                                    '=',
                                    onPressed: _calculatorInput != 0 && selectedPaymentType != null && _calculatorInput <= (totalAmount - totalPaymentsAmount)
                                        ? () async {
                                            _onSubmitted(provider);
                                          }
                                        : null,
                                    icon: LucideIcons.check,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // @formatter:off
  Widget _buildAmountCard(
    double amount, {
    int typeValue = 0, // 0 - total, 1 - paid, 2 - remaining
  }) {
    return Container(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        color: typeValue == 0
            ? Colors.blue
            : typeValue == 1
            ? Colors.green
            : Colors.orangeAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            typeValue == 0
                ? 'Jami'
                : typeValue == 1
                ? 'To\'langan'
                : 'Qoldiq',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          Text(
            '${amount.intOrDouble.str.toSumString()} UZS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow({
    required int index,
    required PaymentType paymentType,
    required String amount,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        // Index
        Text(
          "$index. ",
          style: textTheme.titleMedium,
        ),
        Text(
          getPaymentName(paymentType.name),
          style: textTheme.bodyMedium,
        ),
        SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            "  -  " * 30,
            maxLines: 1,
            style: textTheme.bodySmall?.copyWith(
              color: Colors.grey[400],
            ),
            textAlign: TextAlign.left,
            overflow: TextOverflow.visible,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: amount,
                style: textTheme.titleMedium,
              ),
              TextSpan(
                text: ' UZS',
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentTypeButton({
    String title = '',
    required IconData iconData,
    bool selected = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      minTileHeight: 70,
      tileColor: selected ? Colors.blue : Colors.grey[200],
      selectedColor: selected ? Colors.white : Colors.black,
      selectedTileColor: selected ? Colors.blue : Colors.transparent,
      selected: selected,
      onTap: onTap,
      title: Row(
        children: [
          Icon(
            iconData,
            size: 20,
            color: selected ? Colors.white : Colors.black,
          ),
          const SizedBox(width: AppSpacing.md),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildCalculatorButton(
    String label, {
    VoidCallback? onPressed,
    IconData? icon,
  }) {
    bool isClear = label == 'C';
    bool isTotal = label == 'T';
    bool isBackspace = icon == LucideIcons.delete;
    bool isEqual = label == '=';
    bool enabled = onPressed != null;

    return SizedBox(
      width: 70,
      height: isEqual ? 148 : 70,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: !enabled && isEqual
                ? Colors.grey
                : isClear
                ? Colors.redAccent
                : isBackspace || isTotal
                ? Colors.orangeAccent
                : isEqual
                ? Colors.green
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: icon != null
                ? Icon(icon, size: 28)
                : Text(
                    label,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: !enabled && isEqual ? Colors.white : Colors.black,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
