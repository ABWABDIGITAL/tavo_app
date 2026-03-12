import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tavo/core/constants/app_assets.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';
import 'package:tavo/feature/restaurant/data/model/menu_item_model.dart';


class MenuItemCard extends StatelessWidget {
  final MenuItemModel item;
  final String locale;
  final int qty;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback? onCustomize;

  const MenuItemCard({
    super.key,
    required this.item,
    required this.locale,
    required this.qty,
    required this.onAdd,
    required this.onRemove,
    this.onCustomize,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18.r);

    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: radius,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: item.imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: ColorsManager.grey100),
              errorWidget: (_, __, ___) => Container(
                color: ColorsManager.grey100,
                child: Icon(
                  Icons.restaurant,
                  size: 40.w,
                  color: ColorsManager.darkGray300,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: ColorsManager.black.withValues(alpha: 0.18),
            ),
          ),
          if (item.hasDiscount)
            PositionedDirectional(
              top: 10.h,
              end: 10.w,
              child: GestureDetector(
                onTap: onCustomize,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: ColorsManager.secondaryColor,
                    borderRadius: BorderRadius.circular(22.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppAssets.edit,
                        width: 14.r,
                        height: 14.r,
                        colorFilter: const ColorFilter.mode(
                          ColorsManager.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'customize'.tr(),
                        style: TextStyles.font14White400Weight(context).copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          PositionedDirectional(
            bottom: 0,
            start: 0,
            end: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
              color: ColorsManager.black.withValues(alpha: 0.35),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.getTitle(locale),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.font16White500Weight(context).copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                '${item.price.toStringAsFixed(0)} ${'currency'.tr()}',
                                style: TextStyles.font14White500Weight(context).copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            if (item.oldPrice != null) ...[
                              SizedBox(width: 10.w),
                              Flexible(
                                child: Text(
                                  '${item.oldPrice!.toStringAsFixed(0)} ${'currency'.tr()}',
                                  style: TextStyles.font12White400Weight(context).copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: ColorsManager.darkGray300,
                                    decorationColor: ColorsManager.darkGray300,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  if (qty > 0) ...[
                    GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        width: 28.r,
                        height: 28.r,
                        decoration: BoxDecoration(
                          color: ColorsManager.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.remove,
                          size: 18.r,
                          color: ColorsManager.primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '$qty',
                      style: TextStyles.font16White500Weight(context).copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  GestureDetector(
                    onTap: onAdd,
                    child: SvgPicture.asset(
                      AppAssets.plus,
                      width: 28.r,
                      height: 28.r,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}