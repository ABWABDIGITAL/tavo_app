import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tavo/core/constants/app_assets.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';
import 'package:tavo/feature/home/data/models/restaurant_model.dart';
import 'package:tavo/feature/restaurant/ui/screens/restaurant_details_screen.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final String locale;
  final VoidCallback? onTap;
  final VoidCallback? onBookTap;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.locale,
    this.onTap,
    this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12.r);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap ??
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RestaurantDetailsScreen(
                    restaurantId: restaurant.id,
                  ),
                ),
              );
            },
        child: Container(
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: radius,
            border: Border.all(color: context.borderColor),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(2.w),
                child: AspectRatio(
                  aspectRatio: 11 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: restaurant.getFirstImageUrl(),
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: ColorsManager.grey100,
                              child: const Center(
                                child: CircularProgressIndicator.adaptive(
                                  backgroundColor: ColorsManager.primaryColor,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              color: ColorsManager.grey100,
                              child: Icon(
                                Icons.restaurant,
                                size: 40.w,
                                color: ColorsManager.darkGray300,
                              ),
                            ),
                          ),
                          PositionedDirectional(
                            top: 6.h,
                            start: 6.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: ColorsManager.white.withValues(alpha: 0.95),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    AppAssets.star,
                                    width: 11.w,
                                    height: 11.w,
                                    colorFilter: const ColorFilter.mode(
                                      ColorsManager.primaryColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    restaurant.ratingsAverage.toStringAsFixed(1),
                                    style: TextStyles.font10DarkGray400Weight(context).copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: ColorsManager.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (restaurant.categories.isNotEmpty)
                            PositionedDirectional(
                              top: 6.h,
                              end: 6.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorsManager.secondaryColor.withValues(alpha: 0.92),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  restaurant.getFirstCategoryName(locale),
                                  style: TextStyles.font10DarkGray400Weight(context).copyWith(
                                    color: ColorsManager.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.getName(locale),
                      style: TextStyles.font14Black500Weight(context).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppAssets.location,
                          width: 12.w,
                          height: 12.w,
                          colorFilter: ColorFilter.mode(
                            context.textSecondaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            restaurant.getAddress(locale),
                            style: TextStyles.font10DarkGray400Weight(context),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    InkWell(
                      borderRadius: BorderRadius.circular(32.r),
                      onTap: onBookTap ??
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RestaurantDetailsScreen(
                                  restaurantId: restaurant.id,
                                ),
                              ),
                            );
                          },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32.r),
                          color: ColorsManager.primaryColor.withValues(alpha: 0.12),
                        ),
                        child: Center(
                          child: Text(
                            'book'.tr(),
                            style: TextStyles.font14Blue400Weight(context).copyWith(
                              color: ColorsManager.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}