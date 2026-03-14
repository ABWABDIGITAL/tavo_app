// lib/feature/restaurant/ui/screens/meal_customization_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/di/service_locator.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/feature/restaurant/data/model/cart_item_model.dart';
import 'package:tavo/feature/restaurant/data/model/menu_item_specification_model.dart';
import 'package:tavo/feature/restaurant/ui/logic/menu_item_specification_cubit.dart';
import 'package:tavo/feature/restaurant/ui/logic/menu_item_specification_state.dart';
import 'package:tavo/feature/restaurant/ui/logic/order_cubit.dart';

class MealCustomizationScreen extends StatelessWidget {
  final String restaurantId;
  final String menuItemId;

  const MealCustomizationScreen({
    super.key,
    required this.restaurantId,
    required this.menuItemId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MenuItemSpecificationCubit>(
        param1: restaurantId,
        param2: menuItemId,
      )..loadSpecification(),
      child: const _MealCustomizationView(),
    );
  }
}

class _MealCustomizationView extends StatefulWidget {
  const _MealCustomizationView();

  @override
  State<_MealCustomizationView> createState() => _MealCustomizationViewState();
}

class _MealCustomizationViewState extends State<_MealCustomizationView> {
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  /// ✅ Build CartItemModel from selections and add to OrderCubit
  void _onConfirm() {
    final specCubit = context.read<MenuItemSpecificationCubit>();
    final specState = specCubit.state;
    final spec = specState.specification;
    if (spec == null) return;

    final locale = context.locale.languageCode;

    // Build specifications list from selections
    final List<CartSpecification> cartSpecs = [];

    specState.selections.forEach((groupKey, value) {
      if (value is SpecificationOption) {
        cartSpecs.add(CartSpecification(
          key: groupKey,
          name: value.title,
          price: value.price,
        ));
      } else if (value is Set<SpecificationOption>) {
        for (final option in value) {
          cartSpecs.add(CartSpecification(
            key: groupKey,
            name: option.title,
            price: option.price,
          ));
        }
      }
    });

    // Create cart item
    final cartItem = CartItemModel(
      menuItemId: spec.id,
      name: spec.getName(locale),
      imageUrl: spec.imageUrl,
      price: spec.price,
      quantity: specState.quantity,
      specifications: cartSpecs,
    );

    // Add to order cubit (provided by parent screen)
    try {
      context.read<OrderCubit>().addToCart(cartItem);
    } catch (_) {
      // OrderCubit not provided - just pop
    }

    Navigator.of(context).pop(cartItem);
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;

    return Scaffold(
      backgroundColor: ColorsManager.white,
      body: SafeArea(
        child: BlocBuilder<MenuItemSpecificationCubit, MenuItemSpecificationState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(
                child: CircularProgressIndicator(color: ColorsManager.primaryColor),
              );
            }

            if (state.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48.r, color: ColorsManager.darkGray300),
                    SizedBox(height: 12.h),
                    Text(state.error!, style: TextStyles.font14DarkGray400Weight(context)),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<MenuItemSpecificationCubit>().loadSpecification(),
                      child: Text('retry'.tr()),
                    ),
                  ],
                ),
              );
            }

            final spec = state.specification;
            if (spec == null) return const SizedBox.shrink();

            return Padding(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
              child: Column(
                children: [
                  _buildHeader(context),
                  SizedBox(height: 12.h),
                  _buildImageBanner(context, spec, locale),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...spec.getSpecifications(locale).map((group) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (group.options.any((o) => o.price > 0))
                                  _buildSectionTitleWithPrice(
                                    context,
                                    group.title,
                                    '${group.options.where((o) => o.price > 0).first.price.toStringAsFixed(0)} ${'currency'.tr()}',
                                  )
                                else
                                  _buildSectionTitle(context, group.title),
                                SizedBox(height: 8.h),
                                _buildOptionsWrap(
                                  options: group.options,
                                  groupKey: group.key,
                                  type: group.type,
                                  state: state,
                                ),
                                SizedBox(height: 14.h),
                              ],
                            );
                          }),
                          _buildSectionTitle(context, 'notes'.tr()),
                          SizedBox(height: 8.h),
                          _buildNotesField(context),
                        ],
                      ),
                    ),
                  ),
                  _buildConfirmButton(context, state),
                ],
              ),
            );
          },
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

  Widget _buildImageBanner(
    BuildContext context,
    MenuItemSpecificationModel spec,
    String locale,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: Stack(
        children: [
          SizedBox(
            height: 110.h,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: spec.imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: ColorsManager.grey100),
              errorWidget: (_, __, ___) => Container(color: ColorsManager.grey100),
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
                    ColorsManager.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: 10.h,
            start: 12.w,
            child: Text(
              spec.getName(locale),
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
    return Text(title, style: TextStyles.font16Black500Weight(context));
  }

  Widget _buildSectionTitleWithPrice(BuildContext context, String title, String price) {
    return Row(
      children: [
        Text(title, style: TextStyles.font16Black500Weight(context)),
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
    required List<SpecificationOption> options,
    required String groupKey,
    required SpecificationType type,
    required MenuItemSpecificationState state,
  }) {
    final cubit = context.read<MenuItemSpecificationCubit>();

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: options.map((option) {
        final isSelected = cubit.isOptionSelected(groupKey, option);

        return _OptionChip(
          text: option.price > 0
              ? '${option.title} (+${option.price.toStringAsFixed(0)})'
              : option.title,
          selected: isSelected,
          onTap: () {
            if (type == SpecificationType.single) {
              cubit.selectSingleOption(groupKey, option);
            } else {
              cubit.toggleMultipleOption(groupKey, option);
            }
          },
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
        onChanged: (v) => context.read<MenuItemSpecificationCubit>().updateNotes(v),
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

  // ✅ Confirm button now adds to cart
  Widget _buildConfirmButton(BuildContext context, MenuItemSpecificationState state) {
    return SizedBox(
      height: 48.h,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _onConfirm,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: ColorsManager.secondary100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
        ),
        child: Text(
          '${'confirm_customization'.tr()} - ${state.totalPrice.toStringAsFixed(0)} ${'currency'.tr()}',
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
    final bg = selected ? ColorsManager.secondary100.withOpacity(0.1) : ColorsManager.white;

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