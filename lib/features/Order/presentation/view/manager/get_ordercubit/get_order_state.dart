// lib/features/orders/presentation/manager/get_orders_cubit/orders_state.dart

import 'package:equatable/equatable.dart';

import '../../../../data/order_model.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersPaginationLoading extends OrdersSuccess {
  const OrdersPaginationLoading({
    required super.orders,
    required super.hasMoreData,
  });
}

class OrdersSuccess extends OrdersState {
  final List<OrderModel> orders;
  final bool hasMoreData;

  const OrdersSuccess({required this.orders, required this.hasMoreData});

  @override
  List<Object> get props => [orders, hasMoreData];
}

class OrdersFailure extends OrdersState {
  final String errorMessage;

  const OrdersFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
