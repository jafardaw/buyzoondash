import 'package:buyzoonapp/features/users/data/model/user_model.dart';
import 'package:buyzoonapp/features/users/repo/users_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  final UsersRepo _usersRepo;

  UserDetailsCubit(this._usersRepo) : super(UserDetailsInitial());

  Future<void> getUserDetails({required int userId}) async {
    emit(UserDetailsLoading());
    try {
      final user = await _usersRepo.getUserDetails(userId: userId);
      emit(UserDetailsSuccess(user));
    } catch (e) {
      emit(UserDetailsFailure(e.toString()));
    }
  }
}
