import 'package:buyzoonapp/features/invoice/data/model/invoice_model.dart';
import 'package:buyzoonapp/features/report/data/model/order_report_item_model.dart';
import 'package:buyzoonapp/features/users/data/model/user_model.dart';

class RefundedOrdersModel {
  final int id;
  final String? invoiceNumber;
  final double totalPrice;
  final double totalProfit;
  final UserModel? user;
  final String status;
  final String paymentStatus;
  final List<OrderReportItemModel> orderItems;
  final String createdAt;

  RefundedOrdersModel({
    required this.id,
    this.invoiceNumber,
    required this.totalPrice,
    required this.totalProfit,
    this.user,
    required this.status,
    required this.paymentStatus,
    required this.orderItems,
    required this.createdAt,
  });

  factory RefundedOrdersModel.fromJson(Map<String, dynamic> json) {
    return RefundedOrdersModel(
      id: json['id'] as int,
      invoiceNumber: json['invoice_number'] as String?,
      totalPrice: json['total_price'] as double,
      totalProfit: json['total_profit'] as double,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      status: json['status'] as String,
      paymentStatus: json['payment_status'] as String,
      orderItems: (json['order_items'] as List)
          .map((e) => OrderReportItemModel.fromJson(e))
          .toList(),
      createdAt: json['created_at'] as String,
    );
  }
}
