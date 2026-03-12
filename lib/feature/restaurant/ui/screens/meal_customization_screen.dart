import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/feature/restaurant/data/model/menu_item_model.dart';


class MealCustomizationScreen extends StatefulWidget {
  final MenuItemModel item;

  const MealCustomizationScreen({super.key, required this.item});

  @override
  State<MealCustomizationScreen> createState() => _MealCustomizationScreenState();
}

class _MealCustomizationScreenState extends State<MealCustomizationScreen> {
  final _notesController = TextEditingController();

  final _cookMethods = const ['مقلي', 'مشوي', 'مسلوق', 'مطهو بالفرن'];
  final _sides = const ['أرز أبيض', 'بطاطس مقلية', 'خضار سوتيه', 'سلطة'];
  final _sizes = const ['حجم صغير', 'حجم متوسط', 'حجم كبير'];

  String? _selectedCook;
  final Set<String> _selectedSides = {};
  String? _selectedSize;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final locale = context.locale.languageCode;  // ✅ Get locale

    return Scaffold(
      backgroundColor: ColorsManager.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
          child: Column(
            children: [
              _buildHeader(context),
              SizedBox(height: 12.h),
              _buildImageBanner(context, item, locale),  // ✅ Pass locale
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(context, 'cooking_method'.tr()),
                      SizedBox(height: 8.h),
                      _buildOptionsWrap(
                        options: _cookMethods,
                        selectedCheck: (t) => _selectedCook == t,
                        onSelect: (t) => setState(() => _selectedCook = t),
                      ),
                      SizedBox(height: 14.h),
                      _buildSectionTitleWithPrice(context, 'side_dishes'.tr(), '36 ${'currency'.tr()}'),
                      SizedBox(height: 8.h),
                      _buildOptionsWrap(
                        options: _sides,
                        selectedCheck: (t) => _selectedSides.contains(t),
                        onSelect: (t) {
                          setState(() {
                            if (_selectedSides.contains(t)) {
                              _selectedSides.remove(t);
                            } else {
                              _selectedSides.add(t);
                            }
                          });
                        },
                      ),
                      SizedBox(height: 14.h),
                      _buildSectionTitleWithPrice(
                        context,
                        'dish_size'.tr(),
                        '${item.price.toStringAsFixed(0)} ${'currency'.tr()}',
                      ),
                      SizedBox(height: 8.h),
                      _buildOptionsWrap(
                        options: _sizes,
                        selectedCheck: (t) => _selectedSize == t,
                        onSelect: (t) => setState(() => _selectedSize = t),
                      ),
                      SizedBox(height: 14.h),
                      _buildSectionTitle(context, 'notes'.tr()),
                      SizedBox(height: 8.h),
                      _buildNotesField(context),
                    ],
                  ),
                ),
              ),
              _buildConfirmButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
            width: 36.r,
            height: 36.r,
            decoration: const BoxDecoration(
              color: ColorsManager.grey100,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.r,
              color: ColorsManager.black,
            ),
          ),
        ),
        const Spacer(),
        Text(
          'customize_meal'.tr(),
          style: TextStyles.font14Black500Weight(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        SizedBox(width: 36.r),
      ],
    );
  }

  Widget _buildImageBanner(BuildContext context, MenuItemModel item, String locale) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: Stack(
        children: [
          SizedBox(
            height: 110.h,
            width: double.infinity,
            child: Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: ColorsManager.grey100),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    ColorsManager.black.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: 10.h,
            start: 12.w,
            child: Text(
              item.getTitle(locale),  // ✅ Fixed: use getTitle(locale)
              style: TextStyles.font14White500Weight(context).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyles.font16Black500Weight(context),
    );
  }

  Widget _buildSectionTitleWithPrice(BuildContext context, String title, String price) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyles.font16Black500Weight(context),
        ),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F1F1),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Text(
            price,
            style: TextStyles.font12Black400Weight(context).copyWith(
              color: ColorsManager.secondary100,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsWrap({
    required List<String> options,
    required bool Function(String) selectedCheck,
    required void Function(String) onSelect,
  }) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: options.map((t) {
        return _OptionChip(
          text: t,
          selected: selectedCheck(t),
          onTap: () => onSelect(t),
        );
      }).toList(),
    );
  }

  Widget _buildNotesField(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorsManager.grey100),
      ),
      child: TextField(
        controller: _notesController,
        minLines: 3,
        maxLines: 5,
        style: TextStyles.font12Black400Weight(context),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          hintText: 'notes_hint'.tr(),
          hintStyle: TextStyles.font16Black500Weight(context).copyWith(
            color: ColorsManager.darkGray300,
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      height: 48.h,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).maybePop(),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: ColorsManager.secondary100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
        ),
        child: Text(
          'confirm_customization'.tr(),
          style: TextStyles.font14White500Weight(context).copyWith(
            color: ColorsManager.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _OptionChip({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? ColorsManager.secondary100 : ColorsManager.grey200;
    final bg = selected ? ColorsManager.secondary100.withValues(alpha: 0.1) : ColorsManager.white;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: borderColor, width: selected ? 1.5 : 1),
        ),
        child: Text(
          text,
          style: TextStyles.font12Black400Weight(context).copyWith(
            color: selected ? ColorsManager.secondary100 : ColorsManager.black,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}