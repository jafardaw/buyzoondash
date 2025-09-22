// lib/features/shipping/data/repos/shipping_repository.dart
import 'package:buyzoonapp/core/error/eror_handel.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/features/shipping/data/shipping_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ShippingRepository {
  final ApiService apiService;

  ShippingRepository(this.apiService);

  Future<ShippingModel> getShippingDetails(int id) async {
    try {
      final response = await apiService.get('api/shippings/$id');
      if (kDebugMode) {
        print('Shipping API Response: ${response.data}');
      }
      return ShippingModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioException caught in ShippingRepository: ${e.message}');
      }
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      if (kDebugMode) {
        print('General Exception caught in ShippingRepository: $e');
      }
      rethrow;
    }
  }

  Future<void> updateShippingStatus({
    required int orderId,
    required Map<String, dynamic> body,
  }) async {
    try {
      await apiService.update(
        'api/shippings/$orderId/update-status',
        data: body,
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }
}
