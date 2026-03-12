// lib/ui/screens/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/constants/app_assets.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/widgets/primary/my_svg.dart';
import 'package:tavo/feature/notifications/ui/logic/notifications_cubit.dart';
import 'package:tavo/feature/notifications/ui/logic/notifications_state.dart';
import 'package:tavo/feature/notifications/ui/logic/widgets/notification_tile.dart';
import 'package:tavo/feature/notifications/ui/logic/widgets/notifications_section_header.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit()..loadMock(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final cubit = context.read<NotificationsCubit>();

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            leadingWidth: 60.w,
            title: Text(
              'الإشعارات',
              style: TextStyles.font16Black500Weight(context),
            ),
            leading: Padding(
              padding: EdgeInsetsDirectional.only(start: 12.w),
              child: Center(
                child: InkWell(
                  borderRadius: BorderRadius.circular(80.r),
                  onTap: () => Navigator.of(context).maybePop(),
                  child: Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: ColorsManager.grey100,
                      borderRadius: BorderRadius.circular(80.r),
                    ),
                    alignment: Alignment.center,
                    child: MySvg(
                      image: AppAssets.icArrowRight,
                      width: 18.r,
                      height: 18.r,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: state.hasUnread ? cubit.markAllAsRead : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MySvg(
                      image: AppAssets.icCheck,
                      width: 16.r,
                      height: 16.r,
                      color: state.hasUnread
                          ? ColorsManager.secondary500
                          : ColorsManager.darkGray300,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'تحديد الكل كمقروء',
                      style: TextStyles.font12Blue400Weight(context).copyWith(
                        color: state.hasUnread
                            ? ColorsManager.secondary500
                            : ColorsManager.darkGray300,
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ],
                ),
              ),
            ],
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const NotificationsSectionHeader(title: 'اليوم'),
                    ...state.today.map(
                      (n) => NotificationTile(
                        item: n,
                        onTap: () => cubit.markAsRead(n.id),
                      ),
                    ),
                    const NotificationsSectionHeader(title: 'أمس'),
                    ...state.yesterday.map(
                      (n) => Column(
                        children: [
                          NotificationTile(item: n),
                          const Divider(
                            height: 1,
                            color: ColorsManager.grey100,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
        );
      },
    );
  }
}