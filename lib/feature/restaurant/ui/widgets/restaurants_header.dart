// lib/ui/widgets/restaurants/restaurants_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/constants/app_assets.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/widgets/primary/my_svg.dart';



class RestaurantsHeader extends StatelessWidget {
  final int count;
  final VoidCallback onFilterTap;

  const RestaurantsHeader({
    super.key,
    required this.count,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            
            Row(
              children: [
                Text('المطاعم', style: TextStyles.font16Black500Weight(context)),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: ColorsManager.secondary500.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyles.font12secondary500yellow400Weight(context).copyWith(
                      // color: ColorsManager.secondary500,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
              const Spacer(),
            InkWell(
              onTap: onFilterTap,
              borderRadius: BorderRadius.circular(18.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: ColorsManager.grey100,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(color: ColorsManager.grey200),
                ),
                child: Row(
                  children: [
                    Text('تصفيه', style: TextStyles.font12DarkGray400Weight(context)),
                    SizedBox(width: 8.w),
                    MySvg(image: AppAssets.filter, width: 16.r, height: 16.r),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}