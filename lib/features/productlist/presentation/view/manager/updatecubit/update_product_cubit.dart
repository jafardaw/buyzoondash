// lib/features/productlist/presentation/view/manager/update_cubit/update_product_cubit.dart

import 'dart:typed_data';
import 'package:buyzoonapp/features/productlist/presentation/view/manager/updatecubit/update_product_state.dart';
import 'package:buyzoonapp/features/productlist/repo/product_list_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateProductCubit extends Cubit<UpdateProductState> {
  final AddProductRepository _addProductRepository;

  UpdateProductCubit(this._addProductRepository)
    : super(UpdateProductInitial());

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
    emit(UpdateProductLoading());
    try {
      await _addProductRepository.updateProduct(
        productId: productId,
        name: name,
        description: description,
        price: price,
        rating: rating,
        refundRate: refundRate,
        photosToDelete: photosToDelete,
        newPhotos: newPhotos,
      );
      emit(UpdateProductSuccess());
    } catch (error) {
      emit(UpdateProductFailure(errorMessage: error.toString()));
    }
  }
}
