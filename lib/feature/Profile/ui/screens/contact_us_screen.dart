// lib/feature/Profile/ui/screens/contact_us_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/animation/animation_helpers.dart';

import 'package:tavo/core/localization/locale_keys.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';
import 'package:tavo/feature/Profile/ui/widgets/profile_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            AnimatedAppBar(title: LocaleKeys.contactUs.tr()),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),

                    // Header Icon (No Gradient)
                    ScaleInTransition(
                      child: Container(
                        width: 90.r,
                        height: 90.r,
                        decoration: BoxDecoration(
                          // color: ColorsManager.primaryColor.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 60.r,
                            height: 60.r,
                            decoration: BoxDecoration(
                              color: ColorsManager.primaryColor.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.headset_mic_outlined,
                              size: 32.r,
                              color: ColorsManager.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Title
                    FadeSlideTransition(
                      index: 1,
                      child: Text(
                        LocaleKeys.howCanWeHelp.tr(),
                        style: TextStyle(
                          color: ColorsManager.black,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Subtitle
                    FadeSlideTransition(
                      index: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          LocaleKeys.contactDescription.tr(),
                          style: TextStyles.font12DarkGray400Weight(context)
                              .copyWith(height: 1.6),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),

                    // Contact Cards
                    _SimpleContactCard(
                      index: 0,
                      icon: Icons.phone_outlined,
                      title: LocaleKeys.callUs.tr(),
                      subtitle: '+966 50 000 0000',
                      color: const Color(0xFF2E7D32),
                      onTap: () => _launch('tel:+966500000000'),
                    ),
                    SizedBox(height: 10.h),
                    _SimpleContactCard(
                      index: 1,
                      icon: Icons.email_outlined,
                      title: LocaleKeys.email.tr(),
                      subtitle: 'support@tavo.app',
                      color: ColorsManager.primaryColor,
                      onTap: () => _launch('mailto:support@tavo.app'),
                    ),
                    SizedBox(height: 10.h),
                    _SimpleContactCard(
                      index: 2,
                      icon: Icons.chat_bubble_outline,
                      title: LocaleKeys.whatsapp.tr(),
                      subtitle: '+966 50 000 0000',
                      color: const Color(0xFF25D366),
                      onTap: () => _launch('https://wa.me/966500000000'),
                    ),
                    SizedBox(height: 28.h),

                    // Working Hours (No Gradient)
                    FadeSlideTransition(
                      index: 4,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 18.r,
                                  color: ColorsManager.primaryColor,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  LocaleKeys.workingHours.tr(),
                                  style: TextStyle(
                                    color: ColorsManager.black,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            _TimeRow(
                              day: LocaleKeys.sundayToThursday.tr(),
                              time: '9:00 AM - 11:00 PM',
                            ),
                            SizedBox(height: 12.h),
                            Divider(height: 1, color: context.borderColor),
                            SizedBox(height: 12.h),
                            _TimeRow(
                              day: LocaleKeys.fridayAndSaturday.tr(),
                              time: '2:00 PM - 11:00 PM',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),

                    // Social Media
                    FadeSlideTransition(
                      index: 5,
                      child: Column(
                        children: [
                          Text(
                            LocaleKeys.followUs.tr(),
                            style: TextStyle(
                              color: ColorsManager.darkGray300,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _SocialIcon(
                                icon: Icons.close,
                                color: const Color(0xFF1DA1F2),
                                onTap: () => _launch('https://x.com/tavo'),
                              ),
                              SizedBox(width: 12.w),
                              _SocialIcon(
                                icon: Icons.camera_alt_outlined,
                                color: const Color(0xFFE4405F),
                                onTap: () => _launch('https://instagram.com/tavo'),
                              ),
                              SizedBox(width: 12.w),
                              _SocialIcon(
                                icon: Icons.play_arrow,
                                color: const Color(0xFF000000),
                                onTap: () => _launch('https://tiktok.com/@tavo'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// Simple Contact Card without gradient/shadow
class _SimpleContactCard extends StatelessWidget {
  final int index;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _SimpleContactCard({
    required this.index,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FadeSlideTransition(
      index: index,
      beginOffset: const Offset(0.2, 0),
      child: BouncingButton(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: ColorsManager.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: context.borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  icon,
                  size: 24.r,
                  color: color,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: ColorsManager.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: ColorsManager.darkGray300,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16.r,
                color: ColorsManager.darkGray300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  final String day;
  final String time;

  const _TimeRow({required this.day, required this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: TextStyle(
            color: ColorsManager.black,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: ColorsManager.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            time,
            style: TextStyle(
              color: ColorsManager.primaryColor,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BouncingButton(
      onTap: onTap,
      child: Container(
        width: 50.r,
        height: 50.r,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
        ),
        child: Center(
          child: Icon(icon, size: 22.r, color: color),
        ),
      ),
    );
  }
}