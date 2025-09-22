import 'package:buyzoonapp/features/report/data/model/refunded_report_orders_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RefundedOrdersPage extends StatelessWidget {
  final List<RefundedOrdersModel> orders;
  const RefundedOrdersPage({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الطلبات المرتجعة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: orders.isEmpty
          ? const Center(child: Text('لا توجد طلبات مرتجعة في هذا التقرير.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'رقم الفاتورة: ${order.invoiceNumber ?? 'غير متوفر'}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'المستخدم: ${order.user?.username ?? 'مستخدم غير معروف'}',
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'الحالة: ${order.paymentStatus}',
                              style: const TextStyle(color: Colors.red),
                            ),
                            Text(
                              'الإجمالي: ${order.totalPrice.toStringAsFixed(2)} \$',
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'تاريخ الارتجاع: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(order.createdAt))}',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
