part of 'delete_user_cubit.dart';

abstract class DeleteUserState {}

class DeleteUserInitial extends DeleteUserState {}

class DeleteUserLoading extends DeleteUserState {}

class DeleteUserSuccess extends DeleteUserState {
  final String message;
  DeleteUserSuccess(this.message);
}

class DeleteUserFailure extends DeleteUserState {
  final String error;
  DeleteUserFailure(this.error);
}
