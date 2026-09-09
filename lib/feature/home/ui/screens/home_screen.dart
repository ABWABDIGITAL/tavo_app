import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/di/service_locator.dart';
import 'package:tavo/core/theme/colors.dart';

import 'package:tavo/feature/home/ui/logic/cubit/home_cubit.dart';
import 'package:tavo/feature/home/ui/logic/cubit/home_state.dart';
import 'package:tavo/feature/home/ui/widgets/category_chips.dart';
import 'package:tavo/feature/home/ui/widgets/home_header.dart';
import 'package:tavo/feature/home/ui/widgets/home_shimmer_loading.dart';
import 'package:tavo/feature/home/ui/widgets/promo_banner.dart';
import 'package:tavo/feature/home/ui/widgets/restaurant_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubit>()..getHome(),
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const HomeShimmerLoading();
          }

          if (state is HomeError) {
            return _buildErrorWidget(context, state.error);
          }

          if (state is HomeSuccess) {
            return _buildContent(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 60.w,
              color: ColorsManager.darkGray300,
            ),
            SizedBox(height: 16.h),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                context.read<HomeCubit>().getHome();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'retry'.tr(),
                style: const TextStyle(color: ColorsManager.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeSuccess state) {
    final locale = context.locale.languageCode;

    return RefreshIndicator(
      onRefresh: () => context.read<HomeCubit>().refresh(),
      color: ColorsManager.primaryColor,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _HomeHeaderDelegate(maxExtent: 205.h, minExtent: 205.h),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.h, top: 20.h),
              child: PromoBanner(heroes: state.heroes),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: CategoryChips(
                categories: state.categories,
                selectedCategoryId: state.selectedCategoryId,
                onCategorySelected: (categoryId) {
                  context.read<HomeCubit>().selectCategory(categoryId);
                },
              ),
            ),
          ),
          if (state.filteredRestaurants.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(40.w),
                child: Center(
                  child: Text(
                    'no_restaurants'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ColorsManager.darkGray300,
                    ),
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.68,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final restaurant = state.filteredRestaurants[index];
                  return RestaurantCard(restaurant: restaurant, locale: locale);
                }, childCount: state.filteredRestaurants.length),
              ),
            ),
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
        ],
      ),
    );
  }
}

class _HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  final double maxExtent;

  @override
  final double minExtent;

  _HomeHeaderDelegate({required this.maxExtent, required this.minExtent});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return HomeHeader(shrinkOffset: shrinkOffset, maxExtent: maxExtent);
  }

  @override
  bool shouldRebuild(covariant _HomeHeaderDelegate oldDelegate) {
    return maxExtent != oldDelegate.maxExtent ||
        minExtent != oldDelegate.minExtent;
  }
}
