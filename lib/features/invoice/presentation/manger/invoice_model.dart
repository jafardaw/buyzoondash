// lib/features/orders/presentation/manger/invoice_state.dart

import 'package:buyzoonapp/features/invoice/data/model/invoice_model.dart';

abstract class InvoiceState {}

class InvoiceInitial extends InvoiceState {}

class InvoiceLoading extends InvoiceState {}

class InvoiceSuccess extends InvoiceState {
  final InvoiceModel invoice;
  InvoiceSuccess(this.invoice);
}

class InvoiceFailure extends InvoiceState {
  final String error;
  InvoiceFailure(this.error);
}
