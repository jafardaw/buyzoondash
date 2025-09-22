// lib/features/location/Governorates/presentation/manger/add_city_cubit.dart
import 'package:buyzoonapp/features/location/Governorates/repo/city_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_city_state.dart';

class AddCityCubit extends Cubit<AddCityState> {
  final CityRepo _cityRepo;

  AddCityCubit(this._cityRepo) : super(AddCityInitial());

  Future<void> addCity({
    required int governorateId,
    required String name,
    required double price,
  }) async {
    emit(AddCityLoading());
    try {
      await _cityRepo.createCity(
        governorateId: governorateId,
        name: name,
        price: price,
      );
      emit(AddCitySuccess());
    } catch (e) {
      emit(AddCityFailure(e.toString()));
    }
  }
}
