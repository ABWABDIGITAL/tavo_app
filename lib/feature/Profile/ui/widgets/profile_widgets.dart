// lib/feature/Profile/ui/widgets/profile_widgets.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tavo/core/animation/animation_helpers.dart';

import 'package:tavo/core/constants/app_assets.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';

class AnimatedAppBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  const AnimatedAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return FadeSlideTransition(
      beginOffset: const Offset(0, -0.2),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            BouncingButton(
              onTap: onBack ?? () => Navigator.of(context).maybePop(),
              child: Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: ColorsManager.grey100,
                  shape: BoxShape.circle,
                 
                ),
                child: Center(
                  child: SvgPicture.asset(
                    context.locale.languageCode == 'ar'
                        ? AppAssets.arrowRight
                        : AppAssets.arrowLeft,
                    width: 18.r,
                    height: 18.r,
                    colorFilter: const ColorFilter.mode(
                      ColorsManager.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: TextStyles.font16Black500Weight(context)              ),
            ),
            if (actions != null) ...actions!,
          ],
        ),
      ),
    );
  }
}

class GradientHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color>? gradientColors;

  const GradientHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ??
        [
          ColorsManager.primaryColor.withValues(alpha: 0.06),
          ColorsManager.primaryColor.withValues(alpha: 0.12),
        ];

    return ScaleInTransition(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: colors.last.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 52.r,
                    height: 52.r,
                    decoration: BoxDecoration(
                      color: ColorsManager.primaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(
                      icon,
                      size: 26.r,
                      color: ColorsManager.primaryColor,
                    ),
                  ),
                );
              },
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: ColorsManager.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyles.font12DarkGray400Weight(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedInfoCard extends StatelessWidget {
  final int index;
  final IconData icon;
  final String title;
  final String content;
  final Color? iconColor;
  final Widget? leading;

  const AnimatedInfoCard({
    super.key,
    required this.index,
    required this.icon,
    required this.title,
    required this.content,
    this.iconColor,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return FadeSlideTransition(
      index: index,
      delay: const Duration(milliseconds: 80),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: ColorsManager.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: context.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (leading != null)
                  leading!
                else
                  Container(
                    width: 36.r,
                    height: 36.r,
                    decoration: BoxDecoration(
                      color: (iconColor ?? ColorsManager.primaryColor)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        size: 18.r,
                        color: iconColor ?? ColorsManager.primaryColor,
                      ),
                    ),
                  ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: ColorsManager.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 48.w),
              child: Text(
                content,
                style: TextStyles.font12DarkGray400Weight(context).copyWith(
                  height: 1.9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedExpandableCard extends StatefulWidget {
  final int index;
  final String question;
  final String answer;
  final bool isExpanded;
  final VoidCallback onTap;

  const AnimatedExpandableCard({
    super.key,
    required this.index,
    required this.question,
    required this.answer,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<AnimatedExpandableCard> createState() => _AnimatedExpandableCardState();
}

class _AnimatedExpandableCardState extends State<AnimatedExpandableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedExpandableCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeSlideTransition(
      index: widget.index,
      delay: const Duration(milliseconds: 60),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: widget.isExpanded
                ? ColorsManager.primaryColor.withValues(alpha: 0.04)
                : ColorsManager.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: widget.isExpanded
                  ? ColorsManager.primaryColor.withValues(alpha: 0.2)
                  : context.borderColor,
              width: widget.isExpanded ? 1.5 : 1,
            ),
            boxShadow: widget.isExpanded
                ? [
                    BoxShadow(
                      color: ColorsManager.primaryColor.withValues(alpha: 0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 30.r,
                    height: 30.r,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: widget.isExpanded
                            ? [
                                ColorsManager.primaryColor.withValues(alpha: 0.15),
                                ColorsManager.primaryColor.withValues(alpha: 0.25),
                              ]
                            : [
                                ColorsManager.grey100,
                                ColorsManager.grey200,
                              ],
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: Text(
                        '${widget.index + 1}',
                        style: TextStyle(
                          color: widget.isExpanded
                              ? ColorsManager.primaryColor
                              : ColorsManager.darkGray300,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      widget.question,
                      style: TextStyle(
                        color: ColorsManager.black,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  RotationTransition(
                    turns: _rotationAnimation,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 28.r,
                      height: 28.r,
                      decoration: BoxDecoration(
                        color: widget.isExpanded
                            ? ColorsManager.primaryColor.withValues(alpha: 0.1)
                            : ColorsManager.grey100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 18.r,
                        color: widget.isExpanded
                            ? ColorsManager.primaryColor
                            : ColorsManager.darkGray300,
                      ),
                    ),
                  ),
                ],
              ),
              SizeTransition(
                sizeFactor: _expandAnimation,
                child: FadeTransition(
                  opacity: _expandAnimation,
                  child: Padding(
                    padding: EdgeInsets.only(top: 14.h, right: 42.w),
                    child: Text(
                      widget.answer,
                      style: TextStyles.font12DarkGray400Weight(context).copyWith(
                        height: 1.9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedContactCard extends StatelessWidget {
  final int index;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const AnimatedContactCard({
    super.key,
    required this.index,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FadeSlideTransition(
      index: index,
      delay: const Duration(milliseconds: 100),
      beginOffset: const Offset(0.2, 0),
      child: BouncingButton(
        onTap: onTap,
        child: Container(
          height: 68.h,
          decoration: BoxDecoration(
            color: ColorsManager.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: context.borderColor),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 400 + (index * 100)),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            color.withValues(alpha: 0.1),
                            color.withValues(alpha: 0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Center(
                        child: Icon(icon, size: 22.r, color: color),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: ColorsManager.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: ColorsManager.darkGray300,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 12.r,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FooterWidget extends StatelessWidget {
  final String text;

  const FooterWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return FadeSlideTransition(
      index: 10,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: ColorsManager.grey100.withValues(alpha: 0.5),
          border: Border(top: BorderSide(color: context.borderColor)),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time,
                size: 14.r,
                color: ColorsManager.darkGray300,
              ),
              SizedBox(width: 6.w),
              Text(
                text,
                style: TextStyle(
                  color: ColorsManager.darkGray300,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedLogo extends StatelessWidget {
  final double size;

  const AnimatedLogo({super.key, this.size = 90});

  @override
  Widget build(BuildContext context) {
    return ScaleInTransition(
      child: Container(
        width: size.r,
        height: size.r,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3D3D6B), Color(0xFF2F2F5F)],
          ),
          borderRadius: BorderRadius.circular(24.r),
          // boxShadow: [
          //   BoxShadow(
          //     color: const Color(0xFF2F2F5F).withValues(alpha: 0.35),
          //     blurRadius: 25,
          //     offset: const Offset(0, 10),
          //   ),
          // ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -10.r,
              right: -10.r,
              child: Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Center(
              child: Text(
                'Tavo',
                style: TextStyle(
                  color: ColorsManager.white,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}