// lib/features/orders/data/model/invoice_item_model.dart

class InvoiceItemModel {
  final int productId;
  final String name;
  final String unitPrice;
  final int quantity;
  final String totalPrice;

  InvoiceItemModel({
    required this.productId,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
  });

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) {
    return InvoiceItemModel(
      productId: json['product_id'] as int,
      name: json['name'] as String,
      unitPrice: json['unit_price'] as String,
      quantity: json['quantity'] as int,
      totalPrice: json['total_price'] as String,
    );
  }
}
