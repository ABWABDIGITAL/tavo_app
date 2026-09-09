import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tavo/core/helpers/utils/spacing.dart';
import 'package:tavo/core/theme/colors.dart';

class SocialLoginButton extends StatelessWidget {
  final VoidCallback onTap;
  final String icon;
  final String label;

  const SocialLoginButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          border: Border.all(color: ColorsManager.lightGrey),
          borderRadius: BorderRadius.circular(80.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
         SvgPicture.asset(
          icon,
          width: 24.w,
          height: 24.h,
        ),
            horizontalSpace(8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: ColorsManager.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
