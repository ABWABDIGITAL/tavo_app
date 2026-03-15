// lib/ui/widgets/notification_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';

import '../../../data/model/app_notification.dart';

class NotificationTile extends StatelessWidget {
  final AppNotification item;
  final VoidCallback? onTap;

  const NotificationTile({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            _IconWithDot(isUnread: !item.isRead, type: item.type),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyles.font14Black500Weight(context),
                  ),
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
            Text(
              item.timeAgo,
              style: TextStyles.font12DarkGray400Weight(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconWithDot extends StatelessWidget {
  final bool isUnread;
  final String type;

  const _IconWithDot({required this.isUnread, required this.type});

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
            color: _getBackgroundColor(),
          ),
          alignment: Alignment.center,
          child: Icon(_getIcon(), size: 20.r, color: _getIconColor()),
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

  IconData _getIcon() {
    if (type.contains('reservation')) {
      if (type.contains('confirmed')) return Icons.check_circle;
      if (type.contains('cancelled')) return Icons.cancel;
      if (type.contains('completed')) return Icons.done_all;
      return Icons.calendar_today;
    } else if (type.contains('order')) {
      if (type.contains('confirmed')) return Icons.check_circle;
      if (type.contains('cancelled')) return Icons.cancel;
      if (type.contains('ready')) return Icons.fastfood;
      if (type.contains('preparing')) return Icons.restaurant;
      if (type.contains('delivered')) return Icons.delivery_dining;
      return Icons.receipt_long;
    } else if (type.contains('promotion'))
      return Icons.local_offer;
    return Icons.notifications;
  }

  Color _getBackgroundColor() {
    if (type.contains('reservation') || type.contains('order')) {
      return ColorsManager.primaryColor.withValues(alpha: 0.1);
    }
    return Colors.transparent;
  }

  Color _getIconColor() {
    if (type.contains('reservation') || type.contains('order')) {
      return ColorsManager.primaryColor;
    }
    return ColorsManager.darkGray300;
  }
}
