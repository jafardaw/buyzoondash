abstract class AddGovernorateState {}

class AddGovernorateInitial extends AddGovernorateState {}

class AddGovernorateLoading extends AddGovernorateState {}

class AddGovernorateSuccess extends AddGovernorateState {
  final String message;
  AddGovernorateSuccess(this.message);
}

class AddGovernorateFailure extends AddGovernorateState {
  final String error;
  AddGovernorateFailure(this.error);
}
