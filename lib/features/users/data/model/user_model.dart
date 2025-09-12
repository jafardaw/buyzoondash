// class UserModel {
//   final int id;
//   final String username;
//   final String phoneNumber;
//   final bool isActive;
//   final bool isStaff;

//   UserModel({
//     required this.id,
//     required this.username,
//     required this.phoneNumber,
//     required this.isActive,
//     required this.isStaff,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['id'] as int,
//       username: json['username'] as String,
//       phoneNumber: json['phone_number'] as String,
//       isActive: json['is_active'] == 1,
//       isStaff: json['is_staff'] as bool,
//     );
//   }
// }

// lib/features/users/data/model/user_model.dart

import 'package:intl/intl.dart';

class UserModel {
  final int id;
  final String username;
  final String phoneNumber;
  final bool isActive;
  final bool isStaff;
  final bool isSuperuser;
  final DateTime? lastLogin;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.phoneNumber,
    required this.isActive,
    required this.isStaff,
    required this.isSuperuser,
    this.lastLogin,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      phoneNumber: json['phone_number'] as String,
      isActive: json['is_active'] == 1,
      isStaff: json['is_staff'] as bool,
      isSuperuser: json['is_superuser'] == 1,
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // Helper method to format dates
  String get formattedCreatedAt {
    return DateFormat('yyyy-MM-dd HH:mm').format(createdAt.toLocal());
  }

  String get formattedLastLogin {
    return lastLogin != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(lastLogin!.toLocal())
        : 'لم يتم تسجيل الدخول';
  }
}
