import 'package:equatable/equatable.dart';

abstract class UpdateOrderStatusState extends Equatable {
  const UpdateOrderStatusState();

  @override
  List<Object> get props => [];
}

class UpdateOrderStatusInitial extends UpdateOrderStatusState {}

class UpdateOrderStatusLoading extends UpdateOrderStatusState {}

class UpdateOrderStatusSuccess extends UpdateOrderStatusState {
  final String message;
  const UpdateOrderStatusSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class UpdateOrderStatusFailure extends UpdateOrderStatusState {
  final String errorMessage;
  const UpdateOrderStatusFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
