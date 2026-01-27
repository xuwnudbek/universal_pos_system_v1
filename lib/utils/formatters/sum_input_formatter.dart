import 'package:flutter/services.dart';

class SumInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all spaces and non-digit characters except decimal point
    String cleanText = newValue.text.replaceAll(' ', '').replaceAll(RegExp(r'[^\d.]'), '');

    // Handle decimal point
    List<String> parts = cleanText.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    // Format integer part with spaces
    String formattedInteger = _formatWithSpaces(integerPart);

    // Combine with decimal part if exists
    String formattedText = decimalPart.isNotEmpty ? '$formattedInteger.$decimalPart' : formattedInteger;

    // Calculate new cursor position
    int newOffset = _calculateCursorPosition(
      oldValue.text,
      newValue.text,
      formattedText,
      newValue.selection.baseOffset,
    );

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }

  String _formatWithSpaces(String number) {
    if (number.isEmpty) return '';

    // Add spaces every 3 digits from right to left
    String reversed = number.split('').reversed.join();
    List<String> chunks = [];

    for (int i = 0; i < reversed.length; i += 3) {
      int end = i + 3;
      if (end > reversed.length) end = reversed.length;
      chunks.add(reversed.substring(i, end));
    }

    return chunks.join(' ').split('').reversed.join();
  }

  int _calculateCursorPosition(
    String oldText,
    String newText,
    String formattedText,
    int cursorPosition,
  ) {
    int cleanPosition = 0;

    for (int i = 0; i < cursorPosition && i < newText.length; i++) {
      if (newText[i] != ' ') {
        cleanPosition++;
      }
    }

    int actualPosition = 0;
    int digitsCount = 0;

    for (int i = 0; i < formattedText.length; i++) {
      if (formattedText[i] != ' ' && formattedText[i] != '.') {
        digitsCount++;
        if (digitsCount >= cleanPosition) {
          actualPosition = i + 1;
          break;
        }
      } else if (formattedText[i] == '.' && digitsCount >= cleanPosition) {
        actualPosition = i;
        break;
      }
      actualPosition = i + 1;
    }

    if (actualPosition > formattedText.length) {
      actualPosition = formattedText.length;
    }

    return actualPosition;
  }
}
