// lib/features/users/data/model/ban_model.dart

class BanModel {
  final int id;
  final int userId;
  final int bannedBy;
  final String reason;
  final String startAt;
  final String endAt;
  final String createdAt;
  final String updatedAt;

  BanModel({
    required this.id,
    required this.userId,
    required this.bannedBy,
    required this.reason,
    required this.startAt,
    required this.endAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BanModel.fromJson(Map<String, dynamic> json) {
    return BanModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      bannedBy: json['banned_by'] as int,
      reason: json['reason'] as String,
      startAt: json['start_at'] as String,
      endAt: json['end_at'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}

class UserBanModel {
  final int id;
  final String username;
  final String phoneNumber;
  final bool isActive;
  final bool isStaff;
  final bool isSuperuser;
  final BanModel? activeBan; // إضافة حقل الحظر النشط

  UserBanModel({
    required this.id,
    required this.username,
    required this.phoneNumber,
    required this.isActive,
    required this.isStaff,
    required this.isSuperuser,
    this.activeBan,
  });

  factory UserBanModel.fromJson(Map<String, dynamic> json) {
    return UserBanModel(
      id: json['id'] as int,
      username: json['username'] as String,
      phoneNumber: json['phone_number'] as String,
      isActive: (json['is_active'] as int) == 1,
      isStaff: json['is_staff'] as bool,
      isSuperuser: (json['is_superuser'] as int) == 1,
      activeBan: json['active_ban'] != null
          ? BanModel.fromJson(json['active_ban'])
          : null,
    );
  }
}
