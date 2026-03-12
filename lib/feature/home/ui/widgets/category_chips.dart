import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';
import 'package:tavo/feature/home/data/models/category_model.dart';

class CategoryChips extends StatelessWidget {
  final List<CategoryModel> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategorySelected;

  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('🔥', style: TextStyle(fontSize: 18)),
              SizedBox(width: 6.w),
              Text(
                'browse_title'.tr(),
                style: TextStyles.font16Black500Weight(context),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 36.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            // ✅ REMOVED: reverse: locale == 'ar',
            // Flutter handles RTL automatically via Directionality
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: categories.length + 1,
            separatorBuilder: (_, __) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildChip(
                  context: context,
                  label: 'category_all'.tr(),
                  isSelected: selectedCategoryId == null,
                  onTap: () => onCategorySelected(null),
                );
              }

              final category = categories[index - 1];
              final isSelected = selectedCategoryId == category.id;

              return _buildChip(
                context: context,
                label: category.getName(locale),
                isSelected: isSelected,
                onTap: () => onCategorySelected(category.id),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: 18.w,
          vertical: 6.h,
        ),
        decoration: BoxDecoration(
          color: isSelected ? ColorsManager.primaryColor : context.cardColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? ColorsManager.primaryColor : context.borderColor,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: isSelected
                ? TextStyles.font12White500Weight(context)
                : TextStyles.font12Black400Weight(context),
          ),
        ),
      ),
    );
  }
}