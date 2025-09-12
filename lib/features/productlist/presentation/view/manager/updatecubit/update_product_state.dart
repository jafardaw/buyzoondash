// lib/features/productlist/presentation/view/manager/update_cubit/update_product_state.dart

sealed class UpdateProductState {}

final class UpdateProductInitial extends UpdateProductState {}

final class UpdateProductLoading extends UpdateProductState {}

final class UpdateProductSuccess extends UpdateProductState {}

final class UpdateProductFailure extends UpdateProductState {
  final String errorMessage;

  UpdateProductFailure({required this.errorMessage});
}
