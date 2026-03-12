import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tavo/core/constants/app_assets.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/feature/notifications/ui/screens/notifications_screen.dart';

class HomeHeader extends StatelessWidget {
  final double shrinkOffset;
  final double maxExtent;

  const HomeHeader({
    super.key,
    required this.shrinkOffset,
    required this.maxExtent,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        image: const DecorationImage(
          image: AssetImage(AppAssets.headerHome),
          fit: BoxFit.cover,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title row
              Row(
                children: [
                  // Title & subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'home_title'.tr(),
                          style: textTheme.titleLarge?.copyWith(
                            color: ColorsManager.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'home_subtitle'.tr(),
                          style: textTheme.bodyMedium?.copyWith(
                            color: ColorsManager.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Notification icon
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: ColorsManager.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: 
                      InkWell(
                        onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
                        },
                        child: SvgPicture.asset(
                        AppAssets.notification,
                        width: 20.w,
                        height: 20.w,
                        colorFilter: const ColorFilter.mode(
                          ColorsManager.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),)
                ],
              ),
              SizedBox(height: 16.h),
              // Search bar
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: ColorsManager.white,
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppAssets.search,
                      width: 20.w,
                      height: 20.w,
                      colorFilter: const ColorFilter.mode(
                        ColorsManager.darkGray300,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'search_hint'.tr(),
                        style: textTheme.bodyMedium?.copyWith(
                          color: ColorsManager.dark300,
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
