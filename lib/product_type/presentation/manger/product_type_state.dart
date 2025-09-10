part of 'product_type_cubit.dart';

abstract class ProductTypeState {}

class AddProductTypeInitial extends ProductTypeState {}

class AddProductTypeLoading extends ProductTypeState {}

class AddProductTypeSuccess extends ProductTypeState {
  // final List<ProductTypeModel> productTypes;
  final String message;
  AddProductTypeSuccess(this.message);
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

class UpdateProductTypeLoading extends ProductTypeState {}

class UpdateProductTypeSuccess extends ProductTypeState {
  final String message;
  UpdateProductTypeSuccess(this.message);
}

class UpdateProductTypeFailure extends ProductTypeState {
  final String error;
  UpdateProductTypeFailure(this.error);
}

class DeleteProductTypeLoading extends ProductTypeState {}

class DeleteProductTypeSuccess extends ProductTypeState {
  final String message;
  DeleteProductTypeSuccess(this.message);
}

class DeleteProductTypeFailure extends ProductTypeState {
  final String error;
  DeleteProductTypeFailure(this.error);
}
