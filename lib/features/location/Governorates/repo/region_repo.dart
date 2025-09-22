import 'package:buyzoonapp/core/error/eror_handel.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/features/location/Governorates/data/model/city_model.dart';
import 'package:dio/dio.dart';

class RegionRepo {
  final ApiService _apiService;

  RegionRepo(this._apiService);

  Future<String> createRegion({
    required String name,
    required int cityId,
    required double price,
  }) async {
    try {
      final response = await _apiService.post('api/regions', {
        "name": name,
        "city_id": cityId,
        "price": price,
      });
      final data = response.data;
      if (data['status'] == true) {
        return data['message'] ?? 'تم إضافة المنطقة بنجاح.';
      } else {
        throw Exception(data['message'] ?? 'فشل في إضافة المنطقة.');
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<CityModel> getCityById(int id) async {
    try {
      final response = await _apiService.get('api/cities/$id');
      final data = response.data;
      if (data['status'] == true && data['data'] != null) {
        return CityModel.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? 'لم يتم العثور على المدينة.');
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateRegion({
    required int regionId,
    required String name,
    required int cityId,
    required double price,
  }) async {
    try {
      final response = await _apiService.update(
        'api/regions/$regionId',
        data: {"name": name, "city_id": cityId, "price": price},
      );
      final data = response.data;
      if (data['status'] == true) {
        return data['message'] ?? 'تم تعديل المنطقة بنجاح.';
      } else {
        throw Exception(data['message'] ?? 'فشل في تعديل المنطقة.');
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  // دالة جديدة لحذف منطقة
  Future<String> deleteRegion({required int regionId}) async {
    try {
      final response = await _apiService.delete('api/regions/$regionId');
      final data = response.data;
      if (data['status'] == true) {
        return data['message'] ?? 'تم حذف المنطقة بنجاح.';
      } else {
        throw Exception(data['message'] ?? 'فشل في حذف المنطقة.');
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }
}
