import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/feature/home/data/models/hero_model.dart';

class PromoBanner extends StatefulWidget {
  final List<HeroModel> heroes;

  const PromoBanner({super.key, required this.heroes});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  late final PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    if (widget.heroes.length > 1) {
      _startAutoScroll();
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (widget.heroes.isEmpty) return;
      final nextPage = (_currentPage + 1) % widget.heroes.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.heroes.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 150.h,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.heroes.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return AnimatedScale(
                scale: index == _currentPage ? 1.0 : 0.92,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: _buildBannerItem(widget.heroes[index]),
              );
            },
          ),
          if (widget.heroes.length > 1)
            Positioned(
              bottom: 10.h,
              left: 0,
              right: 0,
              child: _buildDots(),
            ),
        ],
      ),
    );
  }

  Widget _buildBannerItem(HeroModel hero) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: hero.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: ColorsManager.grey100,
              child: const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: ColorsManager.primaryColor,
                  strokeWidth: 2,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: ColorsManager.grey100,
              child: Icon(
                Icons.image,
                size: 40.w,
                color: ColorsManager.darkGray300,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'promo_title'.tr(),
                  style: textTheme.bodyLarge?.copyWith(
                    color: ColorsManager.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'promo_subtitle'.tr(),
                  style: textTheme.bodySmall?.copyWith(
                    color: ColorsManager.white.withValues(alpha: 0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () {
                    if (hero.redirectUrl != null) {
                      // Handle redirect
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: ColorsManager.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      'book_now'.tr(),
                      style: textTheme.bodySmall?.copyWith(
                        color: ColorsManager.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.heroes.length, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: isActive ? 20.w : 6.w,
          height: 6.h,
          decoration: BoxDecoration(
            color: isActive
                ? ColorsManager.white
                : ColorsManager.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(3.r),
          ),
        );
      }),
    );
  }
}