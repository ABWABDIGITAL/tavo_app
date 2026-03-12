
import 'package:tavo/feature/home/data/models/category_model.dart';
import 'package:tavo/feature/home/data/models/hero_model.dart';
import 'package:tavo/feature/home/data/models/restaurant_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<HeroModel> heroes;
  final List<CategoryModel> categories;
  final List<RestaurantModel> restaurants;
  final String? selectedCategoryId;

  HomeSuccess({
    required this.heroes,
    required this.categories,
    required this.restaurants,
    this.selectedCategoryId,
  });

  List<RestaurantModel> get filteredRestaurants {
    if (selectedCategoryId == null) return restaurants;
    return restaurants.where((r) {
      return r.categories.any((c) => c.id == selectedCategoryId);
    }).toList();
  }

  HomeSuccess copyWith({
    List<HeroModel>? heroes,
    List<CategoryModel>? categories,
    List<RestaurantModel>? restaurants,
    String? selectedCategoryId,
    bool clearCategory = false,
  }) {
    return HomeSuccess(
      heroes: heroes ?? this.heroes,
      categories: categories ?? this.categories,
      restaurants: restaurants ?? this.restaurants,
      selectedCategoryId: clearCategory ? null : (selectedCategoryId ?? this.selectedCategoryId),
    );
  }
}

class HomeError extends HomeState {
  final String error;
  HomeError(this.error);
}