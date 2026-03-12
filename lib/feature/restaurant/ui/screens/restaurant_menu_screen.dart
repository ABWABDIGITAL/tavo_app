import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/di/service_locator.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';
import 'package:tavo/core/widgets/primary/my_svg.dart';

import 'package:tavo/feature/restaurant/ui/logic/menu_cubit.dart';
import 'package:tavo/feature/restaurant/ui/logic/menu_state.dart';
import 'package:tavo/feature/restaurant/ui/widgets/bottom_booking_bar.dart';
import 'package:tavo/feature/restaurant/ui/widgets/menu_item_card.dart';

class RestaurantMenuScreen extends StatelessWidget {
  final String restaurantId;

  const RestaurantMenuScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MenuCubit>(param1: restaurantId)..loadMenu(),
      child: const _RestaurantMenuView(),
    );
  }
}

class _RestaurantMenuView extends StatelessWidget {
  const _RestaurantMenuView();

  List<BottomCartLine> _mapCartLines(MenuState state) {
    final lines = <BottomCartLine>[];
    for (final item in state.items) {
      final q = state.cart[item.id] ?? 0;
      if (q > 0) {
        lines.add(BottomCartLine(id: item.id, imageUrl: item.imageUrl, qty: q));
      }
    }
    return lines;
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;

    return BlocBuilder<MenuCubit, MenuState>(
      builder: (context, state) {
        final cubit = context.read<MenuCubit>();
        final cartLines = _mapCartLines(state);
        final showBottomBar = state.hasItemsInCart;

        return Scaffold(
      
          body: SafeArea(
            bottom: !showBottomBar,
            child: Column(
              children: [
                // Header
                _buildHeader(context),
                
                // Categories
                if (state.categories.isNotEmpty)
                  _buildCategoriesRow(context, state, cubit, locale),
                
                SizedBox(height: 14.h),
                
                // Content
                Expanded(
                  child: _buildContent(context, state, cubit, locale),
                ),
              ],
            ),
          ),
          bottomNavigationBar: showBottomBar
              ? BottomBookingBar(
                  onPressed: () {},
                  buttonTextKey: 'book_your_seat'.tr(),
                  total: state.total,
                  cartLines: cartLines,
                  onAddItem: cubit.add,
                  onRemoveItem: cubit.remove,
                )
              : null,
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: const BoxDecoration(
              color: ColorsManager.grey100,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const MySvg(image: 'arrow_right'),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            'menu'.tr(),
            style: TextStyles.font16Black500Weight(context),
          ),
          const Spacer(),
          SizedBox(width: 40.r),
        ],
      ),
    );
  }

  Widget _buildCategoriesRow(
    BuildContext context,
    MenuState state,
    MenuCubit cubit,
    String locale,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: SizedBox(
        height: 36.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: state.categories.length + 1,
          separatorBuilder: (_, __) => SizedBox(width: 10.w),
          itemBuilder: (_, i) {
            if (i == 0) {
              return _CategoryChip(
                text: 'all'.tr(),
                selected: state.selectedCategoryId == null,
                onTap: () => cubit.selectCategory(null),
              );
            }
            
            final category = state.categories[i - 1];
            final isSelected = state.selectedCategoryId == category.id;
            
            return _CategoryChip(
              text: category.getName(locale),
              selected: isSelected,
              onTap: () => cubit.selectCategory(category.id),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    MenuState state,
    MenuCubit cubit,
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

    if (state.filteredItems.isEmpty) {
      return _buildEmptyWidget(context);
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.pixels >= notification.metrics.maxScrollExtent - 100) {
          cubit.loadMoreItems();
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () => cubit.refresh(),
        color: ColorsManager.primaryColor,
        child: GridView.builder(
          padding: EdgeInsets.fromLTRB(
            16.w,
            0,
            16.w,
            state.hasItemsInCart ? 120.h : 16.h,
          ),
          itemCount: state.filteredItems.length + (state.loadingMore ? 1 : 0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.78,
          ),
          itemBuilder: (_, i) {
            if (i >= state.filteredItems.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: ColorsManager.primaryColor,
                    strokeWidth: 2,
                  ),
                ),
              );
            }
            
            final item = state.filteredItems[i];
            return MenuItemCard(
              item: item,
              locale: locale,
              qty: state.qty(item.id),
              onAdd: () => cubit.add(item.id),
              onRemove: () => cubit.remove(item.id),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error, MenuCubit cubit) {
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
              onPressed: () => cubit.loadMenu(),
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
              Icons.restaurant_menu,
              size: 60.w,
              color: ColorsManager.darkGray300,
            ),
            SizedBox(height: 16.h),
            Text(
              'no_menu_items'.tr(),
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

class _CategoryChip extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected ? ColorsManager.secondary100 : ColorsManager.grey100,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyles.font14DarkGray400Weight(context).copyWith(
              color: selected ? ColorsManager.white : ColorsManager.black,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}