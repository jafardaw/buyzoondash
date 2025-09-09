// lib/features/product_types/data/models/product_type_model.dart

class ProductTypeModel {
  final int id;
  final String name;

  ProductTypeModel({required this.id, required this.name});

  factory ProductTypeModel.fromJson(Map<String, dynamic> json) {
    return ProductTypeModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
