// lib/feature/restaurant/ui/logic/menu_item_specification_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tavo/core/network/api_exception.dart';
import 'package:tavo/feature/restaurant/data/model/menu_item_specification_model.dart';
import 'package:tavo/feature/restaurant/data/repo/menu_item_specification_repo.dart';
import 'package:tavo/feature/restaurant/ui/logic/menu_item_specification_state.dart';

class MenuItemSpecificationCubit extends Cubit<MenuItemSpecificationState> {
  final MenuItemSpecificationRepo _repo;
  final String restaurantId;
  final String menuItemId;

  MenuItemSpecificationCubit(
    this._repo, {
    required this.restaurantId,
    required this.menuItemId,
  }) : super(const MenuItemSpecificationState());

  Future<void> loadSpecification() async {
    if (isClosed) return;
    emit(state.copyWith(loading: true, error: null));

    try {
      final spec = await _repo.getSpecification(
        restaurantId: restaurantId,
        menuItemId: menuItemId,
      );
      if (isClosed) return;
      emit(state.copyWith(loading: false, specification: spec));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(loading: false, error: e.message));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void selectSingleOption(String groupKey, SpecificationOption option) {
    final newSelections = Map<String, dynamic>.from(state.selections);
    
    // If same option selected, deselect it
    final current = newSelections[groupKey];
    if (current is SpecificationOption && current.title == option.title) {
      newSelections.remove(groupKey);
    } else {
      newSelections[groupKey] = option;
    }
    
    emit(state.copyWith(selections: newSelections));
  }

  void toggleMultipleOption(String groupKey, SpecificationOption option) {
    final newSelections = Map<String, dynamic>.from(state.selections);
    final current = newSelections[groupKey] as Set<SpecificationOption>? ?? {};
    final newSet = Set<SpecificationOption>.from(current);

    if (newSet.any((o) => o.title == option.title)) {
      newSet.removeWhere((o) => o.title == option.title);
    } else {
      newSet.add(option);
    }

    if (newSet.isEmpty) {
      newSelections.remove(groupKey);
    } else {
      newSelections[groupKey] = newSet;
    }

    emit(state.copyWith(selections: newSelections));
  }

  void incrementQuantity() {
    if (state.quantity < 99) {
      emit(state.copyWith(quantity: state.quantity + 1));
    }
  }

  void decrementQuantity() {
    if (state.quantity > 1) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }

  void updateNotes(String notes) {
    emit(state.copyWith(notes: notes));
  }

  bool isOptionSelected(String groupKey, SpecificationOption option) {
    final selection = state.selections[groupKey];
    if (selection == null) return false;

    if (selection is SpecificationOption) {
      return selection.title == option.title;
    } else if (selection is Set<SpecificationOption>) {
      return selection.any((o) => o.title == option.title);
    }
    return false;
  }

  void clearSelections() {
    emit(state.copyWith(selections: {}, quantity: 1, notes: ''));
  }
}