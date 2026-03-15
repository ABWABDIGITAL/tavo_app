// lib/feature/Profile/ui/screens/help_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:tavo/core/localization/locale_keys.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';
import 'package:tavo/feature/Profile/ui/widgets/profile_widgets.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  int _expandedIndex = -1;

  List<_Faq> get _faqs => [
        _Faq(q: LocaleKeys.faq1Question.tr(), a: LocaleKeys.faq1Answer.tr()),
        _Faq(q: LocaleKeys.faq2Question.tr(), a: LocaleKeys.faq2Answer.tr()),
        _Faq(q: LocaleKeys.faq3Question.tr(), a: LocaleKeys.faq3Answer.tr()),
        _Faq(q: LocaleKeys.faq4Question.tr(), a: LocaleKeys.faq4Answer.tr()),
        _Faq(q: LocaleKeys.faq5Question.tr(), a: LocaleKeys.faq5Answer.tr()),
        _Faq(q: LocaleKeys.faq6Question.tr(), a: LocaleKeys.faq6Answer.tr()),
        _Faq(q: LocaleKeys.faq7Question.tr(), a: LocaleKeys.faq7Answer.tr()),
        _Faq(q: LocaleKeys.faq8Question.tr(), a: LocaleKeys.faq8Answer.tr()),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            AnimatedAppBar(title: LocaleKeys.help.tr()),
            SizedBox(height: 16.h),
            
            // Simple Header (No Gradient)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _SimpleHeader(
                icon: Icons.help_outline,
                title: LocaleKeys.faqTitle.tr(),
                subtitle: LocaleKeys.faqSubtitle.tr(),
              ),
            ),
            
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: _faqs.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  return _SimpleExpandableCard(
                    question: _faqs[index].q,
                    answer: _faqs[index].a,
                    isExpanded: _expandedIndex == index,
                    onTap: () {
                      setState(() {
                        _expandedIndex = _expandedIndex == index ? -1 : index;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Faq {
  final String q;
  final String a;
  _Faq({required this.q, required this.a});
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
    return Container(
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
            style: TextStyles.font12Dark500400Weight(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Simple Expandable Card without gradient/shadow
class _SimpleExpandableCard extends StatelessWidget {
  final String question;
  final String answer;
  final bool isExpanded;
  final VoidCallback onTap;

  const _SimpleExpandableCard({
    required this.question,
    required this.answer,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color:ColorsManager.white,
          //  isExpanded
          //     ? ColorsManager.primaryColor.withValues(alpha: 0.08)
          //     : ColorsManager.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isExpanded
                ? ColorsManager.primaryColor
                : context.borderColor,
            width: isExpanded ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            // Question Row
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Container(
                    width: 36.r,
                    height: 36.r,
                    decoration: BoxDecoration(
                      color: ColorsManager.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.question_mark,
                      size: 18.r,
                      color: ColorsManager.primaryColor,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      question,
                      style: TextStyle(
                        color: ColorsManager.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 24.r,
                      color: ColorsManager.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            // Answer (Expandable)
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: ColorsManager.grey100,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    answer,
                    style: TextStyle(
                      color: ColorsManager.darkGray300,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }
}