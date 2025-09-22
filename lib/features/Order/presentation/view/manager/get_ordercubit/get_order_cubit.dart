// lib/features/orders/presentation/manager/get_orders_cubit/orders_cubit.dart

import 'package:buyzoonapp/features/Order/data/order_model.dart';
import 'package:buyzoonapp/features/Order/presentation/view/manager/get_ordercubit/get_order_state.dart';
import 'package:buyzoonapp/features/Order/repo/order_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class OrdersCubit extends Cubit<OrdersState> {
//   final OrdersRepository _ordersRepository;
//   int _currentPage = 1;
//   bool _isLoading = false;
//   int _lastPage = 1; // نضيف متغير لحفظ آخر صفحة
//   final List<OrderModel> _allOrders = [];

//   OrdersCubit(this._ordersRepository) : super(OrdersInitial());

// void resetAndReload() {
//   _currentPage = 1;
//   _allOrders.clear();
//   _lastPage = 1;
//   emit(OrdersInitial());  // نعيد الحالة الأولية
//   getOrders();            // نبدأ التحميل الجديد مباشرة
// }

//   Future<void> getOrders() async {
//     if (_isLoading) return;
//     if (_currentPage > _lastPage) return; // ما نحمل إذا تعدينا آخر صفحة

//     _isLoading = true;

//     if (_currentPage == 1) {
//       emit(OrdersLoading());
//     } else {
//       emit(OrdersPaginationLoading(orders: _allOrders, hasMoreData: true));
//     }

//     try {
//       final response = await _ordersRepository.getOrders(page: _currentPage);

//       // 👇 لازم يرجع response يحتوي orders + lastPage
//       final newOrders = response["orders"] as List<OrderModel>;
//       _lastPage = response["lastPage"] as int;

//       if (newOrders.isNotEmpty) {
//         _allOrders.addAll(newOrders);
//         _currentPage++;
//         emit(
//           OrdersSuccess(
//             orders: _allOrders,
//             hasMoreData: _currentPage <= _lastPage,
//           ),
//         );
//       } else {
//         emit(OrdersSuccess(orders: _allOrders, hasMoreData: false));
//       }
//     } catch (e) {
//       emit(OrdersFailure(errorMessage: e.toString()));
//     } finally {
//       _isLoading = false;
//     }
//   }
// }

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository _ordersRepository;
  int _currentPage = 1;
  bool _isLoading = false;
  int _lastPage = 1;
  final List<OrderModel> _allOrders = [];

  // 🛠️ إضافة متغيرات الفلتر في الـ Cubit
  String? _status;
  String? _paymentStatus;
  String? _shippingStatus;
  String? _region;
  String? _city;
  String? _governorate;

  OrdersCubit(this._ordersRepository) : super(OrdersInitial());

  void resetAndReload({
    String? status,
    String? paymentStatus,
    String? shippingStatus,
    String? region,
    String? city,
    String? governorate,
  }) {
    _currentPage = 1;
    _allOrders.clear();
    _lastPage = 1;

    _status = status;
    _paymentStatus = paymentStatus;
    _shippingStatus = shippingStatus;
    _region = region;
    _city = city;
    _governorate = governorate;

    emit(OrdersInitial());
    getOrders();
  }

  void refreshOrders() {
    _currentPage = 1;
    _allOrders.clear();
    _lastPage = 1;
    emit(OrdersInitial());
    getOrders();
  }

  // 🛠️ تعديل دالة getOrders لكي تستخدم الفلاتر المحفوظة
  Future<void> getOrders() async {
    if (_isLoading) return;
    if (_currentPage > _lastPage) return;

    _isLoading = true;

    if (_currentPage == 1) {
      emit(OrdersLoading());
    } else {
      emit(OrdersPaginationLoading(orders: _allOrders, hasMoreData: true));
    }

    try {
      final response = await _ordersRepository.getOrders(
        page: _currentPage,
        status: _status,
        paymentStatus: _paymentStatus,
        shippingStatus: _shippingStatus,
        region: _region,
        city: _city,
        governorate: _governorate,
      );

      final newOrders = response["orders"] as List<OrderModel>;
      _lastPage = response["lastPage"] as int;

      if (newOrders.isNotEmpty) {
        _allOrders.addAll(newOrders);
        _currentPage++;
        if (!isClosed) {
          emit(
            OrdersSuccess(
              orders: _allOrders,
              hasMoreData: _currentPage <= _lastPage,
            ),
          );
        }
      } else {
        if (!isClosed) {
          emit(OrdersSuccess(orders: _allOrders, hasMoreData: false));
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(OrdersFailure(errorMessage: e.toString()));
      }
    } finally {
      _isLoading = false;
    }
  }
}
