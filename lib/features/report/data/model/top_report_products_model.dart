// lib/features/financial_report/data/model/top_products_model.dart

import 'package:buyzoonapp/features/report/data/model/product_report_model.dart';

class TopReportProductsModel {
  final ProductReportModel product;
  final int quantity;
  final double totalSales;

  TopReportProductsModel({
    required this.product,
    required this.quantity,
    required this.totalSales,
  });
  factory TopReportProductsModel.fromJson(Map<String, dynamic> json) {
    return TopReportProductsModel(
      product: ProductReportModel.fromJson(json['product']),
      quantity: json['quantity'] as int,
      // *** تم تصحيح هذا السطر ***
      totalSales: double.parse(json['total_sales'].toString()),
    );
  }
}
