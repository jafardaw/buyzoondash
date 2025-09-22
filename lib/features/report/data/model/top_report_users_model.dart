// lib/features/financial_report/data/model/top_users_model.dart

import 'package:buyzoonapp/features/users/data/model/user_model.dart';

class TopReportUsersModel {
  final UserModel user;
  final int ordersCount;
  final double totalSpent;

  TopReportUsersModel({
    required this.user,
    required this.ordersCount,
    required this.totalSpent,
  });

  factory TopReportUsersModel.fromJson(Map<String, dynamic> json) {
    return TopReportUsersModel(
      user: UserModel.fromJson(json['user']),
      ordersCount: json['orders_count'] as int,
      // *** تم تصحيح هذا السطر ***
      totalSpent: double.parse(json['total_spent'].toString()),
    );
  }
}
