// governorate_delete_state.dart
abstract class GovernorateDeleteState {}

class GovernorateDeleteInitial extends GovernorateDeleteState {}

class GovernorateDeleteLoading extends GovernorateDeleteState {}

class GovernorateDeleteSuccess extends GovernorateDeleteState {
  final String message;
  GovernorateDeleteSuccess(this.message);
}

class GovernorateDeleteFailure extends GovernorateDeleteState {
  final String error;
  GovernorateDeleteFailure(this.error);
}
