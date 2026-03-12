import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tavo/feature/home/data/repo/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;

  HomeCubit(this._homeRepo) : super(HomeInitial());

  Future<void> getHome() async {
    emit(HomeLoading());
    try {
      final response = await _homeRepo.getHome();
      if (response.success && response.data != null) {
        emit(HomeSuccess(
          heroes: response.data!.hero,
          categories: response.data!.categories,
          restaurants: response.data!.restaurants,
        ));
      } else {
        emit(HomeError(response.message ?? 'Failed to load home'));
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void selectCategory(String? categoryId) {
    final currentState = state;
    if (currentState is HomeSuccess) {
      if (categoryId == null) {
        emit(currentState.copyWith(clearCategory: true));
      } else {
        emit(currentState.copyWith(selectedCategoryId: categoryId));
      }
    }
  }

  Future<void> refresh() async {
    await getHome();
  }
}