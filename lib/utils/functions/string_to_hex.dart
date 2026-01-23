int hexToColor(String? hex) {
  return int.tryParse('FF$hex', radix: 16) ?? 0xFF000000;
}
