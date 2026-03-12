import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tavo/core/constants/app_assets.dart';
import 'package:tavo/core/di/service_locator.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';
import 'package:tavo/feature/home/ui/widgets/restaurant_card.dart';
import 'package:tavo/feature/restaurant/ui/logic/restaurants_cubit.dart';
import 'package:tavo/feature/restaurant/ui/logic/restaurants_state.dart';
import 'package:tavo/feature/restaurant/ui/screens/restaurant_details_screen.dart';
import 'package:tavo/feature/restaurant/ui/widgets/filter_chip.dart';
import 'package:tavo/feature/restaurant/ui/widgets/restaurants_filter_bottom_sheet.dart';

class RestaurantsScreen extends StatelessWidget {
  const RestaurantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    
    return BlocProvider(
      create: (_) => getIt<RestaurantsCubit>(param1: locale)..loadRestaurants(),
      child: const _RestaurantsView(),
    );
  }
}

class _RestaurantsView extends StatelessWidget {
  const _RestaurantsView();

  Future<void> _openFilterSheet(BuildContext context, RestaurantsState state) async {
    final cubit = context.read<RestaurantsCubit>();
    final categories = cubit.getAllCategories();
    
    final result = await showModalBottomSheet<RestaurantsFilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (_) => RestaurantsFilterBottomSheet(
        initialCategory: state.selectedCategory,
        initialMinRating: state.minRating,
        categories: categories,
      ),
    );

    if (result != null) {
      cubit.applyFilters(
        category: result.category,
        minRating: result.minRating,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    
    return BlocBuilder<RestaurantsCubit, RestaurantsState>(
      builder: (context, state) {
        final cubit = context.read<RestaurantsCubit>();

        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _HeaderSection(
                  state: state,
                  cubit: cubit,
                  onFilterTap: () => _openFilterSheet(context, state),
                ),
                Expanded(
                  child: _buildBody(context, state, cubit, locale),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    RestaurantsState state,
    RestaurantsCubit cubit,
    String locale,
  ) {
    if (state.loading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: ColorsManager.primaryColor,
        ),
      );
    }

    if (state.error != null) {
      return _buildErrorWidget(context, state.error!, cubit);
    }

    if (state.visibleRestaurants.isEmpty) {
      return _buildEmptyWidget(context);
    }

    return RefreshIndicator(
      onRefresh: () => cubit.refresh(),
      color: ColorsManager.primaryColor,
      child: GridView.builder(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.68,
        ),
        itemCount: state.visibleRestaurants.length,
        itemBuilder: (context, index) {
          final item = state.visibleRestaurants[index];
          return RestaurantCard(
            restaurant: item,
            locale: locale,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RestaurantDetailsScreen(
                    restaurantId: item.id,  // ✅ Fixed: use restaurantId
                  ),
                ),
              );
            },
            onBookTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RestaurantDetailsScreen(
                    restaurantId: item.id,  // ✅ Fixed: use restaurantId
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget(
    BuildContext context,
    String error,
    RestaurantsCubit cubit,
  ) {
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
              onPressed: () => cubit.loadRestaurants(),
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

  Widget _buildEmptyWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_outlined,
              size: 60.w,
              color: ColorsManager.darkGray300,
            ),
            SizedBox(height: 16.h),
            Text(
              'no_restaurants'.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ColorsManager.darkGray300,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final RestaurantsState state;
  final RestaurantsCubit cubit;
  final VoidCallback onFilterTap;

  const _HeaderSection({
    required this.state,
    required this.cubit,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          _TitleWithCount(
            title: 'restaurants'.tr(),
            count: state.totalCount,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: state.hasAnyFilter
                ? _ActiveFiltersRow(
                    state: state,
                    cubit: cubit,
                    onFilterTap: onFilterTap,
                  )
                : Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: _FilterButton(onTap: onFilterTap),
                  ),
          ),
        ],
      ),
    );
  }
}

class _TitleWithCount extends StatelessWidget {
  final String title;
  final int count;

  const _TitleWithCount({
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyles.font18Black400Weight(context).copyWith(
            color: ColorsManager.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: ColorsManager.secondary100.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Text(
            '$count',
            style: TextStyles.font14Black500Weight(context).copyWith(
              color: ColorsManager.secondary100,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool iconOnly;

  const _FilterButton({
    required this.onTap,
    this.iconOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: iconOnly
            ? EdgeInsets.all(10.r)
            : EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: context.borderColor),
        ),
        child: iconOnly
            ? SvgPicture.asset(
                AppAssets.filter,
                width: 16.r,
                height: 16.r,
                colorFilter: ColorFilter.mode(
                  context.textSecondaryColor,
                  BlendMode.srcIn,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AppAssets.filter,
                    width: 16.r,
                    height: 16.r,
                    colorFilter: ColorFilter.mode(
                      context.textSecondaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'filter'.tr(),
                    style: TextStyles.font12Black400Weight(context).copyWith(
                      color: context.textSecondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _ActiveFiltersRow extends StatelessWidget {
  final RestaurantsState state;
  final RestaurantsCubit cubit;
  final VoidCallback onFilterTap;

  const _ActiveFiltersRow({
    required this.state,
    required this.cubit,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (state.minRating != null) ...[
            ActiveFilterChip(
              onRemove: cubit.clearMinRating,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AppAssets.star,
                    width: 14.r,
                    height: 14.r,
                    colorFilter: const ColorFilter.mode(
                      ColorsManager.secondaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    state.minRating!.toStringAsFixed(1),
                    style: TextStyles.font12Black400Weight(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
          ],
          if (state.selectedCategory != null) ...[
            ActiveFilterChip(
              onRemove: cubit.clearCategory,
              child: Text(
                state.selectedCategory!,
                style: TextStyles.font12Black400Weight(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.textSecondaryColor,
                ),
              ),
            ),
            SizedBox(width: 8.w),
          ],
          _FilterButton(
            onTap: onFilterTap,
            iconOnly: true,
          ),
        ],
      ),
    );
  }
}