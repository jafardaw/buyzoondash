// lib/features/financial_report/presentation/view/top_products_page.dart

import 'package:buyzoonapp/features/report/data/model/top_report_products_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TopProductsPage extends StatefulWidget {
  final List<TopReportProductsModel> products;
  const TopProductsPage({super.key, required this.products});

  @override
  State<TopProductsPage> createState() => _TopProductsPageState();
}

class _TopProductsPageState extends State<TopProductsPage> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.products.isEmpty
          ? const Center(child: Text('لا توجد منتجات في هذا التقرير.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // المخطط الدائري في أعلى الصفحة
                  _buildTopProductsChart(context, widget.products),
                  const SizedBox(height: 24),
                  const Text(
                    'قائمة المنتجات الكاملة:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  // قائمة المنتجات التفصيلية
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.products.length,
                    itemBuilder: (context, index) {
                      final product = widget.products[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: const Icon(
                            Icons.shopping_bag_outlined,
                            size: 40,
                          ),
                          title: Text(
                            product.product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('الكمية المباعة: ${product.quantity}'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('إجمالي المبيعات'),
                              Text(
                                '${product.totalSales.toStringAsFixed(2)} \$',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTopProductsChart(
    BuildContext context,
    List<TopReportProductsModel> products,
  ) {
    final topProducts = products.take(5).toList();

    final pieData = topProducts.asMap().entries.map((entry) {
      final index = entry.key;
      final product = entry.value;

      final isTouched = index == _touchedIndex;
      final fontSize = isTouched ? 16.0 : 14.0;
      final radius = isTouched ? 90.0 : 80.0;
      final color = Colors.primaries[index % Colors.primaries.length];

      return PieChartSectionData(
        color: color,
        value: product.totalSales,
        title: isTouched
            ? '${product.product.name}\n(${product.totalSales.toStringAsFixed(1)} \$)'
            : '${product.totalSales.toStringAsFixed(1)} \$',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'أفضل 5 منتجات',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: pieData,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  pieTouchData: PieTouchData(
                    touchCallback:
                        (
                          FlTouchEvent event,
                          PieTouchResponse? pieTouchResponse,
                        ) {
                          setState(() {
                            if (event is FlTapDownEvent ||
                                event is FlLongPressEnd) {
                              if (pieTouchResponse != null &&
                                  pieTouchResponse.touchedSection != null) {
                                _touchedIndex = pieTouchResponse
                                    .touchedSection!
                                    .touchedSectionIndex;
                              } else {
                                _touchedIndex = -1;
                              }
                            }
                          });
                        },
                  ),
                ),
                key: ValueKey(products.hashCode),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: topProducts.asMap().entries.map((entry) {
                final index = entry.key;
                final product = entry.value;
                final color = Colors.primaries[index % Colors.primaries.length];
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 10, height: 10, color: color),
                    const SizedBox(width: 4),
                    Text(
                      product.product.name,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
