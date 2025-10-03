import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/core/widget/error_widget_view.dart';
import 'package:buyzoonapp/core/widget/loading_view.dart';
import 'package:buyzoonapp/features/report/data/model/financial_report_report_model.dart';
import 'package:buyzoonapp/features/report/data/model/top_report_products_model.dart';
import 'package:buyzoonapp/features/report/data/model/top_report_users_model.dart';
import 'package:buyzoonapp/features/report/presentation/manger/financial_report_cubit.dart';
import 'package:buyzoonapp/features/report/presentation/manger/financial_report_state.dart';
import 'package:buyzoonapp/features/report/presentation/view/widget/refunded_orders_page.dart';
import 'package:buyzoonapp/features/report/presentation/view/widget/top_products_page.dart';
import 'package:buyzoonapp/features/report/presentation/view/widget/top_users_page.dart';
import 'package:buyzoonapp/features/report/repo/financial_repo.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FinancialDashboardPage extends StatelessWidget {
  const FinancialDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final now = DateTime.now();
        final lastMonth = now.subtract(const Duration(days: 30));
        return FinancialReportCubit(FinancialRepo(ApiService()))
          ..getFinancialReport(
            timeline: 'monthly',
            from: DateFormat('yyyy-MM-dd').format(lastMonth),
            to: DateFormat('yyyy-MM-dd').format(now),
          );
      },
      child: Scaffold(
        appBar: AppareWidget(
          title: 'لوحة التحكم المالية',
          automaticallyImplyLeading: false,
        ),

        body: BlocBuilder<FinancialReportCubit, FinancialReportState>(
          builder: (context, state) {
            if (state is FinancialReportLoading) {
              return const LoadingViewWidget(
                type: LoadingType.imageShake,
                imagePath:
                    'assest/images/SAVE_٢٠٢٥٠٨٢٩_٢٣٣٣٥١-removebg-preview.png', // مسار صورتك
                size: 200, // حجم الصورة
              );
            } else if (state is FinancialReportFailure) {
              final now = DateTime.now();
              final lastMonth = now.subtract(const Duration(days: 30));
              return ShowErrorWidgetView.fullScreenError(
                errorMessage: state.error,
                onRetry: () {
                  context.read<FinancialReportCubit>().getFinancialReport(
                    timeline: 'monthly',
                    from: DateFormat('yyyy-MM-dd').format(lastMonth),
                    to: DateFormat('yyyy-MM-dd').format(now),
                  );
                },
              );
            } else if (state is FinancialReportSuccess) {
              final report = state.report;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // فلتر التاريخ
                    _buildDateFilter(context),
                    const SizedBox(height: 24),

                    // قسم المؤشرات الرئيسية (KPIs)
                    _buildKpiSection(context, report),
                    const SizedBox(height: 24),

                    // قسم أفضل المستخدمين (Chart)
                    _buildTopUsersChart(context, report.topUsers),
                    const SizedBox(height: 24),

                    _buildListPreviews(context, report),
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

  Widget _buildDateFilter(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Card(
      elevation: 7,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        // هنا نقوم باختيار الويدجت المناسب حسب حجم الشاشة
        child: isSmallScreen
            ? filterDateSmullScreen(context)
            : flterDateLargSreen(context),
      ),
    );
  }

  Column filterDateSmullScreen(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'الفترة الزمنية: ${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 30)))} - ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () async {
            // ... (نفس الكود السابق لفتح محدد التاريخ)
            final DateTimeRange? picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2024),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              final String from = DateFormat('yyyy-MM-dd').format(picked.start);
              final String to = DateFormat('yyyy-MM-dd').format(picked.end);
              if (context.mounted) {
                context.read<FinancialReportCubit>().getFinancialReport(
                  timeline: 'custom',
                  from: from,
                  to: to,
                );
              }
            }
          },
          icon: const Icon(Icons.calendar_today, size: 20),
          label: const Text('تغيير'),
        ),
      ],
    );
  }

  Row flterDateLargSreen(BuildContext context) {
    return Row(
      // تصميم أفقي للشاشات الأكبر
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'الفترة الزمنية: ${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 30)))} - ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        TextButton.icon(
          onPressed: () async {
            final DateTimeRange? picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2024),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              final String from = DateFormat('yyyy-MM-dd').format(picked.start);
              final String to = DateFormat('yyyy-MM-dd').format(picked.end);
              if (context.mounted) {
                context.read<FinancialReportCubit>().getFinancialReport(
                  timeline: 'custom',
                  from: from,
                  to: to,
                );
              }
            }
          },
          icon: const Icon(Icons.calendar_today, size: 20),
          label: const Text('تغيير'),
        ),
      ],
    );
  }

  Widget _buildKpiSection(BuildContext context, FinancialReportModel report) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildKpiCard(
          context,
          'الإيرادات',
          '${report.totalRevenue.toStringAsFixed(3)} ',
          Colors.green,
        ),
        _buildKpiCard(
          context,
          'الأرباح',
          '${report.totalProfit.toStringAsFixed(3)} ',
          Colors.blue,
        ),
        _buildKpiCard(
          context,
          'طلبات تم تسليمها',
          report.deliveredCount.toString(),
          Colors.purple,
        ),
        _buildKpiCard(
          context,
          'طلبات ملغاة',
          report.cancelledCount.toString(),
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildKpiCard(
    BuildContext context,
    String title,
    String value,
    Color color,
  ) {
    return SizedBox(
      width:
          (MediaQuery.of(context).size.width / 2) -
          24, // تصميم ليناسب شاشتين في الصف
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopUsersChart(
    BuildContext context,
    List<TopReportUsersModel> users,
  ) {
    // تأكد من أن القائمة ليست فارغة قبل محاولة عرضها
    if (users.isEmpty) {
      return const SizedBox.shrink();
    }

    final topUsers = users.take(6).toList();

    final barGroups = topUsers.asMap().entries.map((entry) {
      final index = entry.key;
      final user = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: user.totalSpent,
            color: Palette.secandry,
            width: 20,
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      );
    }).toList();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'أفضل المستخدمين',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < topUsers.length) {
                            // تأكد من استخدام model الصحيح للوصول إلى اسم المستخدم
                            return Text(
                              topUsers[value.toInt()].user.username ?? '',
                              style: const TextStyle(fontSize: 10),
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListPreviews(BuildContext context, FinancialReportModel report) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildListPreviewCard(
          context,
          'أفضل المستخدمين',
          report.topUsers.isNotEmpty
              ? '${report.topUsers.first.user.username} (إنفاق: ${report.topUsers.first.totalSpent.toStringAsFixed(2)} \$)'
              : 'لا يوجد مستخدمون.',
          Icons.person_pin_outlined,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TopUsersPage(users: report.topUsers),
              ),
            );
          },
        ),
        _buildListPreviewCard(
          context,
          'أفضل المنتجات',
          report.topProducts.isNotEmpty
              ? '${report.topProducts.first.product.name} (مبيعات: ${report.topProducts.first.totalSales.toStringAsFixed(2)} \$)'
              : 'لا توجد منتجات.',
          Icons.shopping_bag_outlined,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    TopProductsPage(products: report.topProducts),
              ),
            );
          },
        ),
        _buildListPreviewCard(
          context,
          'الطلبات المرتجعة',
          '${report.refundedOrders.length} طلب مرتجع',
          Icons.refresh,
          onTap: () {
            // ربط الزر بالصفحة الجديدة وتمرير البيانات
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    RefundedOrdersPage(orders: report.refundedOrders),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildListPreviewCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
