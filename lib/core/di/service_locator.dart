import 'package:get_it/get_it.dart';
import 'package:tavo/core/cache/cache_helper.dart';
import 'package:tavo/core/network/api_service.dart';

import 'package:tavo/feature/auth/ui/data/repo/auth_repo.dart';
import 'package:tavo/feature/auth/ui/logic/cubit/auth_cubit.dart';
import 'package:tavo/feature/home/data/repo/home_repo.dart';
import 'package:tavo/feature/home/ui/logic/cubit/home_cubit.dart';
import 'package:tavo/feature/restaurant/data/repo/menu_repo.dart';
import 'package:tavo/feature/restaurant/data/repo/restaurant_details_repo.dart';
import 'package:tavo/feature/restaurant/data/repo/restaurants_repo.dart';
import 'package:tavo/feature/restaurant/ui/logic/menu_cubit.dart';
import 'package:tavo/feature/restaurant/ui/logic/restaurant_details_cubit.dart';
import 'package:tavo/feature/restaurant/ui/logic/restaurants_cubit.dart';

final getIt = GetIt.instance;

Future<void> initServiceLocator() async {
  await CacheHelper.init();

  // ── Core ──
  getIt.registerLazySingleton<ApiService>(() => ApiService());

  // ── Repos (ALL of them!) ──
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(getIt<ApiService>()));
  getIt.registerLazySingleton<HomeRepo>(() => HomeRepo(getIt<ApiService>()));                       // ← MISSING
  getIt.registerLazySingleton<RestaurantsRepo>(() => RestaurantsRepo(getIt<ApiService>()));         // ← MISSING
  getIt.registerLazySingleton<RestaurantDetailsRepo>(() => RestaurantDetailsRepo(getIt<ApiService>())); // ← MISSING
  getIt.registerLazySingleton<MenuRepo>(() => MenuRepo(getIt<ApiService>()));                       // ← MISSING

  // ── Cubits ──
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepo>()));
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt<HomeRepo>()));
  getIt.registerFactoryParam<RestaurantsCubit, String, void>(
    (locale, _) => RestaurantsCubit(getIt<RestaurantsRepo>(), locale: locale),
  );
  getIt.registerFactory<RestaurantDetailsCubit>(
    () => RestaurantDetailsCubit(getIt<RestaurantDetailsRepo>()),
  );
  getIt.registerFactoryParam<MenuCubit, String, void>(
    (restaurantId, _) => MenuCubit(getIt<MenuRepo>(), restaurantId: restaurantId),
  );
}