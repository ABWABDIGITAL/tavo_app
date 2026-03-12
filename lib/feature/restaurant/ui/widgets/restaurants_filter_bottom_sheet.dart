import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tavo/core/constants/app_assets.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';

class RestaurantsFilterResult {
  final String? category;
  final double? minRating;

  const RestaurantsFilterResult({this.category, this.minRating});
}

class RestaurantsFilterBottomSheet extends StatefulWidget {
  final String? initialCategory;
  final double? initialMinRating;
  final List<String> categories;

  const RestaurantsFilterBottomSheet({
    super.key,
    required this.initialCategory,
    required this.initialMinRating,
    required this.categories,
  });

  @override
  State<RestaurantsFilterBottomSheet> createState() => _RestaurantsFilterBottomSheetState();
}

class _RestaurantsFilterBottomSheetState extends State<RestaurantsFilterBottomSheet> {
  String? _category;
  double _rating = 3.0;

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory;
    _rating = widget.initialMinRating ?? 3.0;
  }

  void _applyFilters() {
    Navigator.pop(
      context,
      RestaurantsFilterResult(
        category: _category,
        minRating: _rating,
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _category = null;
      _rating = 3.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
        border: Border(top: BorderSide(color: context.borderColor)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 18.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              SizedBox(height: 16.h),
              _buildCategorySection(context),
              SizedBox(height: 18.h),
              _buildRatingSection(context),
              SizedBox(height: 20.h),
              _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          'filter_restaurants'.tr(),
          style: TextStyles.font16Black500Weight(context).copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 34.r,
            height: 34.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: context.borderColor),
              color: context.backgroundColor,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppAssets.close,
              width: 14.r,
              height: 14.r,
              colorFilter: ColorFilter.mode(
                context.textSecondaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'restaurant_type'.tr(),
          style: TextStyles.font14Black500Weight(context),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: widget.categories.map((c) {
            final selected = _category == c;
            return _CategoryChip(
              label: c,
              selected: selected,
              onTap: () => setState(() => _category = selected ? null : c),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRatingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'rating'.tr(),
          style: TextStyles.font14Black500Weight(context),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Container(
              width: 54.w,
              height: 34.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.backgroundColor,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: context.borderColor),
              ),
              child: Text(
                _rating.toStringAsFixed(1),
                style: TextStyles.font14Black500Weight(context),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: List.generate(5, (i) {
                  final index = i + 1;
                  final isFilled = index <= _rating.round();

                  return GestureDetector(
                    onTap: () => setState(() => _rating = index.toDouble()),
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(start: 6.w),
                      child: SvgPicture.asset(
                        isFilled ? AppAssets.star : AppAssets.starOutline,
                        width: 22.r,
                        height: 22.r,
                        colorFilter: ColorFilter.mode(
                          isFilled ? ColorsManager.secondary100 : context.textSecondaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    final hasFilters = _category != null || _rating != 3.0;

    return Row(
      children: [
        if (hasFilters) ...[
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 48.h,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: context.borderColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26.r),
                  ),
                ),
                onPressed: _resetFilters,
                child: Text(
                  'reset'.tr(),
                  style: TextStyles.font14Black500Weight(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.textSecondaryColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
        ],
        Expanded(
          flex: hasFilters ? 2 : 1,
          child: SizedBox(
            height: 48.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.secondaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26.r),
                ),
              ),
              onPressed: _applyFilters,
              child: Text(
                'apply'.tr(),
                style: TextStyles.font16White500Weight(context),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selected
              ? ColorsManager.primaryColor.withValues(alpha: 0.10)
              : context.cardColor,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: selected ? ColorsManager.primaryColor : context.borderColor,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyles.font12Black400Weight(context).copyWith(
            fontWeight: FontWeight.w600,
            color: selected ? ColorsManager.primaryColor : context.textSecondaryColor,
          ),
        ),
      ),
    );
  }
}