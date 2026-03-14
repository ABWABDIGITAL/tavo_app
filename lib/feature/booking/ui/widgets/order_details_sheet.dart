// lib/feature/booking/ui/widgets/order_details_sheet.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tavo/core/constants/app_assets.dart';
import 'package:tavo/core/localization/locale_keys.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';
import 'package:tavo/feature/booking/data/model/order_details_model.dart';

class OrderDetailsSheet extends StatelessWidget {
  final OrderDetailsModel order;

  const OrderDetailsSheet({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12.h),
          Container(
            width: 50.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: ColorsManager.grey200,
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Text(
                  LocaleKeys.viewDetails.tr(),
                  style: TextStyle(
                    color: ColorsManager.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 34.r,
                    height: 34.r,
                    decoration: BoxDecoration(
                      color: ColorsManager.grey100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, size: 18.r, color: ColorsManager.black),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRestaurantInfo(context, locale),
                  SizedBox(height: 16.h),
                  _buildOrderInfo(context, locale),
                  SizedBox(height: 16.h),
                  _buildItemsSection(context, locale),
                  if (order.totalPrice > 0) ...[
                    SizedBox(height: 16.h),
                    _buildTotalSection(context),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantInfo(BuildContext context, String locale) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: ColorsManager.grey100.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CachedNetworkImage(
              imageUrl: order.restaurantLogo,
              width: 50.r,
              height: 50.r,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 50.r,
                height: 50.r,
                color: ColorsManager.grey200,
              ),
              errorWidget: (_, __, ___) => Container(
                width: 50.r,
                height: 50.r,
                color: ColorsManager.grey200,
                child: Icon(Icons.restaurant, size: 24.r, color: ColorsManager.darkGray300),
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.getRestaurantName(locale),
                  style: TextStyle(
                    color: ColorsManager.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  order.formattedDate,
                  style: TextStyles.font12DarkGray400Weight(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfo(BuildContext context, String locale) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            context,
            icon: AppAssets.receipt,
            label: LocaleKeys.bookingNumber.tr(),
            value: order.orderNumber,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Divider(height: 1, color: context.borderColor),
          ),
          _buildInfoRow(
            context,
            iconData: Icons.access_time_rounded,
            label: 'date'.tr(),
            value: order.formattedDate,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Divider(height: 1, color: context.borderColor),
          ),
          Row(
            children: [
              Container(
                width: 30.r,
                height: 30.r,
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(_statusIcon, size: 16.r, color: _statusColor),
              ),
              SizedBox(width: 12.w),
              Text(
                'status'.tr(),
                style: TextStyles.font12DarkGray400Weight(context),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  order.getStatusText(locale),
                  style: TextStyle(
                    color: _statusColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    String? icon,
    IconData? iconData,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 30.r,
          height: 30.r,
          decoration: BoxDecoration(
            color: ColorsManager.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: icon != null
              ? Center(
                  child: SvgPicture.asset(
                    icon,
                    width: 16.r,
                    height: 16.r,
                    colorFilter: const ColorFilter.mode(ColorsManager.primaryColor, BlendMode.srcIn),
                  ),
                )
              : Icon(iconData, size: 16.r, color: ColorsManager.primaryColor),
        ),
        SizedBox(width: 12.w),
        Text(label, style: TextStyles.font12DarkGray400Weight(context)),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              color: ColorsManager.black,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsSection(BuildContext context, String locale) {
    if (order.menuItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'order_items'.tr(),
          style: TextStyle(
            color: ColorsManager.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12.h),
        ...order.menuItems.map((item) => _buildMenuItem(context, item, locale)),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, OrderMenuItem item, String locale) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: CachedNetworkImage(
              imageUrl: item.imageUrl,
              width: 60.r,
              height: 60.r,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 60.r,
                height: 60.r,
                color: ColorsManager.grey100,
              ),
              errorWidget: (_, __, ___) => Container(
                width: 60.r,
                height: 60.r,
                color: ColorsManager.grey100,
                child: Icon(Icons.restaurant, size: 24.r, color: ColorsManager.darkGray300),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.getName(locale),
                  style: TextStyle(
                    color: ColorsManager.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.specifications.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 4.h,
                    children: item.specifications.map((spec) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: ColorsManager.primaryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          spec.name,
                          style: TextStyle(
                            color: ColorsManager.primaryColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Text(
                      '${item.price.toStringAsFixed(0)} ${LocaleKeys.currencySar.tr()}',
                      style: TextStyle(
                        color: ColorsManager.primaryColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: ColorsManager.grey100,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'x${item.quantity}',
                        style: TextStyle(
                          color: ColorsManager.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorsManager.primaryColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorsManager.primaryColor.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Text(
            'total'.tr(),
            style: TextStyle(
              color: ColorsManager.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            '${order.totalPrice.toStringAsFixed(0)} ${LocaleKeys.currencySar.tr()}',
            style: TextStyle(
              color: ColorsManager.primaryColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Color get _statusColor {
    switch (order.status) {
      case 'completed':
        return const Color(0xFF22A83A);
      case 'cancelled':
        return const Color(0xFFC62828);
      case 'confirmed':
        return const Color(0xFF1976D2);
      default:
        return const Color(0xFFFF9800);
    }
  }

  IconData get _statusIcon {
    switch (order.status) {
      case 'completed':
        return Icons.check_circle_outline;
      case 'cancelled':
        return Icons.cancel_outlined;
      case 'confirmed':
        return Icons.verified_outlined;
      default:
        return Icons.hourglass_bottom_rounded;
    }
  }
}