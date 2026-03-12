import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/theme/colors.dart';

class OnboardingDotIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const OnboardingDotIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: isActive ? 24.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: isActive
                ? ColorsManager.primaryColor
                : ColorsManager.white.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }
}
