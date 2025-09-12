import 'package:buyzoonapp/product_type/repo/product_type_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_product_type_state.dart';

class AddProductTypeCubit extends Cubit<AddProductTypeState> {
  final ProductTypeRepo _productTypeRepo;

  AddProductTypeCubit(this._productTypeRepo) : super(AddProductTypeInitial());

  Future<void> addProductType({required String name}) async {
    emit(AddProductTypeLoading());
    try {
      final message = await _productTypeRepo.addProductType(name: name);
      emit(AddProductTypeSuccess(message));
    } catch (e) {
      emit(AddProductTypeFailure(e.toString()));
    }
  }
}
