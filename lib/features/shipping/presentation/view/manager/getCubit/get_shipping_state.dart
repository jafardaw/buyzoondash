// lib/features/shipping/presentation/manager/get_shipping_cubit/shipping_state.dart
import 'package:buyzoonapp/features/shipping/data/shipping_model.dart';
import 'package:equatable/equatable.dart';

abstract class ShippingState extends Equatable {
  const ShippingState();

  @override
  List<Object> get props => [];
}

class ShippingInitial extends ShippingState {}

class ShippingLoading extends ShippingState {}

class ShippingSuccess extends ShippingState {
  final ShippingModel shipping;

  const ShippingSuccess({required this.shipping});

  @override
  List<Object> get props => [shipping];
}

class ShippingFailure extends ShippingState {
  final String errorMessage;

  const ShippingFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
