abstract class DeleteRegionState {}

class DeleteRegionInitial extends DeleteRegionState {}

class DeleteRegionLoading extends DeleteRegionState {}

class DeleteRegionSuccess extends DeleteRegionState {
  final String message;
  DeleteRegionSuccess(this.message);
}

class DeleteRegionFailure extends DeleteRegionState {
  final String error;
  DeleteRegionFailure(this.error);
}
