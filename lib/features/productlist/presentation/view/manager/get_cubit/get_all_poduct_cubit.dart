import 'package:buyzoonapp/features/productlist/presentation/view/manager/get_cubit/get_all_poduct_state.dart';
import 'package:buyzoonapp/features/productlist/repo/product_list_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final AddProductRepository _productsRepository;

  ProductsCubit(this._productsRepository) : super(ProductsInitial());

  Future<void> getAllProducts(int id) async {
    emit(ProductsLoading());
    try {
      final products = await _productsRepository.getAllProducts(id);
      emit(ProductsSuccess(products: products));
    } catch (e) {
      emit(ProductsFailure(errorMessage: e.toString()));
    }
  }
}
