import 'dart:typed_data';

import 'package:buyzoonapp/features/productlist/presentation/view/manager/add_new_product_state.dart';
import 'package:buyzoonapp/features/productlist/repo/product_list_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductCubit extends Cubit<AddProductState> {
  final AddProductRepository _addProductRepository;

  AddProductCubit(this._addProductRepository) : super(AddProductInitial());

  Future<void> addNewProduct({
    required String name,
    required String description,
    required double price,
    required double rating,
    required int productTypeId,
    required double refundRate,
    required List<Uint8List> imagesBytes,
  }) async {
    emit(AddProductLoading());
    try {
      await _addProductRepository.addProduct(
        name: name,
        description: description,
        price: price,
        rating: rating,
        productTypeId: productTypeId,
        refundRate: refundRate,
        imagesBytes: imagesBytes,
      );
      emit(AddProductSuccess());
    }
    // on DioException catch (e) {
    //   String errorMessage = ErrorHandler.handleDioError(e);
    //   emit(AddProductFailure(errorMessage: errorMessage));
    // }
    catch (error) {
      emit(
        AddProductFailure(
          errorMessage: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
