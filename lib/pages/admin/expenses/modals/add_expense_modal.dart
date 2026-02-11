import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'package:universal_pos_system_v1/utils/extensions/num_extension.dart';
import 'package:universal_pos_system_v1/utils/formatters/sum_input_formatter.dart';
import 'package:universal_pos_system_v1/widgets/button.dart';

class ExpenseFormResult {
  final int categoryId;
  final double amount;
  final DateTime expenseDate;
  final String? note;

  ExpenseFormResult({
    required this.categoryId,
    required this.amount,
    required this.expenseDate,
    this.note,
  });
}

class AddExpenseModal extends StatefulWidget {
  final List<ExpenseCategory> categories;
  final Expense? expense;

  const AddExpenseModal({
    super.key,
    required this.categories,
    this.expense,
  });

  @override
  State<AddExpenseModal> createState() => _AddExpenseModalState();
}

class _AddExpenseModalState extends State<AddExpenseModal> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  int? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _selectedCategoryId = widget.expense!.categoryId;
      _amountController.text = widget.expense!.amount.intOrDouble.str;
      _noteController.text = widget.expense!.note ?? '';
      _selectedDate = widget.expense!.expenseDate;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isEditing = widget.expense != null;

    return Dialog(
      child: Container(
        width: 500,
        constraints: BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerTheme.color ?? Colors.grey,
                    width: AppBorderWidth.thin,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.receipt,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    isEditing ? 'Xarajatni tahrirlash' : 'Xarajat qo\'shish',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(LucideIcons.x, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category
                      Row(
                        spacing: AppSpacing.md,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kategoriya',
                                  style: textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: AppSpacing.sm),
                                DropdownButtonFormField<int>(
                                  initialValue: _selectedCategoryId,
                                  decoration: InputDecoration(
                                    hintText: 'Kategoriyani tanlang',
                                    // prefixIcon: Icon(LucideIcons.tag, size: 18),
                                  ),
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                  menuMaxHeight: 300,
                                  alignment: Alignment.centerLeft,
                                  items: widget.categories
                                      .where((cat) => cat.isActive)
                                      .map(
                                        (category) => DropdownMenuItem(
                                          value: category.id,
                                          child: Text(category.name),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategoryId = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Kategoriyani tanlang';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Date
                                Text(
                                  'Sana',
                                  style: textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: AppSpacing.sm),
                                InkWell(
                                  onTap: () => _selectDate(context),
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(LucideIcons.calendar, size: 18),
                                    ),
                                    child: Text(
                                      '${_selectedDate.day.toString().padLeft(2, '0')}.${_selectedDate.month.toString().padLeft(2, '0')}.${_selectedDate.year}',
                                      style: textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.md),

                      // Amount
                      Text(
                        'Summa',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [SumInputFormatter()],
                        decoration: InputDecoration(
                          hintText: 'Summani kiriting',
                          prefixIcon: Icon(LucideIcons.dollarSign, size: 18),
                          suffixText: 'so\'m',
                        ),
                        validator: (value) {
                          value = value?.replaceAll(' ', '');
                          if (value == null || value.isEmpty) {
                            return 'Summani kiriting';
                          }
                          final amount = double.tryParse(value);
                          if (amount == null || amount <= 0) {
                            return 'Noto\'g\'ri summa';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: AppSpacing.md),

                      SizedBox(height: AppSpacing.md),

                      // Note
                      Text(
                        'Izoh (ixtiyoriy)',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: _noteController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Izoh yozing...',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.dividerTheme.color ?? Colors.grey,
                    width: AppBorderWidth.thin,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Bekor qilish'),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Button(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final result = ExpenseFormResult(
                          categoryId: _selectedCategoryId!,
                          amount: double.parse(_amountController.text.replaceAll(' ', '')),
                          expenseDate: _selectedDate,
                          note: _noteController.text.isNotEmpty ? _noteController.text : null,
                        );
                        Navigator.of(context).pop(result);
                      }
                    },
                    child: Text(isEditing ? 'Saqlash' : 'Qo\'shish'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
