class OrderModel {
  final int id;
  final String? status;
  final String? paymentstatus;
  final double? totalPrice;
  final String? createdAt;
  final String? updatedAt;
  final UserModel? user;
  final List<ItemOrderModel>? itemOrders;

  OrderModel({
    required this.id,
    this.status,
    this.paymentstatus,

    this.totalPrice,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.itemOrders,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      status: json['status'] as String?,
      paymentstatus: json['payment_status'] as String?,
      totalPrice:
          double.tryParse(json['total_price']?.toString() ?? '0.0') ?? 0.0,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      itemOrders: (json['order_items'] as List?)
          ?.map((item) => ItemOrderModel.fromJson(item))
          .toList(),
    );
  }
}

class UserModel {
  final int id;
  final String? username;
  final String? phoneNumber;
  final String? fcmToken;
  final String? lastLogin;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    required this.id,
    this.username,
    this.phoneNumber,
    this.fcmToken,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String?,
      phoneNumber: json['phone_number'] as String?,
      fcmToken: json['fcm_token'] as String?,
      lastLogin: json['last_login'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}

// lib/features/orders/data/models/order_model.dart

//... (باقي الموديلات)

class ItemOrderModel {
  final int id;
  final int? quantity;
  final double? totalPrice; // ملاحظة: هذا الحقل موجود بالفعل في الرد
  final ProductModel? product; // تم إضافة موديل المنتج هنا

  ItemOrderModel({
    required this.id,
    this.quantity,
    this.totalPrice,
    this.product,
  });

  factory ItemOrderModel.fromJson(Map<String, dynamic> json) {
    return ItemOrderModel(
      id: json['id'] as int,
      quantity: json['quantity'] as int?,
      totalPrice:
          double.tryParse(json['total_price']?.toString() ?? '0.0') ?? 0.0,
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
    );
  }
}

// lib/features/orders/data/models/product_model.dart

class ProductModel {
  final int id;
  final String? name;
  final String? description;
  final double? price;
  final String? rating;
  final bool? ban;
  final String? refundRate;

  ProductModel({
    required this.id,
    this.name,
    this.description,
    this.price,
    this.rating,
    this.ban,
    this.refundRate,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: double.tryParse(json['price']?.toString() ?? '0.0'),
      rating: json['rating']?.toString(),
      ban: json['ban'] as bool?,
      refundRate: json['refund_rate']?.toString(),
    );
  }
}
