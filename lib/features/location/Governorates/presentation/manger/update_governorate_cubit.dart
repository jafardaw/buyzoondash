import 'package:buyzoonapp/features/location/Governorates/presentation/manger/update_governorate_state.dart';
import 'package:buyzoonapp/features/location/Governorates/repo/governorate_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateGovernorateCubit extends Cubit<UpdateGovernorateState> {
  final GovernorateRepo _governorateRepo;

  UpdateGovernorateCubit(this._governorateRepo)
    : super(UpdateGovernorateInitial());

  Future<void> updateGovernorate({
    required int id,
    required String name,
    required double price,
  }) async {
    emit(UpdateGovernorateLoading());
    try {
      final message = await _governorateRepo.updateGovernorate(
        id: id,
        name: name,
        price: price,
      );
      emit(UpdateGovernorateSuccess(messsag: message));
    } catch (e) {
      emit(UpdateGovernorateFailure(e.toString()));
    }
  }
}
