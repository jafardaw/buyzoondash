part of 'users_cubit.dart';

abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersSuccess extends UsersState {
  final List<UserModel> users;
  UsersSuccess(this.users);
}

class UsersFailure extends UsersState {
  final String error;
  UsersFailure(this.error);
}
