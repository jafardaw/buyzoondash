class InvoiceItemModel {
  final int? productId;
  final String? name;
  final String? unitPrice;
  final int? quantity;
  final String? totalPrice;

  InvoiceItemModel({
    required this.productId,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
  });

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) {
    return InvoiceItemModel(
      productId: json['product_id'] as int?,
      name: json['name'] as String? ?? 'غير متوفر',
      unitPrice: json['unit_price'] as String? ?? '0.00',
      quantity: json['quantity'] as int? ?? 0,
      totalPrice: json['total_price'] as String? ?? '0.00',
    );
  }
}
