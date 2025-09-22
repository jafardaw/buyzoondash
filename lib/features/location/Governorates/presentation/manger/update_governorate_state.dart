abstract class UpdateGovernorateState {}

class UpdateGovernorateInitial extends UpdateGovernorateState {}

class UpdateGovernorateLoading extends UpdateGovernorateState {}

class UpdateGovernorateSuccess extends UpdateGovernorateState {
  final String messsag;

  UpdateGovernorateSuccess({required this.messsag});
}

class UpdateGovernorateFailure extends UpdateGovernorateState {
  final String error;
  UpdateGovernorateFailure(this.error);
}
