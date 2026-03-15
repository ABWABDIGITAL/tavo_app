// lib/feature/Profile/ui/screens/privacy_policy_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/animation/animation_helpers.dart';

import 'package:tavo/core/localization/locale_keys.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';
import 'package:tavo/feature/Profile/ui/widgets/profile_widgets.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = <_Section>[
      _Section(
        icon: Icons.inventory_2_outlined,
        title: LocaleKeys.collectingInfo.tr(),
        content: LocaleKeys.collectingInfoContent.tr(),
      ),
      _Section(
        icon: Icons.analytics_outlined,
        title: LocaleKeys.usingInfo.tr(),
        content: LocaleKeys.usingInfoContent.tr(),
      ),
      _Section(
        icon: Icons.share_outlined,
        title: LocaleKeys.sharingInfo.tr(),
        content: LocaleKeys.sharingInfoContent.tr(),
      ),
      _Section(
        icon: Icons.lock_outline,
        title: LocaleKeys.securityInfo.tr(),
        content: LocaleKeys.securityInfoContent.tr(),
      ),
      _Section(
        icon: Icons.verified_user_outlined,
        title: LocaleKeys.yourRights.tr(),
        content: LocaleKeys.yourRightsContent.tr(),
      ),
      _Section(
        icon: Icons.cookie_outlined,
        title: LocaleKeys.cookies.tr(),
        content: LocaleKeys.cookiesContent.tr(),
      ),
      _Section(
        icon: Icons.child_care_outlined,
        title: LocaleKeys.childrenPrivacy.tr(),
        content: LocaleKeys.childrenPrivacyContent.tr(),
      ),
      _Section(
        icon: Icons.update_outlined,
        title: LocaleKeys.updates.tr(),
        content: LocaleKeys.updatesContent.tr(),
      ),
    ];

    return Scaffold(
     
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            AnimatedAppBar(title: LocaleKeys.privacyPolicy.tr()),
            SizedBox(height: 16.h),
            
            // Simple Header (No Gradient)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _SimpleHeader(
                icon: Icons.shield_outlined,
                title: LocaleKeys.privacyMatters.tr(),
                subtitle: LocaleKeys.privacySubtitle.tr(),
              ),
            ),
            
            SizedBox(height: 12.h),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: sections.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final section = sections[index];
                  return _SimpleInfoCard(
                    index: index,
                    icon: section.icon,
                    title: section.title,
                    content: section.content,
                  );
                },
              ),
            ),
            _SimpleFooter(text: LocaleKeys.lastUpdate.tr()),
          ],
        ),
      ),
    );
  }
}

class _Section {
  final IconData icon;
  final String title;
  final String content;

  _Section({
    required this.icon,
    required this.title,
    required this.content,
  });
}

// Simple Header without gradient
class _SimpleHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SimpleHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return FadeSlideTransition(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: ColorsManager.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40.r,
              color: ColorsManager.primaryColor,
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                color: ColorsManager.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyles.font12DarkGray400Weight(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Simple Info Card without gradient/shadow
class _SimpleInfoCard extends StatelessWidget {
  final int index;
  final IconData icon;
  final String title;
  final String content;

  const _SimpleInfoCard({
    required this.index,
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return FadeSlideTransition(
      index: index,
      beginOffset: const Offset(0.2, 0),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: ColorsManager.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: context.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: ColorsManager.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    icon,
                    size: 20.r,
                    color: ColorsManager.primaryColor,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: ColorsManager.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            
            // Content
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: ColorsManager.grey100,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                content,
                style: TextStyle(
                  color: ColorsManager.darkGray300,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple Footer without gradient
class _SimpleFooter extends StatelessWidget {
  final String text;

  const _SimpleFooter({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: ColorsManager.grey100,
        border: Border(
          top: BorderSide(color: context.borderColor),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: ColorsManager.darkGray300,
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}