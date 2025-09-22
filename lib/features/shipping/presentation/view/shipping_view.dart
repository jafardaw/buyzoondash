// lib/features/shipping/presentation/view/shipping_view.dart
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/features/shipping/data/shipping_model.dart';
import 'package:buyzoonapp/features/shipping/presentation/view/manager/getCubit/get_shipping_cubit.dart';
import 'package:buyzoonapp/features/shipping/presentation/view/manager/getCubit/get_shipping_state.dart';
import 'package:buyzoonapp/features/shipping/presentation/view/manager/update_cubit_shipp/update_shipping_cubit.dart';
import 'package:buyzoonapp/features/shipping/presentation/view/update_shipping_view.dart';
import 'package:buyzoonapp/features/shipping/repo/shipping_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// lib/features/shipping/presentation/view/shipping_view.dart

class ShippingView extends StatefulWidget {
  final int orderid;
  const ShippingView({super.key, required this.orderid});

  @override
  State<ShippingView> createState() => _ShippingViewState();
}

class _ShippingViewState extends State<ShippingView> {
  @override
  void initState() {
    super.initState();
    context.read<ShippingCubit>().getShippingDetails(widget.orderid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppareWidget(
        title: 'تفاصيل الشحن',
        automaticallyImplyLeading: true,
      ),
      body: BlocBuilder<ShippingCubit, ShippingState>(
        builder: (context, state) {
          if (state is ShippingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ShippingSuccess) {
            return _buildShippingDetails(state.shipping);
          } else if (state is ShippingFailure) {
            return Center(child: Text('حدث خطأ: ${state.errorMessage}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildShippingDetails(ShippingModel shipping) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tracking Number and Status Card
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) =>
                          UpdateShippingCubit(ShippingRepository(ApiService())),
                      child: UpdateShippningView(
                        idshipping: widget.orderid,
                        status: shipping.status!,
                      ),
                    ),
                  ),
                ).then((result) {
                  if (result == true) {
                    context.read<ShippingCubit>().getShippingDetails(
                      widget.orderid,
                    );
                  }
                });
              },
              child: _buildStatusCard(shipping),
            ),
            const SizedBox(height: 20),

            // Shipping Dates Section
            _buildDetailsSection(
              title: 'تواريخ الشحن',
              children: [
                _buildInfoRow(
                  icon: Icons.access_time,
                  label: 'تاريخ الشحن',
                  value: shipping.shippedAt ?? 'لم يتم الشحن بعد',
                ),
                const SizedBox(height: 10),
                _buildInfoRow(
                  icon: Icons.delivery_dining,
                  label: 'تاريخ التسليم',
                  value: shipping.deliveredAt ?? 'لم يتم التسليم بعد',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Location Details Section
            _buildDetailsSection(
              title: 'تفاصيل الموقع',
              children: [
                _buildInfoRow(
                  icon: Icons.location_on,
                  label: 'موقع الشحن',
                  value: shipping.location?.details ?? 'غير متوفر',
                ),
                const SizedBox(height: 10),
                _buildInfoRow(
                  icon: Icons.attach_money,
                  label: 'سعر الشحن',
                  value: shipping.location?.price != null
                      ? '${shipping.location!.price} \$'
                      : 'غير متوفر',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Associated Order Details Section
            _buildDetailsSection(
              title: 'تفاصيل الطلب المرتبط',
              children: [
                _buildInfoRow(
                  icon: Icons.receipt_long,
                  label: 'رقم الطلب',
                  value: shipping.order?.id.toString() ?? 'غير متوفر',
                ),
                const SizedBox(height: 10),
                _buildInfoRow(
                  icon: Icons.price_change,
                  label: 'السعر الإجمالي للطلب',
                  value: shipping.order?.totalPrice != null
                      ? '${shipping.order!.totalPrice!.toStringAsFixed(2)} \$'
                      : 'غير متوفر',
                ),
                const SizedBox(height: 10),
                _buildInfoRow(
                  icon: Icons.info_outline,
                  label: 'حالة الطلب',
                  value: shipping.order?.status ?? 'غير متوفر',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(ShippingModel shipping) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: _getStatusColor(shipping.status),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor(shipping.status).withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.local_shipping, color: Colors.white, size: 50),
          const SizedBox(height: 10),
          Text(
            shipping.status ?? 'غير متوفر',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'رقم التتبع: ${shipping.trackingNumber ?? 'غير متوفر'}',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 5),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue[900], size: 22),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.blueAccent;
      case 'shipped':
        return Colors.indigo;
      case 'delivered':
        return Palette.secandry;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
