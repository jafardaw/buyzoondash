// lib/features/product_types/data/repo/product_type_repo.dart

import 'package:buyzoonapp/core/error/eror_handel.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/product_type/data/model/product_type_model.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ProductTypeRepo {
  final ApiService _apiService;

  ProductTypeRepo(this._apiService);

  Future<String> addProductType({required String name}) async {
    try {
      final response = await _apiService.post('api/product-types', {
        "name": name,
      });
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

  Future<List<ProductTypeModel>> getProductTypes() async {
    try {
      final response = await _apiService.get('/api/product-types');
      final data = response.data;

      if (data['status'] == true) {
        final List<dynamic> productTypesData = data['data'];
        return productTypesData
            .map((json) => ProductTypeModel.fromJson(json))
            .toList();
      } else {
        throw Exception(data['message'] ?? 'Failed to get product types.');
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

  Future<String> updateProductType({
    required int id,
    required String name,
  }) async {
    try {
      final response = await _apiService.update(
        'api/product-types/$id',
        data: {"name": name},
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

  Future<String> deleteProductType({required int id}) async {
    try {
      final response = await _apiService.delete('api/product-types/$id');
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
