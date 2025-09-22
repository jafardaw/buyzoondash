import 'package:buyzoonapp/features/location/Governorates/data/model/governorate_model.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/manger/governorates_list_state.dart';
import 'package:buyzoonapp/features/location/Governorates/repo/governorate_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GovernoratesListCubit extends Cubit<GovernoratesListState> {
  final GovernorateRepo _governorateRepo;
  int _currentPage = 1;

  GovernoratesListCubit(this._governorateRepo)
    : super(GovernoratesListInitial());

  Future<void> fetchGovernorates() async {
    if (state is GovernoratesListLoading) return;
    emit(GovernoratesListLoading());
    try {
      final response = await _governorateRepo.getGovernorates(
        page: _currentPage,
      );
      final hasNextPage = response.nextPageUrl != null;
      if (!isClosed) {
        emit(
          GovernoratesListSuccess(
            governorates: response.governorates,
            hasNextPage: hasNextPage,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(GovernoratesListFailure(e.toString()));
      }
    }
  }

  Future<void> loadMoreGovernorates() async {
    final currentState = state;
    if (currentState is GovernoratesListSuccess && currentState.hasNextPage) {
      _currentPage++;
      try {
        final response = await _governorateRepo.getGovernorates(
          page: _currentPage,
        );
        final newGovernorates = List<GovernorateModel>.from(
          currentState.governorates,
        )..addAll(response.governorates);
        final hasNextPage = response.nextPageUrl != null;
        if (!isClosed) {
          emit(
            GovernoratesListSuccess(
              governorates: newGovernorates,
              hasNextPage: hasNextPage,
            ),
          );
        }
      } catch (e) {
        if (!isClosed) {
          emit(GovernoratesListFailure('فشل تحميل المزيد: ${e.toString()}'));
        }
      }
    }
  }

  Future<void> deleteGovernorate(int id) async {
    try {
      await _governorateRepo.deleteGovernorate(id: id);
      await fetchGovernorates();
    } catch (e) {}
  }
}
