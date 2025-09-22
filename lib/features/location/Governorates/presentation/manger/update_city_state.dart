abstract class UpdateCityState {}

class UpdateCityInitial extends UpdateCityState {}

class UpdateCityLoading extends UpdateCityState {}

class UpdateCitySuccess extends UpdateCityState {}

class UpdateCityFailure extends UpdateCityState {
  final String error;
  UpdateCityFailure(this.error);
}
