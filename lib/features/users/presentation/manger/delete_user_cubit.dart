import 'package:buyzoonapp/features/users/repo/users_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'delete_user_state.dart';

class DeleteUserCubit extends Cubit<DeleteUserState> {
  final UsersRepo _usersRepo;

  DeleteUserCubit(this._usersRepo) : super(DeleteUserInitial());

  Future<void> deleteUser({required int userId}) async {
    emit(DeleteUserLoading());
    try {
      final message = await _usersRepo.deleteUser(userId: userId);
      emit(DeleteUserSuccess(message));
    } catch (e) {
      emit(DeleteUserFailure(e.toString()));
    }
  }
}
