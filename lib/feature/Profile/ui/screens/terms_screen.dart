// lib/feature/profile/ui/screens/terms_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/animation/animation_helpers.dart';

import 'package:tavo/core/localization/locale_keys.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';
import 'package:tavo/feature/profile/ui/widgets/profile_widgets.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final terms = <_Term>[
      _Term(
        number: '1',
        title: LocaleKeys.acceptTerms.tr(),
        icon: Icons.handshake_outlined,
        content: LocaleKeys.acceptTermsContent.tr(),
      ),
      _Term(
        number: '2',
        title: LocaleKeys.accountAndRegistration.tr(),
        icon: Icons.person_outline,
        content: LocaleKeys.accountAndRegistrationContent.tr(),
      ),
      _Term(
        number: '3',
        title: LocaleKeys.bookingsTerms.tr(),
        icon: Icons.calendar_today_outlined,
        content: LocaleKeys.bookingsTermsContent.tr(),
      ),
      _Term(
        number: '4',
        title: LocaleKeys.cancellationAndModification.tr(),
        icon: Icons.edit_calendar_outlined,
        content: LocaleKeys.cancellationAndModificationContent.tr(),
      ),
      _Term(
        number: '5',
        title: LocaleKeys.contentAndReviews.tr(),
        icon: Icons.rate_review_outlined,
        content: LocaleKeys.contentAndReviewsContent.tr(),
      ),
      _Term(
        number: '6',
        title: LocaleKeys.intellectualProperty.tr(),
        icon: Icons.copyright_outlined,
        content: LocaleKeys.intellectualPropertyContent.tr(),
      ),
      _Term(
        number: '7',
        title: LocaleKeys.liability.tr(),
        icon: Icons.gavel_outlined,
        content: LocaleKeys.liabilityContent.tr(),
      ),
      _Term(
        number: '8',
        title: LocaleKeys.accountTermination.tr(),
        icon: Icons.block_outlined,
        content: LocaleKeys.accountTerminationContent.tr(),
      ),
      _Term(
        number: '9',
        title: LocaleKeys.modifications.tr(),
        icon: Icons.update_outlined,
        content: LocaleKeys.modificationsContent.tr(),
      ),
    ];

    return Scaffold(
    
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            AnimatedAppBar(title: LocaleKeys.termsAndConditions.tr()),
            SizedBox(height: 16.h),
            
            // Simple Header (No Gradient)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _SimpleHeader(
                icon: Icons.description_outlined,
                title: LocaleKeys.termsOfUse.tr(),
                subtitle: LocaleKeys.termsSubtitle.tr(),
              ),
            ),
            
            SizedBox(height: 12.h),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: terms.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final term = terms[index];
                  return FadeSlideTransition(
                    index: index,
                    delay: const Duration(milliseconds: 70),
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: ColorsManager.white,
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(color: context.borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Number Badge (No Gradient)
                              Container(
                                width: 36.r,
                                height: 36.r,
                                decoration: BoxDecoration(
                                  color: ColorsManager.primaryColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Center(
                                  child: Text(
                                    term.number,
                                    style: TextStyle(
                                      color: ColorsManager.primaryColor,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  term.title,
                                  style: TextStyle(
                                    color: ColorsManager.black,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Container(
                                width: 32.r,
                                height: 32.r,
                                decoration: BoxDecoration(
                                  color: ColorsManager.grey100,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Center(
                                  child: Icon(
                                    term.icon,
                                    size: 16.r,
                                    color: ColorsManager.darkGray300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Padding(
                            padding: EdgeInsetsDirectional.only(start: 48.w),
                            child: Text(
                              term.content,
                              style: TextStyles.font12DarkGray400Weight(context)
                                  .copyWith(
                                height: 1.9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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

class _Term {
  final String number;
  final String title;
  final IconData icon;
  final String content;

  _Term({
    required this.number,
    required this.title,
    required this.icon,
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
              style: TextStyles.font10Dark400Grey400Weight(context),
              textAlign: TextAlign.center,
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