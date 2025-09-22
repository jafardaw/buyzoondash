import 'package:buyzoonapp/features/ban_users/data/model/ban_user_model.dart';

abstract class BannedUsersState {}

class BannedUsersInitial extends BannedUsersState {}

class BannedUsersLoading extends BannedUsersState {}

class BannedUsersSuccess extends BannedUsersState {
  final List<UserBanModel> users;
  BannedUsersSuccess(this.users);
}

class BannedUsersFailure extends BannedUsersState {
  final String error;
  BannedUsersFailure(this.error);
}
