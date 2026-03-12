import 'package:tavo/feature/home/data/models/restaurant_model.dart';


class RestaurantsState {
  final List<RestaurantModel> restaurants;
  final List<RestaurantModel> filteredRestaurants;
  final bool loading;
  final String? error;
  final String? selectedCategory;
  final String? selectedCategoryId;
  final double? minRating;

  const RestaurantsState({
    this.restaurants = const [],
    this.filteredRestaurants = const [],
    this.loading = false,
    this.error,
    this.selectedCategory,
    this.selectedCategoryId,
    this.minRating,
  });

  List<RestaurantModel> get visibleRestaurants => filteredRestaurants;

  int get totalCount => filteredRestaurants.length;

  bool get hasAnyFilter => selectedCategory != null || minRating != null;

  RestaurantsState copyWith({
    List<RestaurantModel>? restaurants,
    List<RestaurantModel>? filteredRestaurants,
    bool? loading,
    String? error,
    String? selectedCategory,
    String? selectedCategoryId,
    double? minRating,
    bool clearCategory = false,
    bool clearRating = false,
    bool clearError = false,
  }) {
    return RestaurantsState(
      restaurants: restaurants ?? this.restaurants,
      filteredRestaurants: filteredRestaurants ?? this.filteredRestaurants,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      selectedCategoryId: clearCategory ? null : (selectedCategoryId ?? this.selectedCategoryId),
      minRating: clearRating ? null : (minRating ?? this.minRating),
    );
  }
}