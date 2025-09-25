// lib/features/orders/data/model/invoice_model.dart

import 'invoice_item_model.dart';

class InvoiceModel {
  final String? invoiceNumber;
  final String? status;
  final String? paidAt;
  final List<InvoiceItemModel>? items;
  final int? totalAmount;
  final String? totalPrice;

  InvoiceModel({
    this.invoiceNumber,
    this.status,
    this.paidAt,
    this.items,
    this.totalAmount,
    this.totalPrice,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List?;
    final parsedItems = itemsList
        ?.map((e) => InvoiceItemModel.fromJson(e))
        .toList();

    return InvoiceModel(
      // 🛠️ معالجة كل حقل على حدة
      invoiceNumber: json['invoice_number'] as String? ?? 'N/A',
      status: json['status'] as String? ?? 'غير محدد',
      paidAt: json['paid_at'] as String?,
      items: parsedItems,
      totalAmount: json['total_amount'] as int? ?? 0,
      totalPrice: json['total_price'] as String? ?? '0.00',
    );
  }
}
