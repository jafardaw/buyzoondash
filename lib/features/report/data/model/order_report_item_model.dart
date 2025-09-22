import 'package:buyzoonapp/features/report/data/model/product_report_model.dart';

class OrderReportItemModel {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final String totalPrice;
  final String? refundRate;
  final ProductReportModel? product;

  OrderReportItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.totalPrice,
    this.refundRate,
    this.product,
  });

  factory OrderReportItemModel.fromJson(Map<String, dynamic> json) {
    return OrderReportItemModel(
      id: json['id'] as int,
      orderId: json['order_id'] as int,
      productId: json['product_id'] as int,
      quantity: json['quantity'] as int,
      totalPrice: json['total_price'] as String,
      refundRate: json['refund_rate'] as String?,
      product: json['product'] != null
          ? ProductReportModel.fromJson(json['product'])
          : null,
    );
  }
}
