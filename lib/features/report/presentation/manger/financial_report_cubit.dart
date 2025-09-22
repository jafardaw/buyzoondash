import 'package:buyzoonapp/features/report/presentation/manger/financial_report_state.dart';
import 'package:buyzoonapp/features/report/repo/financial_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FinancialReportCubit extends Cubit<FinancialReportState> {
  final FinancialRepo _financialRepo;

  FinancialReportCubit(this._financialRepo) : super(FinancialReportInitial());

  Future<void> getFinancialReport({
    required String timeline,
    required String from,
    required String to,
  }) async {
    emit(FinancialReportLoading());
    try {
      final report = await _financialRepo.getFinancialReport(
        timeline: timeline,
        from: from,
        to: to,
      );
      emit(FinancialReportSuccess(report));
    } catch (e) {
      emit(FinancialReportFailure(e.toString()));
    }
  }
}
