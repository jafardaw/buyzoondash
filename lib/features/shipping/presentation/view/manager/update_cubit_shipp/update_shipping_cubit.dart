import 'package:buyzoonapp/features/shipping/presentation/view/manager/update_cubit_shipp/update_shipping_state.dart';
import 'package:buyzoonapp/features/shipping/repo/shipping_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateShippingCubit extends Cubit<UpdateShippingStatusState> {
  final ShippingRepository ordersRepository;

  UpdateShippingCubit(this.ordersRepository)
    : super(UpdateShippingStatusInitial());

  Future<void> updateShippingStatus({
    required int orderId,
    required String status,
  }) async {
    emit(UpdateShippingStatusLoading());
    try {
      final body = {"status": status};
      await ordersRepository.updateShippingStatus(orderId: orderId, body: body);
      emit(const UpdateShippingStatusSuccess('تم تحديث حالة الشحن بنجاح.'));
    } catch (e) {
      emit(UpdateShippingStatusFailure(e.toString()));
    }
  }
}
