// lib/ui/widgets/notifications_section_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/text_styles.dart';


class NotificationsSectionHeader extends StatelessWidget {
  final String title;
  const NotificationsSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: ColorsManager.secondary100.withValues(alpha: 0.04),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Text(title, style: TextStyles.font12DarkGray400Weight(context)),
    );
  }
}