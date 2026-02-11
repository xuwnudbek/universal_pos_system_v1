extension StringExtension on String {
  bool hasDigit() {
    return RegExp(r'\d').hasMatch(this);
  }

  int getDigit() {
    final match = RegExp(r'\d+').firstMatch(this);
    if (match != null) {
      return int.parse(match.group(0)!);
    }
    throw FormatException('No digits found in the string');
  }
}
