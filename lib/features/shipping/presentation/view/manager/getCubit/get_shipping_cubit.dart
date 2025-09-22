// lib/features/shipping/presentation/manager/get_shipping_cubit/shipping_cubit.dart
import 'package:buyzoonapp/features/shipping/presentation/view/manager/getCubit/get_shipping_state.dart';
import 'package:buyzoonapp/features/shipping/repo/shipping_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

class ShippingCubit extends Cubit<ShippingState> {
  final ShippingRepository _shippingRepository;

  ShippingCubit(this._shippingRepository) : super(ShippingInitial());

  Future<void> getShippingDetails(int id) async {
    emit(ShippingLoading());
    try {
      final shipping = await _shippingRepository.getShippingDetails(id);
      emit(ShippingSuccess(shipping: shipping));
    } catch (e) {
      if (kDebugMode) {
        print('Error in ShippingCubit: $e');
      }
      emit(ShippingFailure(errorMessage: e.toString()));
    }
  }
}
