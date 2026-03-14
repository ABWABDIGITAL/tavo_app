// lib/feature/notifications/ui/screens/notifications_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tavo/core/constants/app_assets.dart';
import 'package:tavo/core/di/service_locator.dart';
import 'package:tavo/core/localization/locale_keys.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/feature/notifications/ui/logic/notifications_cubit.dart';
import 'package:tavo/feature/notifications/ui/logic/notifications_state.dart';
import 'package:tavo/feature/notifications/ui/logic/widgets/notification_tile.dart';
import 'package:tavo/feature/notifications/ui/logic/widgets/notifications_section_header.dart';
import 'package:tavo/feature/profile/ui/widgets/profile_widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    return BlocProvider(
      create: (_) => getIt<NotificationsCubit>()..loadNotifications(locale),
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
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                AnimatedAppBar(title: LocaleKeys.notifications.tr()),
                SizedBox(height: 16.h),
                Expanded(
                  child: _buildContent(context, state, cubit),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    NotificationsState state,
    NotificationsCubit cubit,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48.r, color: ColorsManager.darkGray300),
              SizedBox(height: 12.h),
              Text(state.error!, textAlign: TextAlign.center, style: TextStyles.font14DarkGray400Weight(context)),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () => cubit.loadNotifications(context.locale.languageCode),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text('retry'.tr(), style: const TextStyle(color: ColorsManager.white)),
              ),
            ],
          ),
        ),
      );
    }

    if (state.today.isEmpty && state.yesterday.isEmpty && state.older.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.bell,
              width: 60.r,
              height: 60.r,
              colorFilter: ColorFilter.mode(
                ColorsManager.darkGray300.withOpacity(0.5),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              LocaleKeys.noNotifications.tr(),
              style: TextStyle(
                color: ColorsManager.darkGray300,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => cubit.refresh(context.locale.languageCode),
      color: ColorsManager.primaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        children: [
          if (state.today.isNotEmpty) ...[
            NotificationsSectionHeader(title: LocaleKeys.today.tr()),
            ...state.today.map(
              (n) => NotificationTile(
                item: n,
                onTap: () => cubit.markAsRead(n.id),
              ),
            ),
          ],
          if (state.yesterday.isNotEmpty) ...[
            NotificationsSectionHeader(title: LocaleKeys.yesterday.tr()),
            ...state.yesterday.map(
              (n) => Column(
                children: [
                  NotificationTile(item: n, onTap: () => cubit.markAsRead(n.id)),
                  const Divider(height: 1, color: ColorsManager.grey100),
                ],
              ),
            ),
          ],
          if (state.older.isNotEmpty) ...[
            NotificationsSectionHeader(title: 'earlier'.tr()),
            ...state.older.map(
              (n) => Column(
                children: [
                  NotificationTile(item: n, onTap: () => cubit.markAsRead(n.id)),
                  const Divider(height: 1, color: ColorsManager.grey100),
                ],
              ),
            ),
          ],
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}