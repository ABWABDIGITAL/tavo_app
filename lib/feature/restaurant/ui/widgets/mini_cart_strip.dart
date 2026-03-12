import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tavo/core/constants/app_assets.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';

class CartLine {
  final String id;
  final String title;
  final String imageUrl;
  final int qty;

  const CartLine({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.qty,
  });
}

class _MiniCartStrip extends StatelessWidget {
  final List<CartLine> lines;
  final void Function(String id) onAdd;
  final void Function(String id) onRemove;

  const _MiniCartStrip({
    required this.lines,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: ColorsManager.grey100),
        // بدون shadow وبدون gradient
      ),
      child: SizedBox(
        height: 74.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          reverse: Directionality.of(context) == TextDirection.rtl,
          itemCount: lines.length,
          separatorBuilder: (_, __) => SizedBox(width: 10.w),
          itemBuilder: (_, i) {
            final line = lines[i];
            return _MiniCartItem(
              line: line,
              onAdd: () => onAdd(line.id),
              onRemove: () => onRemove(line.id),
            );
          },
        ),
      ),
    );
  }
}

class _MiniCartItem extends StatelessWidget {
  final CartLine line;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const _MiniCartItem({
    required this.line,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 82.w,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18.r),
            child: Image.network(
              line.imageUrl,
              width: 82.w,
              height: 74.h,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: ColorsManager.grey100),
            ),
          ),

          // شريط التحكم (− qty +) فوق الصورة
          PositionedDirectional(
            bottom: 6.h,
            start: 6.w,
            end: 6.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: ColorsManager.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SvgCircleButton(
                    asset: AppAssets.minus, // أضفها في AppAssets
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
  final VoidCallback onTap;

  const _SvgCircleButton({
    required this.asset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 20.r,
        height: 20.r,
        alignment: Alignment.center,
        
        child: SvgPicture.asset(
          asset,
          width: 14.r,
          height: 14.r,
          colorFilter: const ColorFilter.mode(ColorsManager.black, BlendMode.srcIn),
        ),
      ),
    );
  }
}