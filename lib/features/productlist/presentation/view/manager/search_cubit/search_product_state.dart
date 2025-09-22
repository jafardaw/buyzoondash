import 'package:buyzoonapp/features/productlist/data/product_list_model.dart';

abstract class ProductSearchState {}

class ProductSearchInitial extends ProductSearchState {}

class ProductSearchLoading extends ProductSearchState {}

class RawMaterialSearchSuccess extends ProductSearchState {
  final List<ProductModel> results;

  RawMaterialSearchSuccess(this.results);
}

class RawMaterialSearchError extends ProductSearchState {
  final String message;

  RawMaterialSearchError(this.message);
}
