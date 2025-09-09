part of 'product_type_cubit.dart';

abstract class ProductTypeState {}

class AddProductTypeInitial extends ProductTypeState {}

class AddProductTypeLoading extends ProductTypeState {}

class AddProductTypeSuccess extends ProductTypeState {
  final List<ProductTypeModel> productTypes;
  AddProductTypeSuccess(this.productTypes);
}

class AddProductTypeFailure extends ProductTypeState {
  final String error;
  AddProductTypeFailure(this.error);
}

class ProductTypeLoading extends ProductTypeState {}

class ProductTypeSuccess extends ProductTypeState {
  final List<ProductTypeModel> productTypes;
  ProductTypeSuccess(this.productTypes);
}

class ProductTypeFailure extends ProductTypeState {
  final String error;
  ProductTypeFailure(this.error);
}
