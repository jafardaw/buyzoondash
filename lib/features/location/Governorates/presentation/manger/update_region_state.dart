abstract class UpdateRegionState {}

class UpdateRegionInitial extends UpdateRegionState {}

class UpdateRegionLoading extends UpdateRegionState {}

class UpdateRegionSuccess extends UpdateRegionState {
  final String message;
  UpdateRegionSuccess(this.message);
}

class UpdateRegionFailure extends UpdateRegionState {
  final String error;
  UpdateRegionFailure(this.error);
}
