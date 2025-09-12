part of 'add_product_type_cubit.dart';

abstract class AddProductTypeState {}

class AddProductTypeInitial extends AddProductTypeState {}

class AddProductTypeLoading extends AddProductTypeState {}

class AddProductTypeSuccess extends AddProductTypeState {
  final String message;
  AddProductTypeSuccess(this.message);
}

class AddProductTypeFailure extends AddProductTypeState {
  final String error;
  AddProductTypeFailure(this.error);
}
