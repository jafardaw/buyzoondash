import 'package:buyzoonapp/features/location/Governorates/repo/region_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'update_region_state.dart';

class UpdateRegionCubit extends Cubit<UpdateRegionState> {
  final RegionRepo _regionRepo;
  UpdateRegionCubit(this._regionRepo) : super(UpdateRegionInitial());

  Future<void> updateRegion({
    required int regionId,
    required String name,
    required int cityId,
    required double price,
  }) async {
    emit(UpdateRegionLoading());
    try {
      final message = await _regionRepo.updateRegion(
        regionId: regionId,
        name: name,
        cityId: cityId,
        price: price,
      );
      emit(UpdateRegionSuccess(message));
    } catch (e) {
      emit(UpdateRegionFailure(e.toString()));
    }
  }
}
