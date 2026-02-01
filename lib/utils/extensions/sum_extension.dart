extension SumStringExtension on Object {
  String toSumString([String? currency]) {
    final text = toString();

    if (text.isEmpty) return '';

    // Remove spaces and invalid chars (same as formatter)
    String cleanText = text.replaceAll(' ', '').replaceAll(RegExp(r'[^\d.]'), '');

    if (cleanText.isEmpty) return '';

    final parts = cleanText.split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '';

    final formattedInteger = _formatWithSpaces(integerPart);

    if (currency == null || currency.isEmpty) {
      return decimalPart.isNotEmpty ? '$formattedInteger.$decimalPart' : formattedInteger;
    }

    return decimalPart.isNotEmpty ? '$formattedInteger.$decimalPart $currency' : '$formattedInteger $currency';
  }

  static String _formatWithSpaces(String number) {
    if (number.isEmpty) return '';

    final reversed = number.split('').reversed.join();
    final chunks = <String>[];

    for (int i = 0; i < reversed.length; i += 3) {
      int end = i + 3;
      if (end > reversed.length) end = reversed.length;
      chunks.add(reversed.substring(i, end));
    }

    return chunks.join(' ').split('').reversed.join();
  }
}
