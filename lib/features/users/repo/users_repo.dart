import 'package:buyzoonapp/core/error/eror_handel.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/features/users/data/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

// كلاس جديد لحمل استجابة Pagination
class PaginatedUsersResponse {
  final List<UserModel> users;
  final bool hasMore; // لتحديد ما إذا كانت هناك صفحات إضافية

  PaginatedUsersResponse({required this.users, required this.hasMore});
}

class UsersRepo {
  final ApiService _apiService;

  UsersRepo(this._apiService);

  // تحديث الدالة لتستقبل رقم الصفحة وتعيد PaginatedUsersResponse
  Future<PaginatedUsersResponse> getUsers({int page = 1}) async {
    try {
      final response = await _apiService.get(
        'api/users',
        queryParameters: {'page': page},
      );
      final data = response.data['data'];

      if (response.data['status'] == true) {
        final List<dynamic> usersData = data['data'];
        final users = usersData
            .map((json) => UserModel.fromJson(json))
            .toList();
        final hasMore = data['next_page_url'] != null;

        return PaginatedUsersResponse(users: users, hasMore: hasMore);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to get users.');
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

  Future<UserModel> getUserDetails({required int userId}) async {
    try {
      final response = await _apiService.get('api/users/$userId');
      final data = response.data;

      if (data['status'] == true) {
        final userData = data['data'];
        return UserModel.fromJson(userData);
      } else {
        throw Exception(data['message'] ?? 'Failed to get user details.');
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

  Future<String> deleteUser({required int userId}) async {
    try {
      final response = await _apiService.delete('api/users/$userId');
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
