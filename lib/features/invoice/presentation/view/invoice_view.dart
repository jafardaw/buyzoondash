// lib/features/invoice/presentation/view/invoice_view.dart

import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/core/widget/error_widget_view.dart';
import 'package:buyzoonapp/core/widget/loading_view.dart';
import 'package:buyzoonapp/features/invoice/data/model/invoice_model.dart';
import 'package:buyzoonapp/features/invoice/presentation/manger/invoice_cubit.dart';
import 'package:buyzoonapp/features/invoice/presentation/manger/invoice_model.dart';
import 'package:buyzoonapp/features/invoice/repo/invoice_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

class InvoiceView extends StatelessWidget {
  final int orderId;
  const InvoiceView({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          InvoiceCubit(InvoiceRepo(ApiService()))
            ..fetchInvoice(orderId: orderId),
      child: Scaffold(
        backgroundColor: Palette.backgroundColor,
        appBar: AppareWidget(
          title: 'الفاتورة',
          automaticallyImplyLeading: false,
        ),

        body: BlocBuilder<InvoiceCubit, InvoiceState>(
          builder: (context, state) {
            if (state is InvoiceLoading) {
              return const Center(
                child: LoadingViewWidget(
                  type: LoadingType.imageShake,
                  imagePath:
                      'assest/images/SAVE_٢٠٢٥٠٨٢٩_٢٣٣٣٥١-removebg-preview.png', // مسار صورتك
                  size: 200, // حجم الصورة
                ),
              );
            } else if (state is InvoiceFailure) {
              return ShowErrorWidgetView.fullScreenError(
                errorMessage: state.error,
                onRetry: () {
                  InvoiceCubit(
                    InvoiceRepo(ApiService()),
                  ).fetchInvoice(orderId: orderId);
                },
              );
            } else if (state is InvoiceSuccess) {
              final invoice = state.invoice;
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // قسم معلومات الفاتورة
                    _buildInvoiceHeader(context, invoice),
                    const SizedBox(height: 30),
                    Text(
                      'تفاصيل المنتجات',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildProductTable(context, invoice),
                    const SizedBox(height: 30),
                    // قسم المبلغ الإجمالي
                    _buildTotalCard(context, invoice),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildInvoiceHeader(BuildContext context, invoice) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.receipt_long,
                  color: Palette.primary, // استخدام اللون الرئيسي الجديد
                  size: 30,
                ),
                const SizedBox(width: 15),
                Text(
                  'فاتورة #${invoice.invoiceNumber}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Palette.primary, // استخدام اللون الرئيسي
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Divider(height: 1, thickness: 1, color: Colors.grey),
            const SizedBox(height: 15),
            _buildInfoRow(
              context,
              'الحالة:',
              invoice.status,
              color: invoice.status == 'paid'
                  ? Colors.green.shade700
                  : Colors.red.shade700,
            ),
            const SizedBox(height: 10),
            _buildInfoRow(
              context,
              'تاريخ الدفع:',
              intl.DateFormat(
                'yyyy/MM/dd HH:mm',
              ).format(DateTime.parse(invoice.paidAt)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductTable(BuildContext context, invoice) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProductHeader(context),
            const Divider(height: 20, thickness: 1.5, color: Colors.grey),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: invoice.items.length,
              itemBuilder: (context, index) {
                final item = invoice.items[index];
                return _buildProductItem(
                  context,
                  item.name,
                  item.unitPrice,
                  item.quantity.toString(),
                  item.totalPrice,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCard(BuildContext context, InvoiceModel invoice) {
    return Card(
      elevation: 8,
      color: Palette.secandry, // استخدام اللون الثانوي الجديد
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            _buildTotalRow(context, 'المجموع الفرعي', invoice.totalPrice),
            const SizedBox(height: 10),
            _buildTotalRow(context, 'الضرائب (0%)', '0.00'),
            const SizedBox(height: 15),
            const Divider(height: 1, thickness: 2),
            const SizedBox(height: 15),
            _buildTotalRow(
              context,
              'المبلغ الإجمالي:',
              '${invoice.totalPrice} ل.س',
              isBold: true,
              fontSize: 28,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color ?? Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildProductHeader(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: Text('المنتج', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'السعر الواحد',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'الكمية',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'المجموع',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildProductItem(
    BuildContext context,
    String name,
    String onePrice,
    String quantity,
    String price,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              onePrice,
              style: Theme.of(context).textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              quantity,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              price,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
    double? fontSize,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: fontSize,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,

            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
