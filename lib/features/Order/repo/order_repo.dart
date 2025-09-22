// lib/features/orders/data/repos/orders_repository.dart

import 'package:buyzoonapp/core/error/eror_handel.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/features/Order/data/order_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

// class OrdersRepository {
//   final ApiService apiService;

//   OrdersRepository(this.apiService);
//   Future<Map<String, dynamic>> getOrders({required int page}) async {
//     try {
//       final response = await apiService.get(
//         'api/orders',
//         queryParameters: {'page': page},
//       );

//       final List<dynamic> ordersData = response.data['data']['data'];
//       final int lastPage = response.data['data']['last_page'];

//       return {
//         "orders": ordersData.map((json) => OrderModel.fromJson(json)).toList(),
//         "lastPage": lastPage,
//       };
//     } on DioException catch (e) {
//       throw ErrorHandler.handleDioError(e);
//     }
//   }
// }

class OrdersRepository {
  final ApiService apiService;

  OrdersRepository(this.apiService);

  Future<Map<String, dynamic>> getOrders({
    required int page,
    // 🛠️ إضافة معاملات الفلتر
    String? status,
    String? paymentStatus,
    String? shippingStatus,
    String? region,
    String? city,
    String? governorate,
  }) async {
    try {
      final queryParameters = <String, dynamic>{'page': page};

      // 🛠️ إضافة الفلاتر إذا كانت موجودة
      if (status != null && status.isNotEmpty)
        queryParameters['status'] = status;
      if (paymentStatus != null && paymentStatus.isNotEmpty)
        queryParameters['payment_status'] = paymentStatus;
      if (shippingStatus != null && shippingStatus.isNotEmpty)
        queryParameters['shipping_status'] = shippingStatus;
      if (region != null && region.isNotEmpty)
        queryParameters['region'] = region;
      if (city != null && city.isNotEmpty) queryParameters['city'] = city;
      if (governorate != null && governorate.isNotEmpty)
        queryParameters['governorate'] = governorate;

      final response = await apiService.get(
        'api/orders',
        queryParameters: queryParameters,
      );

      final List<dynamic> ordersData = response.data['data']['data'];
      final int lastPage = response.data['data']['last_page'];

      return {
        "orders": ordersData.map((json) => OrderModel.fromJson(json)).toList(),
        "lastPage": lastPage,
      };
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  Future<void> updateOrderStatus({
    required int orderId,
    required Map<String, dynamic> body,
  }) async {
    try {
      await apiService.update('api/orders/$orderId/update-status', data: body);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }
}
