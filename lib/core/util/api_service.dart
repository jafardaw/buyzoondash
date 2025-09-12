import 'package:buyzoonapp/core/error/eror_handel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio;

  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: 'https://backendbuyzoon.fawruneg.com/public/',
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            // 'Access-Control-Allow-Origin': '*',
            // 'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            // 'Access-Control-Allow-Headers':
            //     'Origin, Content-Type, X-Auth-Token, Authorization',
          },
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      ) {
    // إضافة CORS headers لكل الطلبات
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // إضافة headers الـ CORS
          options.headers['Access-Control-Allow-Origin'] = '*';
          options.headers['Access-Control-Allow-Methods'] =
              'GET, POST, PUT, DELETE, OPTIONS';
          options.headers['Access-Control-Allow-Headers'] =
              'Origin, Content-Type, X-Auth-Token, Authorization';

          // إضافة token إذا موجود
          try {
            final prefs = await SharedPreferences.getInstance();
            final token = prefs.getString('token');
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          } catch (e) {
            if (kDebugMode) {
              print('Error getting token: $e');
            }
          }

          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            try {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
            } catch (e) {
              if (kDebugMode) {
                print('Error removing token: $e');
              }
            }
          }
          return handler.next(error);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
    }
  }

  Future<Response> post(String path, dynamic data) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  Future<Response> postwithOutData(String path) async {
    try {
      return await _dio.post(path);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  Future<Response> get(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, data: data, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.delete(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  Future<Response> update(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.put(path, data: data, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }
}
