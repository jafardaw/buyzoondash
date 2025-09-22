import 'package:equatable/equatable.dart';

abstract class UpdateShippingStatusState extends Equatable {
  const UpdateShippingStatusState();

  @override
  List<Object> get props => [];
}

class UpdateShippingStatusInitial extends UpdateShippingStatusState {}

class UpdateShippingStatusLoading extends UpdateShippingStatusState {}

class UpdateShippingStatusSuccess extends UpdateShippingStatusState {
  final String message;
  const UpdateShippingStatusSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class UpdateShippingStatusFailure extends UpdateShippingStatusState {
  final String errorMessage;
  const UpdateShippingStatusFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
