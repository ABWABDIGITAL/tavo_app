// lib/feature/profile/ui/screens/language_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/animation/animation_helpers.dart';
import 'package:tavo/core/localization/locale_keys.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';
import 'package:tavo/feature/profile/ui/widgets/profile_widgets.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale.languageCode;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            AnimatedAppBar(title: LocaleKeys.language.tr()),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  // Header
                  FadeSlideTransition(
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
                            Icons.translate,
                            size: 40.r,
                            color: ColorsManager.secondary100,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            LocaleKeys.selectLanguage.tr(),
                            style: TextStyle(
                              color: ColorsManager.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Arabic Option
                  _LanguageOption(
                    index: 1,
                    title: LocaleKeys.arabic.tr(),
                    subtitle: LocaleKeys.arabicNative.tr(),
                    flag: '🇸🇦',
                    isSelected: currentLocale == 'ar',
                    onTap: () => _changeLanguage(context, 'ar'),
                  ),
                  SizedBox(height: 12.h),

                  // English Option
                  _LanguageOption(
                    index: 2,
                    title: LocaleKeys.english.tr(),
                    subtitle: LocaleKeys.englishNative.tr(),
                    flag: '🇺🇸',
                    isSelected: currentLocale == 'en',
                    onTap: () => _changeLanguage(context, 'en'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeLanguage(BuildContext context, String langCode) {
    context.setLocale(Locale(langCode));
    Navigator.of(context).pop();
  }
}

class _LanguageOption extends StatelessWidget {
  final int index;
  final String title;
  final String subtitle;
  final String flag;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.flag,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FadeSlideTransition(
      index: index,
      beginOffset: const Offset(0.2, 0),
      child: BouncingButton(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: 72.h,
          decoration: BoxDecoration(
           color: ColorsManager.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: isSelected
                  ? ColorsManager.secondary100
                  : context.borderColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              // Flag
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 46.r,
                height: 46.r,
                decoration: BoxDecoration(
                  // color: isSelected
                  //     ? ColorsManager.primaryColor.withValues(alpha: 0.1)
                  //     : ColorsManager.grey100,
                  color: ColorsManager.white,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Center(
                  child: Text(
                    flag,
                    style: TextStyle(fontSize: 26.sp),
                  ),
                ),
              ),
              SizedBox(width: 14.w),

              // Title + Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: ColorsManager.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyles.font10DarkGray400Weight(context),
                    ),
                  ],
                ),
              ),

              // Check icon
              AnimatedScale(
                scale: isSelected ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.elasticOut,
                child: Container(
                  width: 26.r,
                  height: 26.r,
                  decoration: const BoxDecoration(
                    color: ColorsManager.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 16.r,
                    color: ColorsManager.white,
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