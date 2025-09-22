// lib/features/governorates/presentation/manger/governorates_list_state.dart

import 'package:buyzoonapp/features/location/Governorates/data/model/governorate_model.dart';

abstract class GovernoratesListState {}

class GovernoratesListInitial extends GovernoratesListState {}

class GovernoratesListLoading extends GovernoratesListState {}

class GovernoratesListSuccess extends GovernoratesListState {
  final List<GovernorateModel> governorates;
  final bool hasNextPage;

  GovernoratesListSuccess({
    required this.governorates,
    required this.hasNextPage,
  });
}

class GovernoratesListFailure extends GovernoratesListState {
  final String error;
  GovernoratesListFailure(this.error);
}
