class ItemFormResult {
  final String name;
  final String barcode;
  final double price;
  final double stock;
  final int categoryId;
  final int unitId;

  ItemFormResult({
    required this.name,
    required this.barcode,
    required this.price,
    required this.stock,
    required this.categoryId,
    required this.unitId,
  });
}
