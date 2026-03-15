// lib/feature/Profile/ui/screens/stats_screen.dart
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
import 'package:tavo/feature/Profile/ui/logic/cubit/profile_cubit.dart';
import 'package:tavo/feature/Profile/ui/logic/cubit/profile_state.dart';
import 'package:tavo/feature/Profile/data/model/user_stats.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileCubit>()..loadStats(),
      child: const _StatsView(),
    );
  }
}

class _StatsView extends StatelessWidget {
  const _StatsView();

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.RTL;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).maybePop(),
                              child: Container(
                                width: 36.r,
                                height: 36.r,
                                decoration: const BoxDecoration(
                                  color: ColorsManager.grey100,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    isRtl
                                        ? AppAssets.arrowRight
                                        : AppAssets.arrowLeft,
                                    width: 16.r,
                                    height: 16.r,
                                    colorFilter: const ColorFilter.mode(
                                      ColorsManager.black,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16.r),
                            Text(
                              LocaleKeys.myStats.tr(),
                              style: TextStyle(
                                color: ColorsManager.black,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        if (state.loading)
                          const Center(
                            child: CircularProgressIndicator(
                              color: ColorsManager.primaryColor,
                            ),
                          )
                        else if (state.stats != null)
                          _buildStatsContent(context, state.stats as UserStats)
                        else if (state.error != null)
                          _buildErrorWidget(context, state.error!)
                        else
                          _buildErrorWidget(context, 'No data available'),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatsContent(BuildContext context, UserStats stats) {
    return Column(
      children: [
        _buildStatCard(
          context,
          icon: Icons.restaurant_outlined,
          title: LocaleKeys.totalReservations.tr(),
          value: stats.statistics.totalReservations.toString(),
          color: ColorsManager.primaryColor,
        ),
        SizedBox(height: 12.h),
        _buildStatCard(
          context,
          icon: Icons.shopping_bag_outlined,
          title: LocaleKeys.totalOrders.tr(),
          value: stats.statistics.totalOrders.toString(),
          color: const Color(0xFF4CAF50),
        ),
        SizedBox(height: 12.h),
        _buildStatCard(
          context,
          icon: Icons.attach_money,
          title: LocaleKeys.totalSpent.tr(),
          value:
              '${stats.statistics.totalSpent.toStringAsFixed(2)} ${LocaleKeys.currency.tr()}',
          color: const Color(0xFFFF9800),
        ),
        SizedBox(height: 12.h),
        _buildStatCard(
          context,
          icon: Icons.favorite_outline,
          title: LocaleKeys.favorites.tr(),
          value: stats.favoritesCount.toString(),
          color: const Color(0xFFE91E63),
        ),
        SizedBox(height: 12.h),
        _buildLoyaltyCard(context, stats.loyalty),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 24.r),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.font12DarkGray400Weight(
                    context,
                  ).copyWith(color: ColorsManager.darkGray300),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: ColorsManager.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoyaltyCard(BuildContext context, LoyaltyInfo loyalty) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorsManager.primaryColor,
            ColorsManager.primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars, color: ColorsManager.white, size: 24.r),
              SizedBox(width: 8.w),
              Text(
                LocaleKeys.loyaltyPoints.tr(),
                style: TextStyle(
                  color: ColorsManager.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.currentPoints.tr(),
                    style: TextStyle(
                      color: ColorsManager.white.withValues(alpha: 0.8),
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    loyalty.points.toString(),
                    style: TextStyle(
                      color: ColorsManager.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    LocaleKeys.tier.tr(),
                    style: TextStyle(
                      color: ColorsManager.white.withValues(alpha: 0.8),
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: ColorsManager.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      loyalty.tier,
                      style: TextStyle(
                        color: ColorsManager.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            '${LocaleKeys.lifetimePoints.tr()}: ${loyalty.lifetimePoints}',
            style: TextStyle(
              color: ColorsManager.white.withValues(alpha: 0.7),
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48.r,
              color: ColorsManager.darkGray300,
            ),
            SizedBox(height: 12.h),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyles.font14DarkGray400Weight(context),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => context.read<ProfileCubit>().loadStats(),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                LocaleKeys.retry.tr(),
                style: const TextStyle(color: ColorsManager.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
