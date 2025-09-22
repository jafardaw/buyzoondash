import 'package:buyzoonapp/core/error/eror_handel.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/features/ban_users/data/model/ban_user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class BannedUsersRepo {
  final ApiService _apiService;

  BannedUsersRepo(this._apiService);

  Future<List<UserBanModel>> getBannedUsers() async {
    try {
      final response = await _apiService.get('api/get/allbanned');
      final data = response.data;
      if (data['status'] == true) {
        return (data['data'] as List)
            .map((e) => UserBanModel.fromJson(e))
            .toList();
      } else {
        throw Exception(data['message'] ?? 'فشل في جلب المستخدمين المحظورين.');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioException caught: ${e.message}');
      }
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      if (kDebugMode) {
        print('General Exception caught: $e');
      }
      rethrow;
    }
  }
}
