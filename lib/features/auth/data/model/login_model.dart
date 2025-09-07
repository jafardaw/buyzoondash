class LoginModel {
  final String token;
  final int userId;
  final String username;
  final String phoneNumber;
  final bool isSuperuser;
  final bool isStaff;
  final bool isActive;

  LoginModel({
    required this.token,
    required this.userId,
    required this.username,
    required this.phoneNumber,
    required this.isSuperuser,
    required this.isStaff,
    required this.isActive,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      token: json['token'] ?? '',
      userId: json['user_id'] ?? 0,
      username: json['username'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      isSuperuser: (json['is_superuser'] ?? 0) == 1,
      isStaff: (json['is_staff'] ?? 0) == 1,
      isActive: (json['is_active'] ?? 0) == 1,
    );
  }
}
