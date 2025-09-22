// lib/features/users/data/model/user_model.dart

class UserReprotModel {
  final int id;
  final String? username;
  final String? phoneNumber;
  final bool? isActive;
  final bool? isStaff;
  final bool? isSuperuser;
  final String? fcmToken;

  UserReprotModel({
    required this.id,
    this.username,
    this.phoneNumber,
    this.isActive,
    this.isStaff,
    this.isSuperuser,
    this.fcmToken,
  });

  factory UserReprotModel.fromJson(Map<String, dynamic> json) {
    return UserReprotModel(
      id: json['id'] as int,
      username: json['username'] as String?,
      phoneNumber: json['phone_number'] as String?,
      isActive: json['is_active'] != null ? (json['is_active'] == 1) : null,
      isStaff: json['is_staff'] as bool?,
      isSuperuser: json['is_superuser'] != null
          ? (json['is_superuser'] == 1)
          : null,
      fcmToken: json['fcm_token'] as String?,
    );
  }
}
