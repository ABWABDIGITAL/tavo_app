// lib/feature/restaurants/ui/widgets/filter_chip.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tavo/core/constants/app_assets.dart';
import 'package:tavo/core/theme/theme_extensions.dart';

class ActiveFilterChip extends StatelessWidget {
  final Widget child;
  final VoidCallback onRemove;

  const ActiveFilterChip({
    super.key,
    required this.child,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.only(start: 8.w, end: 10.w, top: 6.h, bottom: 6.h),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.borderColor),
                color: context.backgroundColor,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                AppAssets.close,
                width: 12.r,
                height: 12.r,
                colorFilter: ColorFilter.mode(context.textSecondaryColor, BlendMode.srcIn),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          child,
        ],
      ),
    );
  }
}