// lib/features/location/Governorates/data/model/city_model.dart

import 'region_model.dart';

class CityModel {
  final int id;
  final String name;
  final int governorateId;
  final String price;
  final List<RegionModel> regions;

  CityModel({
    required this.id,
    required this.name,
    required this.governorateId,
    required this.price,
    required this.regions,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    final regionsList = json['regions'] as List?;

    return CityModel(
      id: json['id'] as int,
      name: json['name'] as String,
      governorateId: json['governorate_id'] as int,
      price: json['price'] as String,
      regions: regionsList != null
          ? regionsList.map((e) => RegionModel.fromJson(e)).toList()
          : [],
    );
  }
}
