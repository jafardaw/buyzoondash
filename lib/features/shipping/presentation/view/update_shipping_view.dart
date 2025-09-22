import 'package:buyzoonapp/core/func/dropdown_list.dart';
import 'package:buyzoonapp/core/func/show_snak_bar.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/core/widget/custom_button.dart';
import 'package:buyzoonapp/features/Order/presentation/view/manager/update_cubit/update_order_cubit.dart';
import 'package:buyzoonapp/features/Order/presentation/view/manager/update_cubit/update_order_state.dart';
import 'package:buyzoonapp/features/shipping/presentation/view/manager/update_cubit_shipp/update_shipping_cubit.dart';
import 'package:buyzoonapp/features/shipping/presentation/view/manager/update_cubit_shipp/update_shipping_state.dart';
import 'package:buyzoonapp/features/Order/repo/order_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateShippningView extends StatelessWidget {
  const UpdateShippningView({
    super.key,
    required this.idshipping,
    required this.status,
  });

  final int idshipping;
  final String status;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UpdateOrderStatusCubit(OrdersRepository(ApiService())),
      child: UpdateShippningViewBody(idshipping: idshipping, status: status),
    );
  }
}

class UpdateShippningViewBody extends StatefulWidget {
  UpdateShippningViewBody({
    super.key,
    required this.idshipping,
    required this.status,
  });

  final int idshipping;
  late String status;

  @override
  State<UpdateShippningViewBody> createState() =>
      _UpdateShippningViewBodyState();
}

class _UpdateShippningViewBodyState extends State<UpdateShippningViewBody> {
  late String _status;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _status = widget.status;
  }

  void _updateOrder() {
    if (_formKey.currentState!.validate()) {
      context.read<UpdateShippingCubit>().updateShippingStatus(
        orderId: widget.idshipping,
        status: _status,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateShippingCubit, UpdateShippingStatusState>(
      listener: (context, state) {
        if (state is UpdateShippingStatusSuccess) {
          showCustomSnackBar(context, state.message, color: Palette.success);
          Navigator.pop(context, true);
        } else if (state is UpdateShippingStatusFailure) {
          showCustomSnackBar(context, state.errorMessage, color: Palette.error);
        }
      },
      child: Scaffold(
        appBar: AppareWidget(
          title: 'تعديل الطلب ${widget.idshipping}',
          automaticallyImplyLeading: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                CustomDropdownField(
                  value: _status,
                  label: 'حالة الشحن',
                  items: const [
                    'pending',
                    'shipped',
                    'delivered',
                    'cancelled',
                    'failed',
                  ],
                  onChanged: (newValue) => setState(() => _status = newValue!),
                  iconColor: Palette.primary,
                ),
                const SizedBox(height: 24),
                BlocBuilder<UpdateShippingCubit, UpdateShippingStatusState>(
                  builder: (context, state) {
                    final isLoading = state is UpdateShippingStatusLoading;
                    return CustomButton(
                      onTap: isLoading ? () {} : _updateOrder,
                      text: isLoading ? 'جاري التعديل...' : 'تعديل الطلب',
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
