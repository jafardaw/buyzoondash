// lib/features/products/data/models/product_model.dart

class ProductModel {
  final int id;
  final String name;
  final String description;
  final ProductType? productType;
  final int? productTypeId;
  final int? count;
  final bool? allowCashWallet;
  final double price;
  //  "original_price": "171.00",
  //         "profit_ratio": "0.07",
  //         "profit": 11.97,
  final double originalprice;
  final double profitratio;
  final double profit;

  final double rating;
  final bool? ban;
  final double refundRate;
  final String? createdAt;
  final String? updatedAt;
  final List<ProductPhoto>? productPhotos;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    this.productType,
    this.productTypeId,
    this.count,
    this.allowCashWallet,
    required this.price,
    required this.originalprice,
    required this.profitratio,
    required this.profit,
    required this.rating,
    this.ban,
    required this.refundRate,
    this.createdAt,
    this.updatedAt,
    this.productPhotos,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      productType: json['product_type'] != null
          ? ProductType.fromJson(json['product_type'])
          : null,
      productTypeId: json['product_type_id'] as int?,
      count: json['count'] as int?,
      allowCashWallet: json['allow_cash_wallet'] as bool?,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,

      originalprice:
          double.tryParse(json['original_price']?.toString() ?? '0') ?? 0.0,

      profitratio: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      profit: double.tryParse(json['profit']?.toString() ?? '0') ?? 0.0,

      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      ban: json['ban'] as bool?,
      refundRate:
          double.tryParse(json['refund_rate']?.toString() ?? '0') ?? 0.0,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      productPhotos: (json['product_photos'] as List?)
          ?.map((photoJson) => ProductPhoto.fromJson(photoJson))
          .toList(),
    );
  }
}

class ProductType {
  final int id;
  final String name;

  ProductType({required this.id, required this.name});

  factory ProductType.fromJson(Map<String, dynamic> json) {
    return ProductType(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}

class ProductPhoto {
  final int id;
  final int photoId;
  final String photoUrl;
  final bool isPrimary;
  final int order;

  ProductPhoto({
    required this.id,
    required this.photoId,
    required this.photoUrl,
    required this.isPrimary,
    required this.order,
  });

  factory ProductPhoto.fromJson(Map<String, dynamic> json) {
    return ProductPhoto(
      id: json['id'] as int? ?? 0,
      photoId: json['photo_id'] as int? ?? 0,
      photoUrl: json['photo_url'] as String? ?? '',
      isPrimary: json['is_primary'] as bool? ?? false,
      order: json['order'] as int? ?? 0,
    );
  }
}
