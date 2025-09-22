import 'package:buyzoonapp/core/error/eror_handel.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/features/report/data/model/financial_report_report_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class FinancialRepo {
  final ApiService _apiService;

  FinancialRepo(this._apiService);

  Future<FinancialReportModel> getFinancialReport({
    required String timeline,
    required String from,
    required String to,
  }) async {
    try {
      final response = await _apiService.get(
        'api/financial_report?timeline=$timeline&from=$from&to=$to',
      );
      final data = response.data;
      if (data['status'] == true && data['data'] != null) {
        return FinancialReportModel.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? 'فشل في جلب التقرير المالي.');
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
