part of 'user_details_cubit.dart';

abstract class UserDetailsState {}

class UserDetailsInitial extends UserDetailsState {}

class UserDetailsLoading extends UserDetailsState {}

class UserDetailsSuccess extends UserDetailsState {
  final UserModel user;
  UserDetailsSuccess(this.user);
}

class UserDetailsFailure extends UserDetailsState {
  final String error;
  UserDetailsFailure(this.error);
}
