// lib/feature/profile/ui/screens/about_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/animation/animation_helpers.dart';

import 'package:tavo/core/localization/locale_keys.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';
import 'package:tavo/feature/profile/ui/widgets/profile_widgets.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            AnimatedAppBar(title: LocaleKeys.aboutApp.tr()),
            SizedBox(height: 30.h),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    // Animated Logo
                    const PulsatingWidget(
                      child: AnimatedLogo(),
                    ),
                    SizedBox(height: 20.h),

                    // Version Badge (No Gradient)
                    FadeSlideTransition(
                      index: 1,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorsManager.white,
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified,
                              size: 16.r,
                              color: ColorsManager.primaryColor,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              LocaleKeys.version.tr(args: ['1.0.0']),
                              style: TextStyles.font12DarkGray400Weight(context)
                                  .copyWith(
                                color: ColorsManager.primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // Description Card (No Gradient)
                    FadeSlideTransition(
                      index: 2,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: ColorsManager.grey100,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: context.borderColor),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 32.r,
                              color: ColorsManager.primaryColor,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              LocaleKeys.aboutDescription.tr(),
                              style: TextStyles.font12DarkGray400Weight(context)
                                  .copyWith(
                                height: 1.9,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 25.h),

                    // Info Cards
                    _buildInfoRow(
                      context,
                      index: 3,
                      icon: Icons.email_outlined,
                      title: LocaleKeys.email.tr(),
                      value: 'support@tavo.app',
                      color: ColorsManager.primaryColor,
                    ),
                    SizedBox(height: 10.h),
                    _buildInfoRow(
                      context,
                      index: 4,
                      icon: Icons.phone_outlined,
                      title: LocaleKeys.phone.tr(),
                      value: '+966 50 000 0000',
                      color: const Color(0xFF2E7D32),
                    ),
                    SizedBox(height: 10.h),
                    _buildInfoRow(
                      context,
                      index: 5,
                      icon: Icons.language_outlined,
                      title: LocaleKeys.website.tr(),
                      value: 'www.tavo.app',
                      color: const Color(0xFF1976D2),
                    ),
                    SizedBox(height: 40.h),

                    // Footer
                    FadeSlideTransition(
                      index: 6,
                      child: Text(
                        LocaleKeys.allRightsReserved.tr(),
                        style: TextStyles.font10DarkGray400Weight(context)
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return FadeSlideTransition(
      index: index,
      beginOffset: const Offset(0.15, 0),
      child: BouncingButton(
        onTap: () {},
        child: Container(
          height: 56.h,
          decoration: BoxDecoration(
            color: ColorsManager.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: context.borderColor),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Row(
            children: [
              Container(
                width: 34.r,
                height: 34.r,
                decoration: BoxDecoration(
                  color:ColorsManager.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Icon(icon, size: 18.r, color: color),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: TextStyles.font12DarkGray400Weight(context).copyWith(
                  color: ColorsManager.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: ColorsManager.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}