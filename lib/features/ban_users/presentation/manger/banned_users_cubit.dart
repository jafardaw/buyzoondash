import 'package:buyzoonapp/features/ban_users/presentation/manger/banned_users_state.dart';
import 'package:buyzoonapp/features/ban_users/repo/banned_users_repo.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class BannedUsersCubit extends Cubit<BannedUsersState> {
  final BannedUsersRepo _bannedUsersRepo;

  BannedUsersCubit(this._bannedUsersRepo) : super(BannedUsersInitial());

  Future<void> getBannedUsers() async {
    emit(BannedUsersLoading());
    try {
      final users = await _bannedUsersRepo.getBannedUsers();
      emit(BannedUsersSuccess(users));
    } catch (e) {
      emit(BannedUsersFailure(e.toString()));
    }
  }
}
