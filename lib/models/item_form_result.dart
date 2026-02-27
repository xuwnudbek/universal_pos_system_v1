class ItemFormResult {
  final String name;
  final String barcode;
  final int categoryId;
  final int unitId;
  final double salePrice;
  final String? imagePath;

  ItemFormResult({
    required this.name,
    required this.barcode,
    required this.categoryId,
    required this.unitId,
    required this.salePrice,
    this.imagePath,
  });
}
