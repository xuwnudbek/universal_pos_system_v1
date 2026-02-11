import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/widgets/button.dart';

class AddDebtAdditions extends StatefulWidget {
  const AddDebtAdditions({
    super.key,
    this.debtAdditions,
  });

  final DebtAdditions? debtAdditions;

  @override
  State<AddDebtAdditions> createState() => _AddDebtAdditionsState();
}

class _AddDebtAdditionsState extends State<AddDebtAdditions> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final description = _descriptionController.text;

      final debtAddition = DebtAdditions(
        title: title,
        description: description,
      );

      Navigator.pop(context, debtAddition);
      log("Form is valid");
    }

    log("Form is not valid");
  }

  void _onInitDebt() {
    if (widget.debtAdditions != null) {
      _titleController.text = widget.debtAdditions!.title;
      _descriptionController.text = widget.debtAdditions!.description;
    }
  }

  @override
  void initState() {
    _onInitDebt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final mq = MediaQuery.of(context);

    return AlertDialog(
      constraints: BoxConstraints(
        maxWidth: 400,
        minWidth: 400,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Qarz ma\'lumotlari'),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Qarz oluvchi nomi
            _field(
              _titleController,
              "Qarz oluvchi nomi",
              hintText: "Abdurazzaqov Bunyodbek",
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Qarz oluvchi nomi bo\'sh bo\'lmasligi kerak';
                }
                return null;
              },
            ),
            SizedBox(height: AppSpacing.sm),

            // Qisqacha ma'lumot
            _field(
              _descriptionController,
              "Qarz haqida",
              hintText: "Qarz haqida qisqacha ma\'lumot",
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Qarz haqidagi maydon bo\'sh bo\'lmasligi kerak';
                }
                return null;
              },
            ),
            SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Bekor qilish'),
        ),
        Button(
          onPressed: _onSubmit,
          child: const Text('Saqlash'),
        ),
      ],
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    String? hintText,
    String? Function(String?)? validator,
    bool isNumber = false,
    bool readOnly = false,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        readOnly: readOnly,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey[500],
          ),
          alignLabelWithHint: true,
          floatingLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
          ),
          hintText: hintText,
          suffixIcon: readOnly ? Icon(Icons.lock_outline, size: 16) : null,
        ),
        maxLines: maxLines,
        inputFormatters: inputFormatters,
        validator: validator,
      ),
    );
  }
}

class DebtAdditions {
  String title;
  String description;
  bool isPaid;

  DebtAdditions({
    required this.title,
    required this.description,
    this.isPaid = false,
  });
}
