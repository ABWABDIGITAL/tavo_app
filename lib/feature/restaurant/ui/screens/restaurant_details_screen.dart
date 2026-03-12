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
import 'package:tavo/feature/restaurant/data/model/restaurant_details_model.dart';

import 'package:tavo/feature/restaurant/ui/logic/restaurant_details_cubit.dart';
import 'package:tavo/feature/restaurant/ui/logic/restaurant_details_state.dart';
import 'package:tavo/feature/restaurant/ui/screens/restaurant_map_screen.dart';
import 'package:tavo/feature/restaurant/ui/screens/restaurant_menu_screen.dart';
import 'package:tavo/feature/restaurant/ui/widgets/bottom_booking_bar.dart';
import 'package:tavo/feature/restaurant/ui/widgets/menu_item_card.dart';
import 'package:tavo/feature/restaurant/ui/widgets/restaurant_details_header.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  final String restaurantId;

  const RestaurantDetailsScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RestaurantDetailsCubit>()..loadRestaurantDetails(restaurantId),
      child: _RestaurantDetailsView(restaurantId: restaurantId),
    );
  }
}

class _RestaurantDetailsView extends StatelessWidget {
  final String restaurantId;

  const _RestaurantDetailsView({required this.restaurantId});

  List<BottomCartLine> _mapCartLines(RestaurantDetailsState state) {
    final lines = <BottomCartLine>[];
    for (final item in state.menu) {
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

    return BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
      builder: (context, state) {
        if (state.loading) {
          return Scaffold(
  
            body: const Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: ColorsManager.primaryColor,
              ),
            ),
          );
        }

        if (state.error != null) {
          return Scaffold(
           
            body: _buildErrorWidget(context, state.error!),
          );
        }

        final restaurant = state.restaurant;
        if (restaurant == null) {
          return Scaffold(
        
            body: Center(
              child: Text('restaurant_not_found'.tr()),
            ),
          );
        }

        final cubit = context.read<RestaurantDetailsCubit>();
        final cartLines = _mapCartLines(state);

        return Scaffold(
 
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  RestaurantDetailsHeader(
                    restaurant: restaurant,
                    locale: locale,
                    onBack: () => Navigator.of(context).maybePop(),
                    galleryImages: restaurant.getAllImageUrls(),
                    selectedIndex: state.selectedImageIndex,
                    onImageSelected: cubit.selectImage,
                  ),
                  
                  // Description
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Text(
                      restaurant.getDescription(locale),
                      style: TextStyles.font14DarkGray400Weight(context),
                    ),
                  ),
                  
                  // Address & Map
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AppAssets.location,
                          width: 18.r,
                          height: 18.r,
                          colorFilter: ColorFilter.mode(
                            context.textSecondaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            restaurant.getAddress(locale),
                            style: TextStyles.font12DarkGray400Weight(context).copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RestaurantMapScreen(
                                  title: restaurant.getName(locale),
                                  lat: 24.7136,
                                  lng: 46.6753,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: ColorsManager.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  AppAssets.mapsLocation,
                                  width: 18.r,
                                  height: 18.r,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'view_on_map'.tr(),
                                  style: TextStyles.font14Blue500Weight(context).copyWith(
                                    color: ColorsManager.secondary100,
                                    decoration: TextDecoration.underline,
                                    decorationColor: ColorsManager.secondary100,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Info Row
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _InfoIconText(
                          icon: AppAssets.chair,
                          text: '${restaurant.availableSeats} ${'seats_available'.tr()}',
                        ),
                        _InfoIconText(
                          icon: AppAssets.phone,
                          text: restaurant.phone,
                        ),
                        _InfoIconText(
                          icon: AppAssets.clock,
                          text: restaurant.isOpen ? 'open_now'.tr() : 'closed'.tr(),
                        ),
                      ],
                    ),
                  ),
                  
                  // Working Hours
                  if (restaurant.workingHours.isNotEmpty) ...[
                    SizedBox(height: 16.h),
                    _WorkingHoursSection(
                      workingHours: restaurant.workingHours,
                      locale: locale,
                    ),
                  ],
                  
                  // Menu Section
                  if (state.menu.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
                      child: Row(
                        children: [
                          Text('🔥', style: TextStyles.font16Black500Weight(context)),
                          SizedBox(width: 8.w),
                          Text(
                            'menu'.tr(),
                            style: TextStyles.font16Black500Weight(context).copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => RestaurantMenuScreen(
                                    restaurantId: restaurantId,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'view_all'.tr(),
                              style: TextStyles.font14Blue400Weight(context).copyWith(
                                color: ColorsManager.secondary100,
                                decoration: TextDecoration.underline,
                                decorationColor: ColorsManager.secondary100,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.menu.length >= 4 ? 4 : state.menu.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: 0.78,
                        ),
                        itemBuilder: (_, i) {
                          final item = state.menu[i];
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
                  ],
                  
                  SizedBox(height: 90.h),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomBookingBar(
            onPressed: () {},
            buttonTextKey: 'book_your_seat'.tr(),
            total: state.total,
            cartLines: cartLines,
            onAddItem: cubit.add,
            onRemoveItem: cubit.remove,
          ),
        );
      },
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
                context.read<RestaurantDetailsCubit>().loadRestaurantDetails(restaurantId);
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
}

class _InfoIconText extends StatelessWidget {
  final String icon;
  final String text;

  const _InfoIconText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: 16.r,
            height: 16.r,
            colorFilter: ColorFilter.mode(
              context.textSecondaryColor,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              text,
              style: TextStyles.font12DarkGray400Weight(context).copyWith(
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkingHoursSection extends StatelessWidget {
  final List<WorkingHourModel> workingHours;
  final String locale;

  const _WorkingHoursSection({
    required this.workingHours,
    required this.locale,
  });

  String _todayKey() {
    final now = DateTime.now();
    switch (now.weekday) {
      case 1:
        return 'monday';
      case 2:
        return 'tuesday';
      case 3:
        return 'wednesday';
      case 4:
        return 'thursday';
      case 5:
        return 'friday';
      case 6:
        return 'saturday';
      case 7:
        return 'sunday';
      default:
        return 'monday';
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = _todayKey();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: context.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 16.r,
                  color: ColorsManager.secondary100,
                ),
                SizedBox(width: 6.w),
                Text(
                  'working_hours'.tr(),
                  style: TextStyles.font14Black500Weight(context).copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            ...List.generate(workingHours.length, (index) {
              final hour = workingHours[index];
              final isToday = hour.day.toLowerCase() == today;
              final isClosed = hour.isClosed;

              return Padding(
                padding: EdgeInsets.only(bottom: index == workingHours.length - 1 ? 0 : 6.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            hour.getDayName(locale),
                            style: TextStyles.font12DarkGray400Weight(context).copyWith(
                              fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                              color: isToday
                                  ? ColorsManager.black
                                  : context.textSecondaryColor,
                            ),
                          ),
                          if (isToday) ...[
                            SizedBox(width: 6.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: ColorsManager.secondary100.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                'today'.tr(),
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w600,
                                  color: ColorsManager.secondary100,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Text(
                      isClosed
                          ? 'closed'.tr()
                          : '${hour.openTime} - ${hour.closeTime}',
                      style: TextStyles.font12DarkGray400Weight(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: isClosed
                            ? ColorsManager.redButton
                            : ColorsManager.primaryColor,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}