import 'package:buyzoonapp/core/error/eror_handel.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class BroadcastRepo {
  final ApiService _apiService;

  BroadcastRepo(this._apiService);

  Future<String> sendNotification({
    required String title,
    required String body,
  }) async {
    try {
      final response = await _apiService.post(
        'api/users/broadcast-notification',
        {"title": title, "body": body},
      );
      return response.data['message'];
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
