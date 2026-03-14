// lib/feature/main/ui/screens/main_nav_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tavo/core/constants/app_assets.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/theme_extensions.dart';
import 'package:tavo/feature/Profile/ui/screens/profile_screen.dart';
import 'package:tavo/feature/home/ui/screens/home_screen.dart';
import 'package:tavo/feature/restaurant/ui/screens/restaurants_screen.dart';
import 'package:tavo/feature/booking/ui/screens/bookings_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    RestaurantsScreen(),
   BookingsScreen(showAppBar: false,),
   ProfileScreen(),
  ];

  final List<_NavItemData> _navItems = const [
    _NavItemData(icon: AppAssets.homeLogo, label: 'tab_home'),
    _NavItemData(icon: AppAssets.restaurant, label: 'tab_restaurants'),
    _NavItemData(icon: AppAssets.reservations, label: 'tab_reservations'),
    _NavItemData(icon: AppAssets.account, label: 'tab_account'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          border: Border(top: BorderSide(color: context.borderColor)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                _navItems.length,
                (index) => _buildNavItem(
                  icon: _navItems[index].icon,
                  label: _navItems[index].label,
                  index: index,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    final itemColor = isSelected ? ColorsManager.primaryColor : context.textSecondaryColor;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: isSelected ? ColorsManager.primaryColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              width: 24.w,
              height: 24.w,
              colorFilter: ColorFilter.mode(itemColor, BlendMode.srcIn),
            ),
            SizedBox(height: 4.h),
            Text(
              label.tr(),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: itemColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItemData {
  final String icon;
  final String label;

  const _NavItemData({required this.icon, required this.label});
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Text(
          title.tr(),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: context.textPrimaryColor,
          ),
        ),
      ),
    );
  }
}