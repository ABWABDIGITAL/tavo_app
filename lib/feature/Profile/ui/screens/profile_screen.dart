// lib/feature/profile/ui/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tavo/core/constants/app_assets.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';
import 'package:tavo/feature/booking/ui/screens/bookings_screen.dart';
import 'package:tavo/feature/profile/ui/screens/personal_info_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorsManager.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              SizedBox(height: 8.h),
              _buildMenuItems(context),
              const Spacer(),
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 190.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildHeaderBackground(),
          _buildProfileInfo(context),
        ],
      ),
    );
  }

  Widget _buildHeaderBackground() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(22.r)),
      child: Container(
        height: 130.h,
        width: double.infinity,
        color: const Color(0xFF2F2F5F),
        child: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(top: 10.h, right: 16.w),
            child: SizedBox(
              width: 150.w,
              height: 80.h,
              child: Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: List.generate(
                  50,
                  (_) => Container(
                    width: 2.5.r,
                    height: 2.5.r,
                    decoration: BoxDecoration(
                      color: ColorsManager.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context) {
    return PositionedDirectional(
      top: 80.h,
      start: 0,
      end: 0,
      child: Column(
        children: [
          Container(
            width: 80.r,
            height: 80.r,
            decoration: BoxDecoration(
              color: ColorsManager.grey200,
              shape: BoxShape.circle,
              border: Border.all(color: ColorsManager.white, width: 3.r),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'ندى',
            style: TextStyles.font14DarkGray400Weight(context).copyWith(
              color: ColorsManager.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          _ProfileMenuItem(
            title: 'بياناتي الشخصية',
            iconAsset: AppAssets.user,
            onTap: () => _navigateTo(context, const PersonalInfoScreen()),
          ),
          SizedBox(height: 8.h),
          _ProfileMenuItem(
            title: 'الحجوزات',
            iconAsset: AppAssets.bookings,
            onTap: () => _navigateTo(context, const BookingsScreen()),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: GestureDetector(
          onTap: () => _showLogoutSheet(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 30.r,
                  height: 30.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF0F0),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.logout,
                      width: 14.r,
                      height: 14.r,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFC62828),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'تسجيل خروج',
                  style: TextStyles.font12DarkGray400Weight(context).copyWith(
                    color: const Color(0xFFC62828),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _LogoutBottomSheet(context: context),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final String title;
  final String iconAsset;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.title,
    required this.iconAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: ColorsManager.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: context.borderColor),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
           Container(
              width: 30.r,
              height: 30.r,
              decoration: const BoxDecoration(
                color: ColorsManager.grey100,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconAsset,
                  width: 20.r,
                  height: 20.r,
                  colorFilter: const ColorFilter.mode(
                    ColorsManager.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              title,
              style: TextStyles.font12DarkGray400Weight(context).copyWith(
                color: ColorsManager.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            
            
            
            const Spacer(),
             SvgPicture.asset(
              AppAssets.chevronsLeft,
              width: 18.r,
              height: 18.r,
              colorFilter: ColorFilter.mode(
                context.textSecondaryColor,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutBottomSheet extends StatelessWidget {
  final BuildContext context;

  const _LogoutBottomSheet({required this.context});

  @override
  Widget build(BuildContext parentContext) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: ColorsManager.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              SizedBox(height: 14.h),
              _buildContent(),
              SizedBox(height: 14.h),
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 30.r,
            height: 30.r,
            decoration: const BoxDecoration(
              color: ColorsManager.grey100,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                AppAssets.close,
                width: 14.r,
                height: 14.r,
                colorFilter: const ColorFilter.mode(
                  ColorsManager.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        Text(
          'تسجيل خروج',
          style: TextStyles.font14DarkGray400Weight(context).copyWith(
            color: ColorsManager.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        SizedBox(width: 30.r),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'هل أنت متأكد من تسجيل الخروج؟',
          style: TextStyles.font12DarkGray400Weight(context).copyWith(
            color: ColorsManager.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'بعد تسجيل الخروج تحتاج تسجيل دخولك مرة ثانية',
          style: TextStyles.font10DarkGray400Weight(context).copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      height: 44.h,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          // TODO: Handle logout
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: const Color(0xFFC62828),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80.r),
          ),
        ),
        child: Text(
          'تسجيل خروج',
          style: TextStyles.font14DarkGray400Weight(context).copyWith(
            color: ColorsManager.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}