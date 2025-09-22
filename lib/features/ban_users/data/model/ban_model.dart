class BanResponseModel {
  final String message;
  final bool status;

  BanResponseModel({required this.message, required this.status});

  factory BanResponseModel.fromJson(Map<String, dynamic> json) {
    return BanResponseModel(
      message: json['message'] as String,
      status: json['status'] as bool,
    );
  }
}
