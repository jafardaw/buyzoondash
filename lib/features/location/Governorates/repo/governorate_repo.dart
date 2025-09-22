// lib/features/governorates/repo/governorate_repo.dart

import 'package:buyzoonapp/core/error/eror_handel.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/features/location/Governorates/data/model/governorates_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class GovernorateRepo {
  final ApiService _apiService;

  GovernorateRepo(this._apiService);

  Future<String> addGovernorate({
    required String name,
    required double price,
  }) async {
    try {
      final response = await _apiService.post('api/governorates', {
        "name": name,
        "price": price,
      });
      return response.data['message'] ?? 'تم اضافة المحافظة بنجاح.';
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

  Future<String> updateGovernorate({
    required int id,
    required String name,
    required double price,
  }) async {
    try {
      final response = await _apiService.update(
        'api/governorates/$id',
        data: {"name": name, "price": price},
      );

      final data = response.data;

      return data['message'] ?? 'تم تعديل  المحافظة بنجاح.';
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

  Future<String> deleteGovernorate({required int id}) async {
    try {
      final response = await _apiService.delete('api/governorates/$id');

      final data = response.data;

      if (response.statusCode == 200 || response.statusCode == 204) {
        return data['message'] ?? 'تم حذف المحافظة بنجاح.';
      } else {
        throw Exception(data['message'] ?? 'فشل في حذف المحافظة.');
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

  Future<GovernoratesResponseModel> getGovernorates({int page = 1}) async {
    try {
      final response = await _apiService.get('api/governorates?page=$page');
      final data = response.data;
      if (data['status'] == true) {
        return GovernoratesResponseModel.fromJson(data);
      } else {
        throw Exception(data['message'] ?? 'Failed to retrieve governorates.');
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
