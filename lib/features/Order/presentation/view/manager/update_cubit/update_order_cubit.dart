import 'package:buyzoonapp/features/Order/presentation/view/manager/update_cubit/update_order_state.dart';
import 'package:buyzoonapp/features/Order/repo/order_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateOrderStatusCubit extends Cubit<UpdateOrderStatusState> {
  final OrdersRepository ordersRepository;

  UpdateOrderStatusCubit(this.ordersRepository)
    : super(UpdateOrderStatusInitial());

  Future<void> updateOrderStatus({
    required int orderId,
    required String status,
    required String paymentStatus,
  }) async {
    emit(UpdateOrderStatusLoading());
    try {
      final body = {"status": status, "payment_status": paymentStatus};
      await ordersRepository.updateOrderStatus(orderId: orderId, body: body);
      emit(const UpdateOrderStatusSuccess('تم تحديث حالة الطلب بنجاح.'));
    } catch (e) {
      emit(UpdateOrderStatusFailure(e.toString()));
    }
  }
}
