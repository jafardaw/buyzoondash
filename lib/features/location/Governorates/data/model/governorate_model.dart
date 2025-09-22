// lib/features/location/Governorates/data/model/governorate_model.dart

import 'city_model.dart';

class GovernorateModel {
  final int id;
  final String name;
  final String price;
  final List<CityModel> cities;

  GovernorateModel({
    required this.id,
    required this.name,
    required this.price,
    required this.cities,
  });

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    // التأكد من أن 'cities' ليست null
    final citiesList = json['cities'] as List?;

    return GovernorateModel(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as String,
      // إذا كانت القيمة null، نستخدم قائمة فارغة
      cities: citiesList != null
          ? citiesList.map((e) => CityModel.fromJson(e)).toList()
          : [],
    );
  }
}
