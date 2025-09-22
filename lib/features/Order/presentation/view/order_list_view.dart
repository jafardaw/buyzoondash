// lib/features/orders/presentation/view/orders_view.dart

import 'package:buyzoonapp/core/func/dropdown_list.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/core/widget/custom_field.dart';
import 'package:buyzoonapp/core/widget/empty_view_list.dart';
import 'package:buyzoonapp/core/widget/error_widget_view.dart';
import 'package:buyzoonapp/core/widget/loading_view.dart';
import 'package:buyzoonapp/features/Order/presentation/view/manager/get_ordercubit/get_order_cubit.dart';
import 'package:buyzoonapp/features/Order/presentation/view/manager/get_ordercubit/get_order_state.dart';
import 'package:buyzoonapp/features/Order/presentation/view/widget/order_item_card.dart';
import 'package:buyzoonapp/features/notifaction/presentation/view/broadcast_notification_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppareWidget(
        title: 'قائمة الطلبات',
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BroadcastNotificationScreen(),
                ),
              );
            },
            icon: Icon(Icons.notifications),
          ),
        ],
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
              return const LoadingViewWidget(
                type: LoadingType.imageShake,
                imagePath:
                    'assest/images/SAVE_٢٠٢٥٠٨٢٩_٢٣٣٣٥١-removebg-preview.png', // مسار صورتك
                size: 200, // حجم الصورة
              );
            } else if (state is OrdersSuccess) {
              return _buildOrdersList(
                state,
                showLoader: state is OrdersPaginationLoading,
              );
            } else if (state is OrdersFailure) {
              return ShowErrorWidgetView.fullScreenError(
                errorMessage: state.errorMessage,
                onRetry: () {
                  context.read<OrdersCubit>().getOrders();
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildOrdersList(OrdersSuccess state, {bool showLoader = false}) {
    if (state.orders.isEmpty) {
      return EmptyListViews(text: 'لا يوجد طلبات حالياً.');
    }

    return ListView.builder(
      itemCount: state.orders.length + (showLoader ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.orders.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: CircularProgressIndicator(color: Palette.primary),
            ),
          );
        }
        final order = state.orders[index];
        return OrderItemCard(order: order);
      },
    );
  }

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
