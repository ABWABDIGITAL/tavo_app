import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tavo/core/constants/app_assets.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';

class BottomCartLine {
  final String id;
  final String imageUrl;
  final int qty;

  const BottomCartLine({
    required this.id,
    required this.imageUrl,
    required this.qty,
  });
}

class BottomBookingBar extends StatelessWidget {
  final num? total;
  final VoidCallback? onPressed;
  final String buttonTextKey;
  final List<BottomCartLine> cartLines;
  final void Function(String id)? onAddItem;
  final void Function(String id)? onRemoveItem;

  const BottomBookingBar({
    super.key,
    required this.onPressed,
    this.total,
    this.buttonTextKey = 'book_your_seat',
    this.cartLines = const [],
    this.onAddItem,
    this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    final hasCart = cartLines.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0,), 
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(top: BorderSide(color: context.borderColor)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasCart) ...[
                    _MiniCartStrip(
                      lines: cartLines,
                      onAddItem: onAddItem,
                      onRemoveItem: onRemoveItem,
                    ),
                    SizedBox(height: 10.h),
                  ],
                  hasCart
                      ? _BookWithTotalOneContainer(
                          context: context,
                          total: total,
                          onPressed: onPressed,
                          buttonTextKey: buttonTextKey,
                        )
                      : _BookOnlyButton(
                          context: context,
                          onPressed: onPressed,
                          buttonTextKey: buttonTextKey,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BookOnlyButton extends StatelessWidget {
  final BuildContext context;
  final VoidCallback? onPressed;
  final String buttonTextKey;

  const _BookOnlyButton({
    required this.context,
    required this.onPressed,
    required this.buttonTextKey,
  });

  @override
  Widget build(BuildContext _) {
    return SizedBox(
      height: 52.h,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: ColorsManager.secondary100,
          disabledBackgroundColor: ColorsManager.secondary100.withValues(alpha: 0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
        ),
        child: Text(
          buttonTextKey.tr(),
          style: TextStyles.font16White500Weight(context).copyWith(
            color: ColorsManager.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _BookWithTotalOneContainer extends StatelessWidget {
  final BuildContext context;
  final num? total;
  final VoidCallback? onPressed;
  final String buttonTextKey;

  const _BookWithTotalOneContainer({
    required this.context,
    required this.total,
    required this.onPressed,
    required this.buttonTextKey,
  });

  @override
  Widget build(BuildContext _) {
    final isEnabled = onPressed != null;
    final bg = isEnabled
        ? ColorsManager.secondary100
        : ColorsManager.secondary100.withValues(alpha: 0.35);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(28.r),
        child: Container(
          height: 52.h,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(28.r),
          ),
          child: Row(
            children: [
              Text(
                buttonTextKey.tr(),
                style: TextStyles.font16White500Weight(context).copyWith(
                  color: ColorsManager.black,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                '>>',
                style: TextStyles.font24White500Weight(context).copyWith(
                  color: ColorsManager.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: ColorsManager.black.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: Text(
                  '${(total ?? 0).toStringAsFixed(0)} ر.س',
                  style: TextStyles.font14White500Weight(context).copyWith(
                    color: ColorsManager.white,
                    fontWeight: FontWeight.w700,
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

class _MiniCartStrip extends StatelessWidget {
  final List<BottomCartLine> lines;
  final void Function(String id)? onAddItem;
  final void Function(String id)? onRemoveItem;

  const _MiniCartStrip({
    required this.lines,
    required this.onAddItem,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.RTL;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          height: 92.h,
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: ColorsManager.transparent,
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(color: ColorsManager.grey100),
          ),
          child: Align(
            alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
            child: SizedBox(
              height: 74.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                reverse: isRtl,
                itemCount: lines.length,
                separatorBuilder: (_, __) => SizedBox(width: 10.w),
                itemBuilder: (_, i) {
                  final line = lines[i];
                  return _MiniCartItem(
                    line: line,
                    onAdd: onAddItem == null ? null : () => onAddItem!(line.id),
                    onRemove: onRemoveItem == null ? null : () => onRemoveItem!(line.id),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniCartItem extends StatelessWidget {
  final BottomCartLine line;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;

  const _MiniCartItem({
    required this.line,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88.w,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18.r),
            child: Image.network(
              line.imageUrl,
              width: 88.w,
              height: 96.h,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: ColorsManager.grey100),
            ),
          ),
          PositionedDirectional(
            bottom: 6.h,
            start: 6.w,
            end: 6.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: ColorsManager.white.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SvgCircleButton(
                    asset: AppAssets.minus,
                    onTap: onRemove,
                  ),
                  Text(
                    '${line.qty}',
                    style: TextStyles.font12White400Weight(context).copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  _SvgCircleButton(
                    asset: AppAssets.plus,
                    onTap: onAdd,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SvgCircleButton extends StatelessWidget {
  final String asset;
  final VoidCallback? onTap;

  const _SvgCircleButton({
    required this.asset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: SvgPicture.asset(
          asset,
          width: 18.r,
          height: 18.r,
          colorFilter: const ColorFilter.mode(ColorsManager.black, BlendMode.srcIn),
        ),
      ),
    );
  }
}