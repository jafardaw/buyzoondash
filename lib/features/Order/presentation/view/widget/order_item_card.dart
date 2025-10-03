import 'package:buyzoonapp/core/func/show_menu.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/widget/empty_view_list.dart';
import 'package:buyzoonapp/features/Order/data/order_model.dart';
import 'package:buyzoonapp/features/Order/presentation/view/manager/get_ordercubit/get_order_cubit.dart';
import 'package:buyzoonapp/features/Order/presentation/view/update_order_view.dart';
import 'package:buyzoonapp/features/invoice/presentation/view/invoice_view.dart';
import 'package:buyzoonapp/features/shipping/presentation/view/manager/getCubit/get_shipping_cubit.dart';
import 'package:buyzoonapp/features/shipping/presentation/view/shipping_view.dart';
import 'package:buyzoonapp/features/shipping/repo/shipping_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderItemCard extends StatelessWidget {
  final OrderModel order;
  const OrderItemCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> myMenuItems = [
      {
        'value': 'shipping',
        'icon': const Icon(Icons.view_list, color: Palette.secandry),
        'title': 'حالة الشحنة ',
        'onTap': () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) =>
                    ShippingCubit(ShippingRepository(ApiService())),
                child: ShippingView(orderid: order.id),
              ),
            ),
          );
        },
      },
      {
        'value': 'bill',
        'icon': const Icon(Icons.edit, color: Palette.primary),
        'title': 'الفاتورة لهذا الطلب',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InvoiceView(orderId: order.id),
            ),
          );
        },
      },
    ];
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTapDown: (details) {
                    showProductMenu(
                      context: context,
                      position: details.globalPosition,
                      menuItems: myMenuItems,
                    );
                  },
                  child: Icon(Icons.menu),
                ),

                IconButton(
                  onPressed: () {
                    // Example of how to navigate to the ShippingView
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) => UpdateOrderView(
                              idorder: order.id,
                              status: order.status!,
                              paymentstatus: order.paymentstatus!,
                            ),
                          ),
                        )
                        .then((result) {
                          if (result == true) {
                            context.read<OrdersCubit>().refreshOrders();
                          }
                        });
                  },
                  icon: Icon(Icons.edit, color: Colors.green),
                ),

                Text(
                  'رقم الطلب: #${order.id}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.status ?? 'غير متوفر',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 25.0, color: Colors.grey),
            // قسم تفاصيل المستخدم
            _buildSectionTitle('بيانات المستخدم:'),
            _buildInfoRow('الاسم:', order.user?.username ?? 'غير متوفر'),
            _buildInfoRow(
              'رقم الهاتف:',
              order.user?.phoneNumber ?? 'غير متوفر',
            ),
            _buildInfoRow(' حالة الدفع:', order.paymentstatus ?? 'غير متوفر'),
            // _buildInfoRow('العنوان:', order.user?.a ?? 'غير متوفر'),
            const SizedBox(height: 15.0),
            // قسم تفاصيل الطلب
            _buildSectionTitle('عناصر الطلب:'),
            if (order.itemOrders != null && order.itemOrders!.isNotEmpty)
              ...order.itemOrders!.map((item) {
                return _buildOrderItem(item);
              })
            else
              const EmptyListViews(text: 'لا يوجد عناصر في هذا الطلب.'),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لتلوين حالة الطلب
  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'shipped':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // دالة مساعدة لبناء عنوان القسم
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  // دالة مساعدة لبناء صف من المعلومات
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لبناء كل عنصر في الطلب
  Widget _buildOrderItem(ItemOrderModel item) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shopping_bag,
                size: 20,
                color: Colors.blueAccent,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.product?.name ?? 'منتج غير معروف',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('الكمية: ${item.quantity ?? 0}'),
                Text(
                  'السعر: ${item.product?.price?.toStringAsFixed(2) ?? '0.00'} ',
                ),
                Text(
                  'الوصف: ${item.product?.description ?? 'لا يوجد وصف'}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
