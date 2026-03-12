import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tavo/core/constants/app_assets.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';
import 'package:tavo/feature/restaurant/data/model/restaurant_details_model.dart';


class RestaurantDetailsHeader extends StatelessWidget {
  final RestaurantDetailsModel restaurant;
  final String locale;
  final VoidCallback onBack;
  final List<String> galleryImages;
  final int selectedIndex;
  final ValueChanged<int>? onImageSelected;

  const RestaurantDetailsHeader({
    super.key,
    required this.restaurant,
    required this.locale,
    required this.onBack,
    required this.galleryImages,
    this.selectedIndex = 0,
    this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final imageHeight = 245.h;
    final barHeight = 60.h;
    final logoSize = 92.r;

    final images = galleryImages.take(5).toList();
    final mainImageUrl = images.isNotEmpty && selectedIndex < images.length
        ? images[selectedIndex]
        : restaurant.logoUrl;

    return SizedBox(
      height: imageHeight + barHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: imageHeight,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: mainImageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: ColorsManager.grey100),
                    errorWidget: (_, __, ___) => Container(color: ColorsManager.grey100),
                  ),
                ),
                Positioned(
                  top: 18.h,
                  left: 16.w,
                  child: _RatingPill(
                    rating: restaurant.ratingsAverage.toStringAsFixed(1),
                    count: restaurant.ratingsQuantity,
                  ),
                ),
                Positioned(
                  top: 18.h,
                  right: 16.w,
                  child: _CircleIcon(
                    icon: AppAssets.arrowRight,
                    onTap: onBack,
                  ),
                ),
                if (images.length > 1)
                  Positioned(
                    bottom: 14.h,
                    left: 6.w,
                    child: _GalleryStrip(
                      images: images,
                      selectedIndex: selectedIndex,
                      onImageTap: onImageSelected,
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: imageHeight - 22.h,
            height: barHeight,
            child: Container(
              color: const Color(0xFFF7F7F7),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  SizedBox(width: logoSize + 12.w),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            restaurant.getName(locale),
                            style: TextStyles.font18Black500Weight(context),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: ColorsManager.secondaryColor,
                            borderRadius: BorderRadius.circular(32.r),
                          ),
                          child: Text(
                            restaurant.getFirstCategoryName(locale),
                            style: TextStyles.font12White400Weight(context).copyWith(
                              // fontWeight: FontWeight.w500,
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
          Positioned(
            right: 16.w,
            top: imageHeight - (logoSize * 0.55),
            child: Container(
              width: logoSize,
              height: logoSize,
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(18.r),
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: restaurant.logoUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: ColorsManager.grey100),
                errorWidget: (_, __, ___) => Center(
                  child: Text(
                    restaurant.getName(locale).isNotEmpty
                        ? restaurant.getName(locale)[0]
                        : '',
                    style: TextStyles.font20Black500Weight(context).copyWith(
                      color: ColorsManager.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingPill extends StatelessWidget {
  final String rating;
  final int count;

  const _RatingPill({required this.rating, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(26.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppAssets.star,
            width: 10.r,
            height: 10.r,
            colorFilter: const ColorFilter.mode(
              ColorsManager.secondary100,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            rating,
            style: TextStyles.font14Black500Weight(context).copyWith(
              color: ColorsManager.secondary100,
              // fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            '($count)',
            style: TextStyles.font10DarkGray400Weight(context),
          ),
        ],
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const _CircleIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.r,
        height: 40.r,
        decoration: BoxDecoration(
          color: ColorsManager.white.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(80.r),
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          icon,
          width: 20.r,
          height: 20.r,
          colorFilter: const ColorFilter.mode(
            ColorsManager.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

class _GalleryStrip extends StatelessWidget {
  final List<String> images;
  final int selectedIndex;
  final ValueChanged<int>? onImageTap;

  const _GalleryStrip({
    required this.images,
    required this.selectedIndex,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.w,
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: ColorsManager.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: SizedBox(
        height: 46.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          separatorBuilder: (_, __) => SizedBox(width: 8.w),
          itemBuilder: (_, i) {
            final isSelected = i == selectedIndex;
            return GestureDetector(
              onTap: () => onImageTap?.call(i),
              child: Container(
                width: 56.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected
                        ? ColorsManager.secondaryColor
                        : ColorsManager.grey200,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: CachedNetworkImage(
                  imageUrl: images[i],
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: ColorsManager.grey100),
                  errorWidget: (_, __, ___) => Container(color: ColorsManager.grey100),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
  