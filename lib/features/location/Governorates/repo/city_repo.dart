import 'package:buyzoonapp/core/error/eror_handel.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/features/location/Governorates/data/model/governorate_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CityRepo {
  final ApiService _apiService;

  CityRepo(this._apiService);
  Future<String> createCity({
    required int governorateId,
    required String name,
    required double price,
  }) async {
    try {
      final response = await _apiService.post('api/cities', {
        "governorate_id": governorateId,
        "name": name,
        "price": price,
      });

      final data = response.data;
      if (data['status'] == true) {
        return data['message'] ?? 'تم إضافة المدينة بنجاح.';
      } else {
        throw Exception(data['message'] ?? 'فشل في إضافة المدينة.');
      }
    } on DioException catch (e) {
      // ... (error handling)
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      // ... (general error handling)
      rethrow;
    }
  }

  Future<GovernorateModel> getGovernorateById(int id) async {
    try {
      final response = await _apiService.get('api/governorates/$id');
      final data = response.data;
      if (data['status'] == true && data['data'] != null) {
        // إلى GovernorateModel.
        return GovernorateModel.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? 'لم يتم العثور على المحافظة.');
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

  Future<String> updateCity({
    required int cityId,
    required String name,
    required double price,
  }) async {
    try {
      final response = await _apiService.update(
        'api/cities/$cityId',
        data: {"name": name, "price": price},
      );
      final data = response.data;
      if (data['status'] == true) {
        return data['message'] ?? 'تم تعديل المدينة بنجاح.';
      } else {
        throw Exception(data['message'] ?? 'فشل في تعديل المدينة.');
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  // دالة لحذف مدينة
  Future<String> deleteCity({required int cityId}) async {
    try {
      final response = await _apiService.delete('api/cities/$cityId');

      final data = response.data;
      if (data['status'] == true) {
        return data['message'] ?? 'تم حذف المدينة بنجاح.';
      } else {
        throw Exception(data['message'] ?? 'فشل في حذف المدينة.');
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }
}
