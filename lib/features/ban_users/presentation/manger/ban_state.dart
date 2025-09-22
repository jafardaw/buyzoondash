import 'package:buyzoonapp/features/ban_users/data/model/ban_model.dart';

abstract class BanState {}

class BanInitial extends BanState {}

class BanLoading extends BanState {}

class BanSuccess extends BanState {
  final BanResponseModel response;
  BanSuccess(this.response);
}

class BanFailure extends BanState {
  final String error;
  BanFailure(this.error);
}
