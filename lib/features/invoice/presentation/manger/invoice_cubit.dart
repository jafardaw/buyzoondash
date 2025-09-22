import 'package:buyzoonapp/features/invoice/presentation/manger/invoice_model.dart';
import 'package:buyzoonapp/features/invoice/repo/invoice_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoiceCubit extends Cubit<InvoiceState> {
  final InvoiceRepo _orderRepo;

  InvoiceCubit(this._orderRepo) : super(InvoiceInitial());

  Future<void> fetchInvoice({required int orderId}) async {
    emit(InvoiceLoading());
    try {
      final invoice = await _orderRepo.getInvoice(orderId: orderId);
      emit(InvoiceSuccess(invoice));
    } catch (e) {
      emit(InvoiceFailure(e.toString()));
    }
  }
}
