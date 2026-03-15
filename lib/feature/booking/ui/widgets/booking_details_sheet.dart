// lib/feature/booking/ui/widgets/booking_details_sheet.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/localization/locale_keys.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';
import 'package:tavo/feature/booking/data/model/booking_model.dart';
import 'package:tavo/feature/booking/data/model/order_details_model.dart';

class BookingDetailsSheet extends StatelessWidget {
  final BookingModel booking;
  final OrderDetailsModel? order;

  const BookingDetailsSheet({super.key, required this.booking, this.order});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
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
                    child: Icon(
                      Icons.close,
                      size: 18.r,
                      color: ColorsManager.black,
                    ),
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
                  _buildBookingInfo(context, locale),
                  if (order != null && order!.menuItems.isNotEmpty) ...[
                    SizedBox(height: 16.h),
                    _buildItemsSection(context, locale),
                  ],
                  if (order != null && order!.totalPrice > 0) ...[
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
        color: ColorsManager.grey100.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 50.r,
            height: 50.r,
            decoration: BoxDecoration(
              color: ColorsManager.grey200,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: booking.restaurantLogoUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      booking.restaurantLogoUrl,
                      width: 50.r,
                      height: 50.r,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.restaurant,
                        size: 24.r,
                        color: ColorsManager.darkGray300,
                      ),
                    ),
                  )
                : Icon(
                    Icons.restaurant,
                    size: 24.r,
                    color: ColorsManager.darkGray300,
                  ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.getName(locale),
                  style: TextStyle(
                    color: ColorsManager.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  booking.getFormattedDate(locale),
                  style: TextStyles.font12DarkGray400Weight(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingInfo(BuildContext context, String locale) {
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
            iconData: Icons.event_seat,
            label: 'tables'.tr(),
            value: booking.getTablesText().isNotEmpty
                ? booking.getTablesText()
                : '-',
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Divider(height: 1, color: context.borderColor),
          ),
          _buildInfoRow(
            context,
            iconData: Icons.access_time_rounded,
            label: 'time'.tr(),
            value: booking.getTimeRange(locale),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Divider(height: 1, color: context.borderColor),
          ),
          _buildInfoRow(
            context,
            iconData: Icons.people_outline,
            label: 'guests'.tr(),
            value: '${booking.guestsCount}',
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
                  color: _statusColor.withValues(alpha: 0.1),
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
                  color: _statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  booking.getStatusText(locale),
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
    required IconData iconData,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 30.r,
          height: 30.r,
          decoration: BoxDecoration(
            color: ColorsManager.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(iconData, size: 16.r, color: ColorsManager.primaryColor),
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
    if (order == null || order!.menuItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.orderItems.tr(),
          style: TextStyle(
            color: ColorsManager.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12.h),
        ...order!.menuItems.map(
          (item) => _buildMenuItem(context, item, locale),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    OrderMenuItem item,
    String locale,
  ) {
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorsManager.primaryColor.withValues(
                            alpha: 0.08,
                          ),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          spec.price > 0
                              ? '${spec.name} (+${spec.price.toStringAsFixed(0)})'
                              : spec.name,
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
                      '${item.unitPrice.toStringAsFixed(0)} ${LocaleKeys.currencySar.tr()}',
                      style: TextStyle(
                        color: ColorsManager.darkGray300,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
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
          SizedBox(width: 12.w),
          Text(
            '${item.totalPrice.toStringAsFixed(0)} ${LocaleKeys.currencySar.tr()}',
            style: TextStyle(
              color: ColorsManager.primaryColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection(BuildContext context) {
    if (order == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorsManager.primaryColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ColorsManager.primaryColor.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          _buildPriceRow(context, LocaleKeys.subtotal.tr(), order!.subtotal),
          if (order!.tax > 0) ...[
            SizedBox(height: 8.h),
            _buildPriceRow(context, LocaleKeys.tax.tr(), order!.tax),
          ],
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(height: 1, color: context.borderColor),
          ),
          Row(
            children: [
              Text(
                LocaleKeys.total.tr(),
                style: TextStyle(
                  color: ColorsManager.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '${order!.totalPrice.toStringAsFixed(0)} ${LocaleKeys.currencySar.tr()}',
                style: TextStyle(
                  color: ColorsManager.primaryColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context, String label, double amount) {
    return Row(
      children: [
        Text(label, style: TextStyles.font12DarkGray400Weight(context)),
        const Spacer(),
        Text(
          '${amount.toStringAsFixed(0)} ${LocaleKeys.currencySar.tr()}',
          style: TextStyle(
            color: ColorsManager.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color get _statusColor {
    switch (booking.status) {
      case 'completed':
        return const Color(0xFF22A83A);
      case 'cancelled':
      case 'no_show':
        return const Color(0xFFC62828);
      case 'confirmed':
        return const Color(0xFF1976D2);
      case 'seated':
        return const Color(0xFF2F2F5F);
      default:
        return const Color(0xFFFF9800);
    }
  }

  IconData get _statusIcon {
    switch (booking.status) {
      case 'completed':
        return Icons.check_circle_outline;
      case 'cancelled':
      case 'no_show':
        return Icons.cancel_outlined;
      case 'confirmed':
        return Icons.verified_outlined;
      case 'seated':
        return Icons.event_seat_outlined;
      default:
        return Icons.hourglass_bottom_rounded;
    }
  }
}
