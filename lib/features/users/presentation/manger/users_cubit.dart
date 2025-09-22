import 'package:buyzoonapp/features/users/data/model/user_model.dart';
import 'package:buyzoonapp/features/users/repo/users_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final UsersRepo _usersRepo;
  int _currentPage = 1;
  bool _canLoadMore = true;
  bool _isLoading = false;

  UsersCubit(this._usersRepo) : super(UsersInitial());

  Future<void> getUsers() async {
    if (_isLoading || !_canLoadMore) return; // منع الطلبات المتعددة

    _isLoading = true;

    if (_currentPage == 1) {
      emit(UsersLoading());
    } else {}

    try {
      final usersResponse = await _usersRepo.getUsers(page: _currentPage);

      final currentUsers = (state is UsersSuccess)
          ? (state as UsersSuccess).users.toList()
          : [];

      _canLoadMore = usersResponse.hasMore;
      _currentPage++;
      if (!isClosed) {
        emit(UsersSuccess([...currentUsers, ...usersResponse.users]));
      }
    } catch (e) {
      if (!isClosed) {
        emit(UsersFailure(e.toString()));
      }
    } finally {
      _isLoading = false;
    }
  }

  // دالة جديدة لإعادة تحميل البيانات من الصفحة الأولى
  Future<void> refreshUsers() async {
    _currentPage = 1;
    _canLoadMore = true;
    _isLoading = false;
    await getUsers();
  }
}
