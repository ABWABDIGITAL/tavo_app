import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/theme_extensions.dart';
import 'my_button.dart';
import 'my_outline_button.dart';

class PriceBreakdownBottomSheet extends StatefulWidget {
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final String currency;
  final String? appliedPromoCode;
  final Future<void> Function(String promoCode)? onApplyPromo;
  final String buttonLabel;
  final VoidCallback? onButtonPressed;

  const PriceBreakdownBottomSheet({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.currency,
    this.appliedPromoCode,
    this.onApplyPromo,
    required this.buttonLabel,
    this.onButtonPressed,
  });

  @override
  State<PriceBreakdownBottomSheet> createState() =>
      _PriceBreakdownBottomSheetState();
}

class _PriceBreakdownBottomSheetState extends State<PriceBreakdownBottomSheet> {
  final _promoController = TextEditingController();
  bool _isApplying = false;

  @override
  void initState() {
    super.initState();
    if (widget.appliedPromoCode != null) {
      _promoController.text = widget.appliedPromoCode!;
    }
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  String _formatPrice(double price) {
    final upper = widget.currency.toUpperCase();
    final isKwd = upper == 'KWD' || widget.currency == 'د.ك';
    return price.toStringAsFixed(isKwd ? 3 : 2);
  }

  Future<void> _applyPromo() async {
    final code = _promoController.text.trim();
    if (code.isEmpty || widget.onApplyPromo == null) return;

    setState(() => _isApplying = true);
    try {
      await widget.onApplyPromo!(code);
    } finally {
      if (mounted) setState(() => _isApplying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: context.textSecondaryColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // Promo Code Row
            if (widget.onApplyPromo != null) ...[
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: context.dividerColor),
                      ),
                      child: TextField(
                        controller: _promoController,
                        style: TextStyles.font14DarkGray400Weight(context)
                            .copyWith(color: context.textPrimaryColor),
                        decoration: InputDecoration(
                          hintText: 'breakdown.promo_hint'.tr(),
                          hintStyle:
                              TextStyles.font12DarkGray400Weight(context),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  SizedBox(
                    height: 44.h,
                    child: MyOutlineButton(
                      label: _isApplying
                          ? '...'
                          : 'breakdown.apply'.tr(),
                      onPressed: _isApplying ? null : _applyPromo,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
            // Item Subtotal
            _PriceRow(
              label: 'breakdown.item_subtotal'.tr(),
              value: '${_formatPrice(widget.subtotal)} ${widget.currency}',
              context: context,
            ),
            SizedBox(height: 12.h),
            // Delivery
            _PriceRow(
              label: 'breakdown.delivery'.tr(),
              value: widget.deliveryFee == 0
                  ? 'breakdown.free'.tr()
                  : '${_formatPrice(widget.deliveryFee)} ${widget.currency}',
              context: context,
            ),
            SizedBox(height: 12.h),
            // Discount
            if (widget.discount > 0) ...[
              _PriceRow(
                label: 'breakdown.discount'.tr(),
                value:
                    '-${_formatPrice(widget.discount)} ${widget.currency}',
                context: context,
                valueColor: ColorsManager.errorColor,
              ),
              SizedBox(height: 12.h),
            ],
            Divider(color: context.dividerColor),
            SizedBox(height: 8.h),
            // Total
            Row(
              children: [
                Text(
                  'breakdown.total'.tr(),
                  style: TextStyles.font16Black500Weight(context).copyWith(
                    color: context.textPrimaryColor,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_formatPrice(widget.total)} ${widget.currency}',
                  style: TextStyles.font16Black500Weight(context).copyWith(
                    color: context.textPrimaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            // Button
            MyButton(
              onPressed: widget.onButtonPressed ?? () => Navigator.pop(context),
              height: 48.h,
              minWidth: double.infinity,
              label: widget.buttonLabel,
              labelStyle: TextStyles.font14White500Weight(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final BuildContext context;
  final Color? valueColor;

  const _PriceRow({
    required this.label,
    required this.value,
    required this.context,
    this.valueColor,
  });

  @override
  Widget build(BuildContext buildContext) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyles.font14DarkGray400Weight(context).copyWith(
            color: context.textSecondaryColor,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyles.font14Black500Weight(context).copyWith(
            color: valueColor ?? context.textPrimaryColor,
          ),
        ),
      ],
    );
  }
}
