// lib/features/shipping/data/models/shipping_model.dart
import 'package:buyzoonapp/features/Order/data/order_model.dart';

class ShippingModel {
  final int id;
  final String? trackingNumber;
  final String? status;
  final String? shippedAt;
  final String? deliveredAt;
  final String? createdAt;
  final OrderModel? order;
  final LocationModel? location;

  ShippingModel({
    required this.id,
    this.trackingNumber,
    this.status,
    this.shippedAt,
    this.deliveredAt,
    this.createdAt,
    this.order,
    this.location,
  });

  factory ShippingModel.fromJson(Map<String, dynamic> json) {
    return ShippingModel(
      id: json['id'] as int,
      trackingNumber: json['tracking_number'] as String?,
      status: json['status'] as String?,
      shippedAt: json['shipped_at'] as String?,
      deliveredAt: json['delivered_at'] as String?,
      createdAt: json['created_at'] as String?,
      order: json['order'] != null ? OrderModel.fromJson(json['order']) : null,
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
    );
  }
}

class LocationModel {
  final int id;
  final String? longitude;
  final String? latitude;
  final String? details;
  final String? price;
  final RegionModel? region;

  LocationModel({
    required this.id,
    this.longitude,
    this.latitude,
    this.details,
    this.price,
    this.region,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as int,
      longitude: json['longitude'] as String?,
      latitude: json['latitude'] as String?,
      details: json['details'] as String?,
      price: json['price'] as String?,
      region: json['region'] != null
          ? RegionModel.fromJson(json['region'])
          : null,
    );
  }
}

class RegionModel {
  final int id;
  final String? name;
  final String? price;

  RegionModel({required this.id, this.name, this.price});

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: json['id'] as int,
      name: json['name'] as String?,
      price: json['price'] as String?,
    );
  }
}
