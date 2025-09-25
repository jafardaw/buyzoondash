import 'package:buyzoonapp/core/func/dropdown_list.dart';
import 'package:buyzoonapp/core/func/show_snak_bar.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/core/widget/custom_button.dart';
import 'package:buyzoonapp/core/widget/loading_view.dart';
import 'package:buyzoonapp/features/Order/presentation/view/manager/update_cubit/update_order_cubit.dart';
import 'package:buyzoonapp/features/Order/presentation/view/manager/update_cubit/update_order_state.dart';
import 'package:buyzoonapp/features/Order/repo/order_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateOrderView extends StatelessWidget {
  const UpdateOrderView({
    super.key,
    required this.idorder,
    required this.status,
    required this.paymentstatus,
  });

  final int idorder;
  final String status;
  final String paymentstatus;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UpdateOrderStatusCubit(OrdersRepository(ApiService())),
      child: UpdateOrderViewBody(
        idorder: idorder,
        status: status,
        paymentstatus: paymentstatus,
      ),
    );
  }
}

class UpdateOrderViewBody extends StatefulWidget {
  UpdateOrderViewBody({
    super.key,
    required this.idorder,
    required this.status,
    required this.paymentstatus,
  });

  final int idorder;
  late String status;
  late String paymentstatus;

  @override
  State<UpdateOrderViewBody> createState() => _UpdateOrderViewBodyState();
}

class _UpdateOrderViewBodyState extends State<UpdateOrderViewBody> {
  late String _status;
  late String _paymentstatus;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _status = widget.status;
    _paymentstatus = widget.paymentstatus;
  }

  void _updateOrder() {
    if (_formKey.currentState!.validate()) {
      context.read<UpdateOrderStatusCubit>().updateOrderStatus(
        orderId: widget.idorder,
        status: _status,
        paymentStatus: _paymentstatus,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateOrderStatusCubit, UpdateOrderStatusState>(
      listener: (context, state) {
        if (state is UpdateOrderStatusSuccess) {
          showCustomSnackBar(context, state.message, color: Palette.success);
          Navigator.pop(context, true);
        } else if (state is UpdateOrderStatusFailure) {
          showCustomSnackBar(context, state.errorMessage, color: Palette.error);
        }
      },
      child: Scaffold(
        appBar: AppareWidget(
          title: 'تعديل الطلب ${widget.idorder}',
          automaticallyImplyLeading: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomDropdownField(
                  value: _status,
                  label: 'حالة الطلب',
                  items: const [
                    'pending',
                    'confirmed',
                    'completed',
                    'cancelled',
                  ],
                  onChanged: (newValue) => setState(() => _status = newValue!),
                  iconColor: Palette.primary,
                ),
                const SizedBox(height: 20),
                CustomDropdownField(
                  value: _paymentstatus,
                  label: 'حالة الدفع',
                  items: const ['unpaid', 'paid', 'refunded'],
                  onChanged: (newValue) =>
                      setState(() => _paymentstatus = newValue!),
                  iconColor: Palette.primary,
                ),
                const SizedBox(height: 24),
                BlocBuilder<UpdateOrderStatusCubit, UpdateOrderStatusState>(
                  builder: (context, state) {
                    final isLoading = state is UpdateOrderStatusLoading;
                    if (isLoading) {
                      return Center(child: const LoadingViewWidget());
                    }
                    return CustomButton(
                      onTap: () {
                        _updateOrder;
                      },
                      text: 'تعديل الطلب',
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
