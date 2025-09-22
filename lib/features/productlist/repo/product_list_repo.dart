// lib/features/add_product/repository/add_product_repository.dart

import 'package:buyzoonapp/core/error/eror_handel.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/features/productlist/data/product_list_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AddProductRepository {
  final ApiService apiService;

  AddProductRepository(this.apiService);

  Future<List<ProductModel>> getAllProducts(int id) async {
    try {
      final response = await apiService.get('api/products/?product_type=$id');

      print('mmmmmmmmmmmmmmmmmmmmmmmmmmmm$response');
      final List<dynamic> productsData = response.data['data'];
      return productsData.map((json) => ProductModel.fromJson(json)).toList();
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

  Future<void> addProduct({
    required String name,
    required String description,
    required double price,
    required double rating,
    required int productTypeId,
    required double refundRate,
    required List<Uint8List> imagesBytes,
  }) async {
    try {
      List<MultipartFile> imageFiles = [];
      for (int i = 0; i < imagesBytes.length; i++) {
        imageFiles.add(
          MultipartFile.fromBytes(imagesBytes[i], filename: 'image_$i.jpg'),
        );
      }

      final formData = FormData.fromMap({
        'name': name,
        'description': description,
        'price': price,
        'rating': rating,
        'product_type_id': productTypeId,
        'refund_rate': refundRate,
        'photos[]': imageFiles,
      });

      await apiService.post('api/products', formData);
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioException caught during addProduct: ${e.message}');
      }
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      if (kDebugMode) {
        print('General Exception caught during addProduct: $e');
      }
      rethrow;
    }
  }

  Future<void> updateProduct({
    required int productId,
    required String name,
    required String description,
    required double price,
    required double rating,
    required double refundRate,
    List<int>? photosToDelete,
    List<Uint8List>? newPhotos,
  }) async {
    try {
      Map<String, dynamic> data = {
        '_method': 'PUT',
        'name': name,
        'description': description,
        'price': price,
        'rating': rating,
        'refund_rate': refundRate,
      };

      // إضافة الصور التي سيتم حذفها كقائمة
      if (photosToDelete != null && photosToDelete.isNotEmpty) {
        data['remove_photos[]'] = photosToDelete;
      }

      // إضافة الصور الجديدة
      if (newPhotos != null && newPhotos.isNotEmpty) {
        List<MultipartFile> imageFiles = [];
        for (int i = 0; i < newPhotos.length; i++) {
          imageFiles.add(
            MultipartFile.fromBytes(newPhotos[i], filename: 'image_$i.jpg'),
          );
        }
        data['photos[]'] = imageFiles;
      }

      final formData = FormData.fromMap(data);

      await apiService.post('api/products/$productId', formData);
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

  Future<List<ProductModel>> searchRawMaterials({
    required int idype,
    String? name,
    String? description,
    String? status,
    double? minPrice,
    double? maxPrice,
    double? minrating,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (name != null && name.isNotEmpty) queryParameters['search'] = name;
    if (description != null && description.isNotEmpty) {
      queryParameters['description'] = description;
    }
    if (status != null && status.isNotEmpty) queryParameters['status'] = status;
    if (minPrice != null) queryParameters['min_price'] = minPrice;
    if (maxPrice != null) queryParameters['max_price'] = maxPrice;
    if (minrating != null) {
      queryParameters['min_rating'] = minrating;
    }

    final response = await apiService.get(
      'api/products/?product_type=$idype',
      queryParameters: queryParameters,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search raw materials: ${response.statusCode}');
    }
  }
}
