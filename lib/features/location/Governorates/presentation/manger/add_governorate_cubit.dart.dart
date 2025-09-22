import 'package:buyzoonapp/features/location/Governorates/presentation/manger/add_governorate_state.dart';
import 'package:buyzoonapp/features/location/Governorates/repo/governorate_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddGovernorateCubit extends Cubit<AddGovernorateState> {
  final GovernorateRepo _governorateRepo;

  AddGovernorateCubit(this._governorateRepo) : super(AddGovernorateInitial());

  Future<void> addGovernorate({
    required String name,
    required double price,
  }) async {
    emit(AddGovernorateLoading());
    try {
      final governorateModel = await _governorateRepo.addGovernorate(
        name: name,
        price: price,
      );
      emit(AddGovernorateSuccess(governorateModel));
    } catch (e) {
      emit(AddGovernorateFailure(e.toString()));
    }
  }
}
