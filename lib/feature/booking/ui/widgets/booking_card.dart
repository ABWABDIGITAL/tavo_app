// lib/feature/booking/ui/widgets/booking_card.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tavo/core/constants/app_assets.dart';
import 'package:tavo/core/localization/locale_keys.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';
import 'package:tavo/feature/booking/data/model/booking_status.dart';

class BookingCard extends StatelessWidget {
  final String bookingId;
  final String restaurantName;
  final String logoUrl;
  final double total;
  final String address;
  final String dateTimeText;
  final String seatsText;
  final BookingStatus status;
  final VoidCallback onDetails;
  final VoidCallback onDelete;
  final VoidCallback onRate;
  final VoidCallback onCancel;

  const BookingCard({
    super.key,
    required this.bookingId,
    required this.restaurantName,
    required this.logoUrl,
    required this.total,
    required this.address,
    required this.dateTimeText,
    required this.seatsText,
    required this.status,
    required this.onDetails,
    required this.onDelete,
    required this.onRate,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        children: [
          _buildTopSection(context),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(
                restaurantName,
                style: TextStyles.font14Black500Weight(context).copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              _PriceBadge(total: total),
            ],
          ),
          SizedBox(height: 12.h),
          _buildInfoSection(context),
          SizedBox(height: 14.h),
          _buildActionsRow(context),
        ],
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.bookingNumber.tr(),
                style: TextStyles.font12DarkGray400Weight(context),
              ),
              SizedBox(height: 2.h),
              Text(
                bookingId,
                style: TextStyles.font12Black400Weight(context).copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.network(
            logoUrl,
            width: 44.r,
            height: 44.r,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: ColorsManager.grey100,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.restaurant,
                size: 20.r,
                color: ColorsManager.darkGray300,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoRow(
                icon: AppAssets.location,
                text: address,
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  _InfoRow(
                    iconData: Icons.access_time_rounded,
                    text: dateTimeText,
                  ),
                  const Spacer(),
                  _InfoRow(
                    icon: AppAssets.chair,
                    text: seatsText,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionsRow(BuildContext context) {
    switch (status) {
      case BookingStatus.cancelled:
        return Row(
          children: [
            Expanded(
              child: _ActionButton(
                text: LocaleKeys.viewDetails.tr(),
                type: _ButtonType.secondary,
                onPressed: onDetails,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _ActionButton(
                text: LocaleKeys.delete.tr(),
                type: _ButtonType.danger,
                onPressed: onDelete,
              ),
            ),
          ],
        );
      case BookingStatus.completed:
        return Row(
          children: [
            Expanded(
              child: _ActionButton(
                text: LocaleKeys.viewDetails.tr(),
                type: _ButtonType.secondary,
                onPressed: onDetails,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _ActionButton(
                text: LocaleKeys.rate.tr(),
                type: _ButtonType.success,
                onPressed: onRate,
              ),
            ),
          ],
        );
      case BookingStatus.inProgress:
        return Row(
          children: [
            Expanded(
              child: _ActionButton(
                text: LocaleKeys.viewDetails.tr(),
                type: _ButtonType.primary,
                onPressed: onDetails,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _ActionButton(
                text: LocaleKeys.cancelBooking.tr(),
                type: _ButtonType.outlinedDanger,
                onPressed: onCancel,
              ),
            ),
          ],
        );
    }
  }
}

class _PriceBadge extends StatelessWidget {
  final double total;

  const _PriceBadge({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F7EB),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        '${total.toStringAsFixed(0)} ${LocaleKeys.currencySar.tr()}',
        style: TextStyles.font12DarkGray400Weight(context).copyWith(
          color: const Color(0xFF22A83A),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String? icon;
  final IconData? iconData;
  final String text;

  const _InfoRow({
    this.icon,
    this.iconData,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (iconData != null)
          Icon(
            iconData,
            size: 14.r,
            color: ColorsManager.darkGray300,
          )
        else if (icon != null)
          SvgPicture.asset(
            icon!,
            width: 14.r,
            height: 14.r,
            colorFilter: const ColorFilter.mode(
              ColorsManager.darkGray300,
              BlendMode.srcIn,
            ),
          ),
        SizedBox(width: 6.w),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.font12DarkGray400Weight(context),
          ),
        ),
      ],
    );
  }
}

enum _ButtonType { primary, secondary, success, danger, outlinedDanger }

class _ActionButton extends StatelessWidget {
  final String text;
  final _ButtonType type;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.text,
    required this.type,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38.h,
      child: type == _ButtonType.outlinedDanger
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFC62828), width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
              ),
              child: Text(
                text,
                style: TextStyles.font12Black400Weight(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFC62828),
                ),
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shadowColor: Colors.transparent,
                backgroundColor: _backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
              ),
              child: Text(
                text,
                style: TextStyles.font12Black400Weight(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: _textColor,
                ),
              ),
            ),
    );
  }

  Color get _backgroundColor {
    switch (type) {
      case _ButtonType.primary:
        return const Color(0xFF2F2F5F);
      case _ButtonType.secondary:
        return ColorsManager.grey100;
      case _ButtonType.success:
        return const Color(0xFF22A83A);
      case _ButtonType.danger:
        return const Color(0xFFC62828);
      case _ButtonType.outlinedDanger:
        return Colors.transparent;
    }
  }

  Color get _textColor {
    switch (type) {
      case _ButtonType.primary:
      case _ButtonType.success:
      case _ButtonType.danger:
        return ColorsManager.white;
      case _ButtonType.secondary:
        return ColorsManager.black;
      case _ButtonType.outlinedDanger:
        return const Color(0xFFC62828);
    }
  }
}