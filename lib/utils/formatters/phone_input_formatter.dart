import 'package:flutter/services.dart';

/// Phone input formatter for +998 XX XXX XXXX format (Uzbekistan)
class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Get only digits from the input
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Remove country code if user typed it
    if (digits.startsWith('998')) {
      digits = digits.substring(3);
    }

    // Limit to 9 digits (without country code)
    if (digits.length > 9) {
      digits = digits.substring(0, 9);
    }

    // If empty, return empty
    if (digits.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Build formatted string
    final buffer = StringBuffer('+998');

    // Add first 2 digits (operator code) with space
    if (digits.isNotEmpty) {
      buffer.write(' ');
      buffer.write(digits.substring(0, digits.length > 2 ? 2 : digits.length));
    }

    // Add next 3 digits with space
    if (digits.length > 2) {
      buffer.write(' ');
      buffer.write(digits.substring(2, digits.length > 5 ? 5 : digits.length));
    }

    // Add last 4 digits with space
    if (digits.length > 5) {
      buffer.write(' ');
      buffer.write(digits.substring(5));
    }

    final formattedText = buffer.toString();

    // Calculate cursor position
    int cursorPosition = formattedText.length;

    // If user is typing, place cursor at end
    // If user is deleting, adjust accordingly
    if (newValue.selection.end < newValue.text.length) {
      // User is editing in the middle
      int digitsBeforeCursor = newValue.text.substring(0, newValue.selection.end).replaceAll(RegExp(r'\D'), '').length;

      if (digitsBeforeCursor == 0) {
        cursorPosition = 0;
      } else {
        // Find position in formatted text
        int digitCount = 0;
        for (int i = 0; i < formattedText.length; i++) {
          if (RegExp(r'\d').hasMatch(formattedText[i])) {
            digitCount++;
            if (digitCount == digitsBeforeCursor) {
              cursorPosition = i + 1;
              break;
            }
          }
        }
      }
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
