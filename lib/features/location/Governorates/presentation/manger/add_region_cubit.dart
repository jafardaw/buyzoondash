// lib/features/location/Governorates/presentation/manger/add_region_cubit.dart
import 'package:buyzoonapp/features/location/Governorates/repo/region_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:buyzoonapp/features/location/Governorates/repo/governorate_repo.dart';
import 'add_region_state.dart';

class AddRegionCubit extends Cubit<AddRegionState> {
  final RegionRepo _regionRepo;

  AddRegionCubit(this._regionRepo) : super(AddRegionInitial());

  Future<void> addRegion({
    required String name,
    required int cityId,
    required double price,
  }) async {
    emit(AddRegionLoading());
    try {
      await _regionRepo.createRegion(name: name, cityId: cityId, price: price);
      emit(AddRegionSuccess());
    } catch (e) {
      emit(AddRegionFailure(e.toString()));
    }
  }
}
