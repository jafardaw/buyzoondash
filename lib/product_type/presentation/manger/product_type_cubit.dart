import 'package:buyzoonapp/product_type/repo/product_type_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/product_type_model.dart';

part 'product_type_state.dart';

// class GetProductTypeCubit extends Cubit<GetProductTypeState> {
//   final ProductTypeRepo _productTypeRepo;

//   GetProductTypeCubit(this._productTypeRepo) : super(GetProductTypeInitial());

//   Future<void> getProductTypes() async {
//     emit(GetProductTypeLoading());
//     try {
//       final productTypes = await _productTypeRepo.getProductTypes();
//       emit(GetProductTypeSuccess(productTypes));
//     } catch (e) {
//       emit(GetProductTypeFailure(e.toString()));
//     }
//   }
// }
// lib/product_type/presentation/manger/product_type_cubit.dart

class GetProductTypeCubit extends Cubit<GetProductTypeState> {
  final ProductTypeRepo _productTypeRepo;
  List<ProductTypeModel> _allProductTypes = [];

  GetProductTypeCubit(this._productTypeRepo) : super(GetProductTypeInitial());

  Future<void> getProductTypes() async {
    emit(GetProductTypeLoading());
    try {
      _allProductTypes = await _productTypeRepo.getProductTypes();
      if (!isClosed) {
        emit(GetProductTypeSuccess(_allProductTypes));
      }
    } catch (e) {
      if (!isClosed) {
        emit(GetProductTypeFailure(e.toString()));
      }
    }
  }

  void searchProductTypes(String query) {
    if (state is GetProductTypeSuccess) {
      if (query.isEmpty) {
        if (!isClosed) {
          emit(GetProductTypeSuccess(_allProductTypes));
        }
      } else {
        final filteredList = _allProductTypes.where((productType) {
          return productType.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
        if (!isClosed) {
          emit(GetProductTypeSuccess(filteredList));
        }
      }
    }
  }
}
