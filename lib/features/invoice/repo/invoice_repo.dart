import 'package:buyzoonapp/core/error/eror_handel.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/features/invoice/data/model/invoice_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class InvoiceRepo {
  final ApiService _apiService;

  InvoiceRepo(this._apiService);

  Future<InvoiceModel> getInvoice({required int orderId}) async {
    try {
      final response = await _apiService.get('api/orders/$orderId/invoice');
      final data = response.data;
      if (data['status'] == true && data['data'] != null) {
        return InvoiceModel.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? 'فشل في جلب الفاتورة.');
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
