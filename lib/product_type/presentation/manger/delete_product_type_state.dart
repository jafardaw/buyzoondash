part of 'delete_product_type_cubit.dart';

abstract class DeleteProductTypeState {}

class DeleteProductTypeInitial extends DeleteProductTypeState {}

class DeleteProductTypeLoading extends DeleteProductTypeState {}

class DeleteProductTypeSuccess extends DeleteProductTypeState {
  final String message;
  DeleteProductTypeSuccess(this.message);
}

class DeleteProductTypeFailure extends DeleteProductTypeState {
  final String error;
  DeleteProductTypeFailure(this.error);
}
