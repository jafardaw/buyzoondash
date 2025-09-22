import 'package:buyzoonapp/core/error/eror_handel.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/features/ban_users/data/model/ban_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class BanRepo {
  final ApiService _apiService;

  BanRepo(this._apiService);

  Future<BanResponseModel> banUser({
    required int userId,
    required String reason,
    required int days,
  }) async {
    try {
      final response = await _apiService.post('api/ban', {
        "user_id": userId,
        "reason": reason,
        "days": days,
      });

      final data = response.data;
      if (data['status'] == true) {
        return BanResponseModel.fromJson(data);
      } else {
        throw Exception(data['message'] ?? 'فشل في حظر المستخدم.');
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

  Future<BanResponseModel> unbanUser({required int userId}) async {
    try {
      final response = await _apiService.update(
        'api/users/$userId/unban',
        data: {},
      );

      final data = response.data;
      if (data['status'] == true) {
        return BanResponseModel.fromJson(data);
      } else {
        throw Exception(data['message'] ?? 'فشل في فك حظر المستخدم.');
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

  Future<BanResponseModel> updateBan({
    required int userId,
    required String reason,
    required int days,
  }) async {
    try {
      final response = await _apiService.update(
        'api/update/bans/$userId',
        data: {"user_id": userId, "reason": reason, "days": days},
      );

      final data = response.data;
      if (data['status'] == true) {
        return BanResponseModel.fromJson(data);
      } else {
        throw Exception(data['message'] ?? 'فشل في تعديل الحظر.');
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
