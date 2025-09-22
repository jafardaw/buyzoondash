// lib/features/governorates/presentation/manger/add_city_state.dart

abstract class AddCityState {}

class AddCityInitial extends AddCityState {}

class AddCityLoading extends AddCityState {}

class AddCitySuccess extends AddCityState {}

class AddCityFailure extends AddCityState {
  final String error;
  AddCityFailure(this.error);
}
