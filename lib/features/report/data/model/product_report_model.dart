// lib/features/financial_report/data/model/product_model.dart

class ProductReportModel {
  final int id;
  final String name;
  final String? description;
  final String price;
  final String? rating;
  final bool? ban;
  final String? profitRatio;

  ProductReportModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.rating,
    this.ban,
    this.profitRatio,
  });

  factory ProductReportModel.fromJson(Map<String, dynamic> json) {
    return ProductReportModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: json['price'] as String,
      rating: json['rating'] as String?,
      ban: json['ban'] as bool?,
      profitRatio: json['profit_ratio'] as String?,
    );
  }
}
