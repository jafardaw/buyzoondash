// lib/features/orders/data/model/invoice_model.dart

import 'invoice_item_model.dart';

class InvoiceModel {
  final String invoiceNumber;
  final String status;
  final String paidAt;
  final List<InvoiceItemModel> items;
  final int totalAmount;
  final String totalPrice;

  InvoiceModel({
    required this.invoiceNumber,
    required this.status,
    required this.paidAt,
    required this.items,
    required this.totalAmount,
    required this.totalPrice,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List?;
    return InvoiceModel(
      invoiceNumber: json['invoice_number'] as String,
      status: json['status'] as String,
      paidAt: json['paid_at'] as String,
      items: itemsList != null
          ? itemsList.map((e) => InvoiceItemModel.fromJson(e)).toList()
          : [],
      totalAmount: json['total_amount'] as int,
      totalPrice: json['total_price'] as String,
    );
  }
}
