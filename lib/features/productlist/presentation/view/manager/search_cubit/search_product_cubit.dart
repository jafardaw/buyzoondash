import 'package:buyzoonapp/features/productlist/presentation/view/manager/search_cubit/search_product_state.dart';
import 'package:buyzoonapp/features/productlist/repo/product_list_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductSearchCubit extends Cubit<ProductSearchState> {
  final AddProductRepository repository;

  ProductSearchCubit({required this.repository})
    : super(ProductSearchInitial());

  Future<void> searchRawMaterials({
    required int idype,
    String? name,
    String? description,
    String? status,
    double? minPrice,
    double? maxPrice,
    double? minrating,
  }) async {
    emit(ProductSearchLoading());

    try {
      final results = await repository.searchRawMaterials(
        idype: idype,
        name: name,
        description: description,
        status: status,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minrating: minrating,
      );
      emit(RawMaterialSearchSuccess(results));
    } catch (e) {
      emit(RawMaterialSearchError(e.toString()));
    }
  }
}
