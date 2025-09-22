import 'package:buyzoonapp/features/report/data/model/refunded_report_orders_model.dart';
import 'package:buyzoonapp/features/report/data/model/top_report_products_model.dart';
import 'package:buyzoonapp/features/report/data/model/top_report_users_model.dart';

class FinancialReportModel {
  final String timeline;
  final int deliveredCount;
  final int cancelledCount;
  final double totalRevenue;
  final double totalProfit;
  final double profitPercent;
  final List<TopReportUsersModel> topUsers;
  final List<TopReportProductsModel> topProducts;
  final List<dynamic> topCities; // (يمكننا إنشاء نموذج مفصل لاحقًا)
  final List<dynamic> topGovernorates; // (يمكننا إنشاء نموذج مفصل لاحقًا)
  final List<RefundedOrdersModel> refundedOrders;

  FinancialReportModel({
    required this.timeline,
    required this.deliveredCount,
    required this.cancelledCount,
    required this.totalRevenue,
    required this.totalProfit,
    required this.profitPercent,
    required this.topUsers,
    required this.topProducts,
    required this.topCities,
    required this.topGovernorates,
    required this.refundedOrders,
  });

  factory FinancialReportModel.fromJson(Map<String, dynamic> json) {
    return FinancialReportModel(
      timeline: json['timeline'] as String,
      deliveredCount: json['delivered_count'] as int,
      cancelledCount: json['cancelled_count'] as int,
      totalRevenue: json['total_revenue'] as double,
      totalProfit: json['total_profit'] as double,
      profitPercent: json['profit_percent'] as double,
      topUsers: (json['top_users'] as List)
          .map((e) => TopReportUsersModel.fromJson(e))
          .toList(),
      topProducts: (json['top_products'] as List)
          .map((e) => TopReportProductsModel.fromJson(e))
          .toList(),
      topCities: json['top_cities'] as List,
      topGovernorates: json['top_governorates'] as List,
      refundedOrders: (json['refunded_orders'] as List)
          .map((e) => RefundedOrdersModel.fromJson(e))
          .toList(),
    );
  }
}
