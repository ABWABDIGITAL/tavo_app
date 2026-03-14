// lib/feature/restaurant/ui/logic/menu_item_specification_state.dart
import 'package:tavo/feature/restaurant/data/model/menu_item_specification_model.dart';

class MenuItemSpecificationState {
  final bool loading;
  final MenuItemSpecificationModel? specification;
  final String? error;
  final Map<String, dynamic> selections;
  final int quantity;
  final String notes;

  const MenuItemSpecificationState({
    this.loading = false,
    this.specification,
    this.error,
    this.selections = const {},
    this.quantity = 1,
    this.notes = '',
  });

  double get basePrice => specification?.price ?? 0;

  double get additionalPrice {
    double additional = 0;
    selections.forEach((key, value) {
      if (value is SpecificationOption) {
        additional += value.price;
      } else if (value is Set<SpecificationOption>) {
        for (final option in value) {
          additional += option.price;
        }
      }
    });
    return additional;
  }

  double get unitPrice => basePrice + additionalPrice;

  double get totalPrice => unitPrice * quantity;

  int get selectedOptionsCount {
    int count = 0;
    selections.forEach((key, value) {
      if (value is SpecificationOption) {
        count++;
      } else if (value is Set<SpecificationOption>) {
        count += value.length;
      }
    });
    return count;
  }

  MenuItemSpecificationState copyWith({
    bool? loading,
    MenuItemSpecificationModel? specification,
    String? error,
    Map<String, dynamic>? selections,
    int? quantity,
    String? notes,
  }) {
    return MenuItemSpecificationState(
      loading: loading ?? this.loading,
      specification: specification ?? this.specification,
      error: error,
      selections: selections ?? this.selections,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }
}