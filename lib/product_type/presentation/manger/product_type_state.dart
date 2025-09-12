part of 'product_type_cubit.dart';

abstract class GetProductTypeState {}

class GetProductTypeInitial extends GetProductTypeState {}

class GetProductTypeLoading extends GetProductTypeState {}

class GetProductTypeSuccess extends GetProductTypeState {
  final List<ProductTypeModel> productTypes;
  GetProductTypeSuccess(this.productTypes);
}

class GetProductTypeFailure extends GetProductTypeState {
  final String error;
  GetProductTypeFailure(this.error);
}
