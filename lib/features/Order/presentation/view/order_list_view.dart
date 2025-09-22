// lib/features/orders/presentation/view/orders_view.dart

import 'package:buyzoonapp/core/func/dropdown_list.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/core/widget/custom_field.dart';
import 'package:buyzoonapp/features/Order/presentation/view/manager/get_ordercubit/get_order_cubit.dart';
import 'package:buyzoonapp/features/Order/presentation/view/manager/get_ordercubit/get_order_state.dart';
import 'package:buyzoonapp/features/Order/presentation/view/widget/order_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// lib/features/orders/presentation/view/orders_view.dart

// class OrdersView extends StatefulWidget {
//   const OrdersView({super.key});

//   @override
//   State<OrdersView> createState() => _OrdersViewState();
// }

// class _OrdersViewState extends State<OrdersView> {
//   final _scrollController = ScrollController();

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   context.read<OrdersCubit>().getOrders();
//   //   _scrollController.addListener(_onScroll);

//   //   // Check the current state of the Cubit before fetching data
//   //   // if (context.read<OrdersCubit>().state is OrdersInitial) {

//   //   // }
//   // }

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);

//     // إعادة تحميل البيانات من جديد كل مرة تدخل الصفحة
//     final cubit = context.read<OrdersCubit>();
//     cubit.resetAndReload(); // دالة جديدة لمسح البيانات وإعادة الصفحة الأولى
//     cubit.getOrders();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels ==
//         _scrollController.position.maxScrollExtent) {
//       context.read<OrdersCubit>().getOrders();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppareWidget(
//         title: 'قائمة الطلبات',
//         automaticallyImplyLeading: true,
//       ),
//       body: BlocBuilder<OrdersCubit, OrdersState>(
//         builder: (context, state) {
//           if (state is OrdersLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is OrdersSuccess) {
//             return _buildOrdersList(
//               state,
//               showLoader: state is OrdersPaginationLoading,
//             );
//           } else if (state is OrdersFailure) {
//             return Center(child: Text('حدث خطأ: ${state.errorMessage}'));
//           }
//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }

//   Widget _buildOrdersList(OrdersSuccess state, {bool showLoader = false}) {
//     return ListView.builder(
//       controller: _scrollController,
//       itemCount: state.orders.length + (showLoader ? 1 : 0),
//       itemBuilder: (context, index) {
//         if (index >= state.orders.length) {
//           return const Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 24.0),
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }
//         final order = state.orders[index];
//         return OrderItemCard(order: order);
//       },
//     );
//   }
// }

// lib/features/orders/presentation/view/orders_view.dart

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  // 🛠️ إضافة متغيرات الفلتر
  final _formKey = GlobalKey<FormState>();
  String? _status;
  String? _paymentStatus;
  String? _shippingStatus;
  final _regionController = TextEditingController();
  final _cityController = TextEditingController();
  final _governorateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<OrdersCubit>();
    cubit.resetAndReload();
  }

  @override
  void dispose() {
    _regionController.dispose();
    _cityController.dispose();
    _governorateController.dispose();
    super.dispose();
  }

  // 🛠️ دالة لتطبيق الفلاتر والبدء من الصفحة الأولى
  void _applyFilters() {
    FocusScope.of(context).unfocus();
    final cubit = context.read<OrdersCubit>();
    cubit.resetAndReload(
      status: _status,
      paymentStatus: _paymentStatus,
      shippingStatus: _shippingStatus,
      region: _regionController.text.isNotEmpty ? _regionController.text : null,
      city: _cityController.text.isNotEmpty ? _cityController.text : null,
      governorate: _governorateController.text.isNotEmpty
          ? _governorateController.text
          : null,
    );
  }

  // 🛠️ دالة لمسح الفلاتر
  void _clearFilters() {
    _formKey.currentState!.reset();
    setState(() {
      _status = null;
      _paymentStatus = null;
      _shippingStatus = null;
      _regionController.clear();
      _cityController.clear();
      _governorateController.clear();
    });
    // إعادة تحميل القائمة بدون فلاتر
    context.read<OrdersCubit>().resetAndReload();
  }

  @override
  // داخل دالة build في OrdersView
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppareWidget(
        title: 'قائمة الطلبات',
        automaticallyImplyLeading: true,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(child: _buildFilterSection()),
            SliverToBoxAdapter(child: const Divider(height: 1)),
          ];
        },
        body: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrdersSuccess) {
              return _buildOrdersList(
                state,
                showLoader: state is OrdersPaginationLoading,
              );
            } else if (state is OrdersFailure) {
              return Center(child: Text('حدث خطأ: ${state.errorMessage}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildOrdersList(OrdersSuccess state, {bool showLoader = false}) {
    if (state.orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list_alt, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'لا يوجد طلبات حالياً.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: state.orders.length + (showLoader ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.orders.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final order = state.orders[index];
        return OrderItemCard(order: order);
      },
    );
  }

  // 🛠️ دالة بناء قسم الفلاتر
  Widget _buildFilterSection() {
    return ExpansionTile(
      title: const Text(
        'فلاتر البحث',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomDropdownField(
                  value: _status,
                  label: 'حالة الطلب',
                  items: ['pending', 'confirmed', 'completed', 'cancelled'],
                  onChanged: (newValue) => setState(() => _status = newValue),
                  iconColor: Palette.primary,
                ),

                CustomDropdownField(
                  value: _paymentStatus,
                  label: 'حالة الدفع',
                  items: ['unpaid', 'paid', 'refunded'],
                  onChanged: (newValue) =>
                      setState(() => _paymentStatus = newValue),
                  iconColor: Palette.primary,
                ),

                CustomDropdownField(
                  value: _shippingStatus,
                  label: 'حالة الشحن',
                  items: [
                    'pending',
                    'shipped',
                    'delivered',
                    'cancelled',
                    'failed',
                  ],
                  onChanged: (newValue) =>
                      setState(() => _shippingStatus = newValue),
                  iconColor: Palette.primary,
                ),
                SizedBox(height: 4),
                // حقول النصوص للمنطقة والمدينة والمحافظة
                CustomTextField(
                  controller: _regionController,
                  hintText: 'المنطقة',
                ),
                SizedBox(height: 4),
                CustomTextField(
                  controller: _cityController,
                  hintText: 'المدينة',
                ),
                SizedBox(height: 4),
                CustomTextField(
                  controller: _governorateController,
                  hintText: 'المحافظة',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.search),
                        label: const Text('بحث'),
                        onPressed: _applyFilters,
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              Palette.primary, // يمكنك تغيير هذا اللون
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.search),
                        label: const Text('مسح الفلاتر'),
                        onPressed: _clearFilters,
                        style: FilledButton.styleFrom(
                          foregroundColor: Palette.primary,
                          side: const BorderSide(
                            color: Palette.primary, // 🛠️ لون الحافة
                            // width: 2.0, // 🛠️ سمك الحافة
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
