import 'package:buyzoonapp/product_type/repo/product_type_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/product_type_model.dart';

part 'product_type_state.dart';

class GetProductTypeCubit extends Cubit<GetProductTypeState> {
  final ProductTypeRepo _productTypeRepo;

  GetProductTypeCubit(this._productTypeRepo) : super(GetProductTypeInitial());

  Future<void> getProductTypes() async {
    emit(GetProductTypeLoading());
    try {
      final productTypes = await _productTypeRepo.getProductTypes();
      emit(GetProductTypeSuccess(productTypes));
    } catch (e) {
      emit(GetProductTypeFailure(e.toString()));
    }
  }
}
