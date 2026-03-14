// lib/feature/booking/ui/widgets/order_details_loading_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/theme/colors.dart';

class OrderDetailsLoadingSheet extends StatelessWidget {
  const OrderDetailsLoadingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: ColorsManager.grey200,
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
          SizedBox(height: 40.h),
          const CircularProgressIndicator(color: ColorsManager.primaryColor),
          SizedBox(height: 20.h),
          Text(
            'جاري التحميل...',
            style: TextStyle(
              color: ColorsManager.darkGray300,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}