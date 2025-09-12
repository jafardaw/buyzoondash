part of 'update_product_type_cubit.dart';

abstract class UpdateProductTypeState {}

class UpdateProductTypeInitial extends UpdateProductTypeState {}

class UpdateProductTypeLoading extends UpdateProductTypeState {}

class UpdateProductTypeSuccess extends UpdateProductTypeState {
  final String message;
  UpdateProductTypeSuccess(this.message);
}

class UpdateProductTypeFailure extends UpdateProductTypeState {
  final String error;
  UpdateProductTypeFailure(this.error);
}
