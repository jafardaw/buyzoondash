import 'package:buyzoonapp/features/report/data/model/financial_report_report_model.dart';

abstract class FinancialReportState {}

class FinancialReportInitial extends FinancialReportState {}

class FinancialReportLoading extends FinancialReportState {}

class FinancialReportSuccess extends FinancialReportState {
  final FinancialReportModel report;
  FinancialReportSuccess(this.report);
}

class FinancialReportFailure extends FinancialReportState {
  final String error;
  FinancialReportFailure(this.error);
}
