// import 'package:buyzoon/core/error/eror_handel.dart';
// import 'package:buyzoon/core/util/api_service.dart';
// import 'package:buyzoon/features/auth/data/model/login_model.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginRepo {
//   final ApiService _apiService;

//   LoginRepo(this._apiService);

//   Future<LoginModel> login({
//     required String usernameOrPhone,
//     required String password,
//   }) async {
//     try {
//       final response = await _apiService.post('/api/auth/login/', {
//         "username_or_phone": usernameOrPhone,
//         "password": password,
//       });

//       final data = response.data;

//       if (data['status'] == true) {
//         if (data['data']['token'] != null) {
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString('token', data['data']['token']);
//         }
//         return LoginModel.fromJson(response.data['data']);
//       } else {
//         throw Exception(data['message'] ?? 'Failed to log in.');
//       }
//     } on DioException catch (e) {
//       if (kDebugMode) {
//         print(e.message);
//       }
//       // نرمي الخطأ كـ Exception مع الرسالة من ErrorHandler
//       throw Exception(ErrorHandler.handleDioError(e));
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//       throw Exception('An unexpected error occurred.');
//     }
//   }
// }

// في ملف login_repo.dart
// ...

import 'package:buyzoonapp/core/error/eror_handel.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/features/auth/data/model/login_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ...

class LoginRepo {
  final ApiService _apiService;

  LoginRepo(this._apiService);

  Future<LoginModel> login({
    required String usernameOrPhone,
    required String password,
  }) async {
    try {
      final response = await _apiService.post('api/admin/login', {
        "username_or_phone": usernameOrPhone,
        "password": password,
      });

      final data = response.data;

      // تحقق من حالة الرد قبل التعامل مع البيانات
      if (data['status'] == true) {
        if (data['data']['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['data']['token']);
        }
        return LoginModel.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? 'Failed to log in.');
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
      rethrow; // إلقاء الخطأ مرة أخرى ليتم التعامل معه في Cubit
    }
  }
}
