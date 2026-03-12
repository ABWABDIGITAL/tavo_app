import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tavo/feature/onboarding/data/onboarding_data.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingState.initial());

  final int totalPages = OnboardingData.pages.length;

  void onPageChanged(int page) {
    emit(state.copyWith(
      currentPage: page,
      isLastPage: page == totalPages - 1,
    ));
  }

  void nextPage() {
    if (state.currentPage < totalPages - 1) {
      final next = state.currentPage + 1;
      emit(state.copyWith(
        currentPage: next,
        isLastPage: next == totalPages - 1,
      ));
    }
  }

  void previousPage() {
    if (state.currentPage > 0) {
      final prev = state.currentPage - 1;
      emit(state.copyWith(
        currentPage: prev,
        isLastPage: false,
      ));
    }
  }
}
