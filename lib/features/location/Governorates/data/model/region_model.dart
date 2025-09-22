class RegionModel {
  final int id;
  final String name;
  final int cityId;
  final String price;

  RegionModel({
    required this.id,
    required this.name,
    required this.cityId,
    required this.price,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: json['id'] as int,
      name: json['name'] as String,
      cityId: json['city_id'] as int,
      price: json['price'] as String,
    );
  }
}
