// lib/features/location/Governorates/presentation/manger/update_city_cubit.dart

import 'package:buyzoonapp/features/location/Governorates/repo/city_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'update_city_state.dart';

class UpdateCityCubit extends Cubit<UpdateCityState> {
  final CityRepo _governorateRepo;

  UpdateCityCubit(this._governorateRepo) : super(UpdateCityInitial());

  Future<void> updateCity({
    required int cityId,
    required String name,
    required double price,
  }) async {
    emit(UpdateCityLoading());
    try {
      await _governorateRepo.updateCity(
        cityId: cityId,
        name: name,
        price: price,
      );
      emit(UpdateCitySuccess());
    } catch (e) {
      emit(UpdateCityFailure(e.toString()));
    }
  }
}
