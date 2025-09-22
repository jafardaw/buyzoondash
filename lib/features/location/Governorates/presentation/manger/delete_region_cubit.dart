import 'package:buyzoonapp/features/location/Governorates/repo/region_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'delete_region_state.dart';

class DeleteRegionCubit extends Cubit<DeleteRegionState> {
  final RegionRepo _regionRepo;
  DeleteRegionCubit(this._regionRepo) : super(DeleteRegionInitial());

  Future<void> deleteRegion({required int regionId}) async {
    emit(DeleteRegionLoading());
    try {
      final message = await _regionRepo.deleteRegion(regionId: regionId);
      emit(DeleteRegionSuccess(message));
    } catch (e) {
      emit(DeleteRegionFailure(e.toString()));
    }
  }
}
