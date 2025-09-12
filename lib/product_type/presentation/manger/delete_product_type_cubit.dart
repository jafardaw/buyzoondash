import 'package:buyzoonapp/product_type/repo/product_type_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'delete_product_type_state.dart';

class DeleteProductTypeCubit extends Cubit<DeleteProductTypeState> {
  final ProductTypeRepo _productTypeRepo;

  DeleteProductTypeCubit(this._productTypeRepo)
    : super(DeleteProductTypeInitial());

  Future<void> deleteProductType({required int id}) async {
    emit(DeleteProductTypeLoading());
    try {
      final message = await _productTypeRepo.deleteProductType(id: id);
      emit(DeleteProductTypeSuccess(message));
    } catch (e) {
      emit(DeleteProductTypeFailure(e.toString()));
    }
  }
}
