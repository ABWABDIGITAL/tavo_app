// lib/core/widgets/primary/my_outline_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/theme_extensions.dart';

class MyOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final double? radius;
  final TextStyle? labelStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double gap;

  const MyOutlineButton({
    super.key,
    required this.label,
    this.onPressed,
    this.height,
    this.width,
    this.radius,
    this.labelStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.gap = 8,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 48.h,
      width: width ?? double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: context.borderColor,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 0),
          ),
          backgroundColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixIcon != null) ...[
              prefixIcon!,
              SizedBox(width: gap.w),
            ],
            Text(
              label,
              style: labelStyle ?? TextStyle(
                color: context.textPrimaryColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (suffixIcon != null) ...[
              SizedBox(width: gap.w),
              suffixIcon!,
            ],
          ],
        ),
      ),
    );
  }
}