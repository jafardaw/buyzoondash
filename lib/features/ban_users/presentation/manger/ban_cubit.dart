import 'package:buyzoonapp/features/ban_users/presentation/manger/ban_state.dart';
import 'package:buyzoonapp/features/ban_users/repo/ban_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BanCubit extends Cubit<BanState> {
  final BanRepo _banRepo;

  BanCubit(this._banRepo) : super(BanInitial());

  Future<void> banUser({
    required int userId,
    required String reason,
    required int days,
  }) async {
    emit(BanLoading());
    try {
      final response = await _banRepo.banUser(
        userId: userId,
        reason: reason,
        days: days,
      );
      emit(BanSuccess(response));
    } catch (e) {
      emit(BanFailure(e.toString()));
    }
  }

  Future<void> updateBan({
    required int userId,
    required String reason,
    required int days,
  }) async {
    emit(BanLoading());
    try {
      final response = await _banRepo.updateBan(
        userId: userId,
        reason: reason,
        days: days,
      );
      emit(BanSuccess(response));
    } catch (e) {
      emit(BanFailure(e.toString()));
    }
  }

  Future<void> unBan({required int userId}) async {
    emit(BanLoading());
    try {
      final response = await _banRepo.unbanUser(userId: userId);
      emit(BanSuccess(response));
    } catch (e) {
      emit(BanFailure(e.toString()));
    }
  }
}
