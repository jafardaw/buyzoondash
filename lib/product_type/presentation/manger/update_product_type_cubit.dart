import 'package:buyzoonapp/product_type/repo/product_type_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'update_product_type_state.dart';

class UpdateProductTypeCubit extends Cubit<UpdateProductTypeState> {
  final ProductTypeRepo _productTypeRepo;

  UpdateProductTypeCubit(this._productTypeRepo)
    : super(UpdateProductTypeInitial());

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
}
