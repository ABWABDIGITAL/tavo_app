import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';

class BottomCartLine {
  final String id;
  final String imageUrl;
  final int qty;

  BottomCartLine({
    required this.id,
    required this.imageUrl,
    required this.qty,
  });
}

class BottomBookingBar extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonTextKey;
  final double total;
  final List<BottomCartLine> cartLines;
  final Function(String) onAddItem;
  final Function(String) onRemoveItem;

  const BottomBookingBar({
    super.key,
    required this.onPressed,
    required this.buttonTextKey,
    required this.total,
    required this.cartLines,
    required this.onAddItem,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cart Items Preview
            if (cartLines.isNotEmpty) ...[
              SizedBox(
                height: 50.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: cartLines.length,
                  separatorBuilder: (_, __) => SizedBox(width: 8.w),
                  itemBuilder: (_, i) {
                    final line = cartLines[i];
                    return _CartItemPreview(
                      line: line,
                      onAdd: () => onAddItem(line.id),
                      onRemove: () => onRemoveItem(line.id),
                    );
                  },
                ),
              ),
              SizedBox(height: 12.h),
            ],
            
            // Total & Button Row
            Row(
              children: [
                // Total
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المجموع',
                      style: TextStyles.font12DarkGray400Weight(context),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${total.toStringAsFixed(0)} ر.س',
                      style: TextStyles.font18Black400Weight(context).copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(width: 16.w),
                
                // Book Button
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                      ),
                      child: Text(
                        buttonTextKey,
                        style: TextStyles.font16Black500Weight(context).copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemPreview extends StatelessWidget {
  final BottomCartLine line;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const _CartItemPreview({
    required this.line,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      decoration: BoxDecoration(
        color: ColorsManager.grey100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Stack(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CachedNetworkImage(
              imageUrl: line.imageUrl,
              fit: BoxFit.cover,
              width: 80.w,
              height: 50.h,
              placeholder: (_, __) => Container(color: ColorsManager.grey100),
              errorWidget: (_, __, ___) => Container(color: ColorsManager.grey100),
            ),
          ),
          
          // Quantity Badge
          Positioned(
            top: 4.h,
            right: 4.w,
            child: Container(
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(
                color: ColorsManager.primaryColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${line.qty}',
                style: TextStyles.font12White400Weight(context).copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ),
          
          // Remove Button
          Positioned(
            top: 4.h,
            left: 4.w,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 18.r,
                height: 18.r,
                decoration: BoxDecoration(
                  color: ColorsManager.white,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.remove,
                  size: 12.r,
                  color: ColorsManager.redButton,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}