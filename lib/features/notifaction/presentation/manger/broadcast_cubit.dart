import 'package:buyzoonapp/features/notifaction/repo/broadcast_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'broadcast_state.dart';

class BroadcastCubit extends Cubit<BroadcastState> {
  final BroadcastRepo _broadcastRepo;

  BroadcastCubit(this._broadcastRepo) : super(BroadcastInitial());

  Future<void> sendNotification({
    required String title,
    required String body,
  }) async {
    emit(BroadcastLoading());
    try {
      final message = await _broadcastRepo.sendNotification(
        title: title,
        body: body,
      );
      emit(BroadcastSuccess(message));
    } catch (e) {
      emit(BroadcastFailure(e.toString()));
    }
  }
}
