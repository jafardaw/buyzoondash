part of 'broadcast_cubit.dart';

abstract class BroadcastState {}

class BroadcastInitial extends BroadcastState {}

class BroadcastLoading extends BroadcastState {}

class BroadcastSuccess extends BroadcastState {
  final String message;
  BroadcastSuccess(this.message);
}

class BroadcastFailure extends BroadcastState {
  final String error;
  BroadcastFailure(this.error);
}
