// governorate_delete_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/manger/governorate_delete_state.dart';
import 'package:buyzoonapp/features/location/Governorates/repo/governorate_repo.dart';
// تأكد من استيراد GovernorateRepo و GovernorateDeleteState
// import 'package:aqavia/features/auth/repo/governorate_repo.dart'; // افترض مسارك

class GovernorateDeleteCubit extends Cubit<GovernorateDeleteState> {
  final GovernorateRepo _governorateRepo;

  GovernorateDeleteCubit(this._governorateRepo)
    : super(GovernorateDeleteInitial());

  Future<void> deleteGovernorate(int governorateId) async {
    emit(GovernorateDeleteLoading());
    try {
      // ⚠️ يجب أن تضيف دالة deleteGovernorate إلى GovernoratesRepo لتنفيذ الطلب
      final message = await _governorateRepo.deleteGovernorate(
        id: governorateId,
      );
      emit(GovernorateDeleteSuccess(message));
    } catch (e) {
      emit(GovernorateDeleteFailure(e.toString()));
    }
  }
}
