import 'package:buyzoonapp/features/productlist/data/product_list_model.dart';

sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}

final class ProductsLoading extends ProductsState {}

final class ProductsSuccess extends ProductsState {
  final List<ProductModel> products;
  ProductsSuccess({required this.products});
}

final class ProductsFailure extends ProductsState {
  final String errorMessage;
  ProductsFailure({required this.errorMessage});
}
