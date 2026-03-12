// lib/ui/widgets/notification_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/constants/app_assets.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/widgets/primary/my_svg.dart';

import '../../../data/model/app_notification.dart';


class NotificationTile extends StatelessWidget {
  final AppNotification item;
  final VoidCallback? onTap;

  const NotificationTile({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            _IconWithDot(isUnread: !item.isRead),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: TextStyles.font14Black500Weight(context)),
                  SizedBox(height: 4.h),
                  Text(
                    item.message,
                    style: TextStyles.font12DarkGray400Weight(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Text(item.timeAgo, style: TextStyles.font12DarkGray400Weight(context)),
          ],
        ),
      ),
    );
  }
}

class _IconWithDot extends StatelessWidget {
  final bool isUnread;
  const _IconWithDot({required this.isUnread});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 44.r,
          height: 44.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: ColorsManager.grey200),
            color: Colors.transparent,
          ),
          alignment: Alignment.center,
          child: MySvg(
            image: AppAssets.icCancelCalendar,
            width: 20.r,
            height: 20.r,
          ),
        ),
        if (isUnread)
          Positioned(
            top: 1,
            right: 1,
            child: Container(
              width: 9.r,
              height: 9.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorsManager.secondary500,
              ),
            ),
          ),
      ],
    );
  }
}