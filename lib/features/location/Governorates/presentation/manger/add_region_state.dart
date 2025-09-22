abstract class AddRegionState {}

class AddRegionInitial extends AddRegionState {}

class AddRegionLoading extends AddRegionState {}

class AddRegionSuccess extends AddRegionState {}

class AddRegionFailure extends AddRegionState {
  final String error;
  AddRegionFailure(this.error);
}
