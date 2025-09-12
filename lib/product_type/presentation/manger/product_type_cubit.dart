// lib/features/product_types/logic/cubit/product_type_cubit.dart

import 'package:buyzoonapp/product_type/data/model/product_type_model.dart';
import 'package:buyzoonapp/product_type/repo/product_type_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_type_state.dart';

class ProductTypeCubit extends Cubit<ProductTypeState> {
  final ProductTypeRepo _productTypeRepo;

  ProductTypeCubit(this._productTypeRepo) : super(AddProductTypeInitial());

  Future<void> addProductType({required String name}) async {
    emit(AddProductTypeLoading());
    try {
      final productTypes = await _productTypeRepo.addProductType(name: name);
      emit(AddProductTypeSuccess(productTypes));
    } catch (e) {
      emit(AddProductTypeFailure(e.toString()));
    }
  }

  Future<void> getProductTypes() async {
    emit(ProductTypeLoading());
    try {
      final productTypes = await _productTypeRepo.getProductTypes();
      emit(ProductTypeSuccess(productTypes));
    } catch (e) {
      emit(ProductTypeFailure(e.toString()));
    }
  }

  Future<void> updateProductType({
    required int id,
    required String name,
  }) async {
    emit(UpdateProductTypeLoading());
    try {
      final message = await _productTypeRepo.updateProductType(
        id: id,
        name: name,
      );
      emit(UpdateProductTypeSuccess(message));
    } catch (e) {
      emit(UpdateProductTypeFailure(e.toString()));
    }
  }

  Future<void> deleteProductType({required int id}) async {
    emit(DeleteProductTypeLoading());
    try {
      final message = await _productTypeRepo.deleteProductType(id: id);
      emit(DeleteProductTypeSuccess(message));
      // يمكنك أيضاً استدعاء getProductTypes() هنا لتحديث القائمة بعد الحذف
      // await getProductTypes();
    } catch (e) {
      emit(DeleteProductTypeFailure(e.toString()));
    }
  }
}
