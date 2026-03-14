import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tavo/core/constants/app_assets.dart';
import 'package:tavo/core/di/service_locator.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';
import 'package:tavo/feature/restaurant/data/model/restaurant_details_model.dart';
import 'package:tavo/feature/restaurant/ui/logic/order_cubit.dart';
import 'package:tavo/feature/restaurant/ui/logic/order_state.dart';
import 'package:tavo/feature/restaurant/ui/logic/restaurant_details_cubit.dart';
import 'package:tavo/feature/restaurant/ui/logic/restaurant_details_state.dart';
import 'package:tavo/feature/restaurant/ui/screens/meal_customization_screen.dart';
import 'package:tavo/feature/restaurant/ui/screens/restaurant_map_screen.dart';
import 'package:tavo/feature/restaurant/ui/screens/restaurant_menu_screen.dart';
import 'package:tavo/feature/restaurant/ui/widgets/bottom_booking_bar.dart';
import 'package:tavo/feature/restaurant/ui/widgets/menu_item_card.dart';
import 'package:tavo/feature/restaurant/ui/widgets/restaurant_details_header.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  final String restaurantId;

  const RestaurantDetailsScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<RestaurantDetailsCubit>()..loadRestaurantDetails(restaurantId),
        ),
        BlocProvider(
          create: (_) => getIt<OrderCubit>(param1: restaurantId),
        ),
      ],
      child: _RestaurantDetailsView(restaurantId: restaurantId),
    );
  }
}

class _RestaurantDetailsView extends StatelessWidget {
  final String restaurantId;

  const _RestaurantDetailsView({required this.restaurantId});

  List<BottomCartLine> _mapCartLines(OrderState orderState) {
    return orderState.cartItems.map((item) {
      return BottomCartLine(
        id: item.menuItemId,
        imageUrl: item.imageUrl,
        qty: item.quantity,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;

    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, orderState) {
        if (orderState.success) {
          context.read<OrderCubit>().clearSuccess();
          _showOrderSuccessSheet(context, orderState.orderId ?? '');
        }

        if (orderState.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  SvgPicture.asset(
                    AppAssets.close,
                    width: 20.r,
                    height: 20.r,
                    colorFilter: const ColorFilter.mode(ColorsManager.white, BlendMode.srcIn),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(child: Text(orderState.error!)),
                ],
              ),
              backgroundColor: const Color(0xFFC62828),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              margin: EdgeInsets.all(16.w),
            ),
          );
          context.read<OrderCubit>().clearError();
        }
      },
      builder: (context, orderState) {
        return BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
          builder: (context, state) {
            if (state.loading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: ColorsManager.primaryColor,
                  ),
                ),
              );
            }

            if (state.error != null) {
              return Scaffold(body: _buildErrorWidget(context, state.error!));
            }

            final restaurant = state.restaurant;
            if (restaurant == null) {
              return Scaffold(body: Center(child: Text('restaurant_not_found'.tr())));
            }

            final showBottomBar = orderState.hasItems;
            final cartLines = _mapCartLines(orderState);

            return Scaffold(
              body: SafeArea(
                bottom: false,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: showBottomBar ? 160.h : 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RestaurantDetailsHeader(
                        restaurant: restaurant,
                        locale: locale,
                        onBack: () => Navigator.of(context).maybePop(),
                        galleryImages: restaurant.getAllImageUrls(),
                        selectedIndex: state.selectedImageIndex,
                        onImageSelected: context.read<RestaurantDetailsCubit>().selectImage,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          restaurant.getDescription(locale),
                          style: TextStyles.font14DarkGray400Weight(context).copyWith(height: 1.6),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildAddressSection(context, restaurant, locale),
                      SizedBox(height: 16.h),
                      _buildInfoRow(context, restaurant),
                      if (restaurant.workingHours.isNotEmpty) ...[
                        SizedBox(height: 16.h),
                        _WorkingHoursSection(workingHours: restaurant.workingHours, locale: locale),
                      ],
                      if (state.menu.isNotEmpty)
                        _buildMenuSection(context, state, orderState, locale),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: showBottomBar
                  ? BottomBookingBar(
                      onPressed: orderState.submitting
                          ? null
                          : () => context.read<OrderCubit>().placeOrder(),
                      buttonTextKey: 'book_your_seat',
                      total: orderState.totalPrice,
                      cartLines: cartLines,
                      onAddItem: (id) {
                        final item = state.menu.where((m) => m.id == id).firstOrNull;
                        if (item != null) {
                          context.read<OrderCubit>().addSimpleItem(
                                menuItemId: item.id,
                                name: item.getTitle(locale),
                                imageUrl: item.imageUrl,
                                price: item.price,
                              );
                        }
                      },
                      onRemoveItem: (id) {
                        context.read<OrderCubit>().removeFromCart(id);
                      },
                    )
                  : _buildBookButton(context),
            );
          },
        );
      },
    );
  }

  void _showOrderSuccessSheet(BuildContext context, String orderId) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _OrderSuccessSheet(
        orderId: orderId,
        onDone: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildMenuSection(
    BuildContext context,
    RestaurantDetailsState state,
    OrderState orderState,
    String locale,
  ) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 12.h),
          child: Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 16)),
              SizedBox(width: 10.w),
              Text('menu'.tr(), style: TextStyles.font16Black500Weight(context)),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<OrderCubit>(),
                        child: RestaurantMenuScreen(restaurantId: restaurantId),
                      ),
                    ),
                  );
                },
                child: Text(
                  'view_all'.tr(),
                  style: TextStyles.font12DarkGray400Weight(context).copyWith(
                    color: ColorsManager.secondary100,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor: ColorsManager.secondary100,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.menu.length >= 4 ? 4 : state.menu.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (_, i) {
              final item = state.menu[i];
              return MenuItemCard(
                item: item,
                locale: locale,
                qty: orderState.getItemQuantity(item.id),
                onAdd: () {
                  context.read<OrderCubit>().addSimpleItem(
                        menuItemId: item.id,
                        name: item.getTitle(locale),
                        imageUrl: item.imageUrl,
                        price: item.price,
                      );
                },
                onRemove: () {
                  context.read<OrderCubit>().removeFromCart(item.id);
                },
                onCustomize: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<OrderCubit>(),
                        child: MealCustomizationScreen(
                          restaurantId: restaurantId,
                          menuItemId: item.id,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddressSection(BuildContext context, RestaurantDetailsModel restaurant, String locale) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(8.w),
        child: Row(
          children: [
            SvgPicture.asset(AppAssets.location, width: 18.r, height: 18.r),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(restaurant.getAddress(locale), style: TextStyles.font12DarkGray400Weight(context)),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RestaurantMapScreen(
                      title: restaurant.getName(locale),
                      lat: 24.7136,
                      lng: 46.6753,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: ColorsManager.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.map_outlined, size: 16.r, color: ColorsManager.primaryColor),
                    SizedBox(width: 6.w),
                    Text(
                      'view_on_map'.tr(),
                      style: TextStyles.font12DarkGray400Weight(context).copyWith(
                        color: ColorsManager.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, RestaurantDetailsModel restaurant) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: _InfoCard(
              icon: AppAssets.chair,
              value: '${restaurant.availableSeats}',
              label: 'seats_available'.tr(),
              color: ColorsManager.primaryColor,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: GestureDetector(
              onTap: () => _callPhone(restaurant.phone),
              child: _InfoCard(
                icon: AppAssets.phone,
                value: restaurant.phone,
                label: '',
                color: const Color(0xFF2E7D32),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookButton(BuildContext context) {
    return BottomBookingBar(
      onPressed: () {},
      buttonTextKey: 'book_your_seat',
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(color: ColorsManager.grey100, shape: BoxShape.circle),
              child: Icon(Icons.error_outline, size: 40.r, color: ColorsManager.darkGray300),
            ),
            SizedBox(height: 20.h),
            Text(error, textAlign: TextAlign.center, style: TextStyles.font14DarkGray400Weight(context)),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => context.read<RestaurantDetailsCubit>().loadRestaurantDetails(restaurantId),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.r)),
              ),
              child: Text('retry'.tr(), style: const TextStyle(color: ColorsManager.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _callPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}

class _OrderSuccessSheet extends StatelessWidget {
  final String orderId;
  final VoidCallback onDone;

  const _OrderSuccessSheet({
    required this.orderId,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: ColorsManager.white,
          borderRadius: BorderRadius.circular(28.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: ColorsManager.grey200,
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
            SizedBox(height: 28.h),
            Container(
              width: 90.r,
              height: 90.r,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F7EB),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF22A83A).withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.checkCircle,
                  width: 44.r,
                  height: 44.r,
                  colorFilter: const ColorFilter.mode(Color(0xFF22A83A), BlendMode.srcIn),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'order_success'.tr(),
              style: TextStyle(
                color: ColorsManager.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'order_success_message'.tr(),
              style: TextStyles.font14DarkGray400Weight(context).copyWith(height: 1.6),
              textAlign: TextAlign.center,
            ),
            if (orderId.isNotEmpty) ...[
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: ColorsManager.grey100.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: context.borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        color: ColorsManager.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.receipt,
                          width: 20.r,
                          height: 20.r,
                          colorFilter: const ColorFilter.mode(ColorsManager.primaryColor, BlendMode.srcIn),
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'order_number'.tr(),
                            style: TextStyles.font12DarkGray400Weight(context),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            orderId,
                            style: TextStyle(
                              color: ColorsManager.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F7EB),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        'confirmed'.tr(),
                        style: TextStyle(
                          color: const Color(0xFF22A83A),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 28.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppAssets.checkCircle,
                      width: 20.r,
                      height: 20.r,
                      colorFilter: const ColorFilter.mode(ColorsManager.white, BlendMode.srcIn),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'done'.tr(),
                      style: TextStyle(
                        color: ColorsManager.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final Color color;

  const _InfoCard({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          SvgPicture.asset(icon),
          SizedBox(width: 8.w),
          Expanded(
            child: Row(
              children: [
                Text(value, style: TextStyles.font12DarkGray400Weight(context), maxLines: 1, overflow: TextOverflow.ellipsis),
                SizedBox(width: 2.w),
                Text(label, style: TextStyles.font10DarkGray400Weight(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkingHoursSection extends StatelessWidget {
  final List<WorkingHourModel> workingHours;
  final String locale;

  const _WorkingHoursSection({required this.workingHours, required this.locale});

  String _todayKey() {
    switch (DateTime.now().weekday) {
      case 1: return 'monday';
      case 2: return 'tuesday';
      case 3: return 'wednesday';
      case 4: return 'thursday';
      case 5: return 'friday';
      case 6: return 'saturday';
      case 7: return 'sunday';
      default: return 'monday';
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = _todayKey();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: context.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: BoxDecoration(
                    color: ColorsManager.secondary100.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.access_time_rounded, size: 16.r, color: ColorsManager.secondary100),
                ),
                SizedBox(width: 10.w),
                Text('working_hours'.tr(), style: TextStyles.font16Black500Weight(context)),
              ],
            ),
            SizedBox(height: 12.h),
            ...workingHours.map((hour) {
              final isToday = hour.day.toLowerCase() == today;
              final isClosed = hour.isClosed;
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 6.r,
                            height: 6.r,
                            decoration: BoxDecoration(
                              color: isToday ? ColorsManager.primaryColor : ColorsManager.grey200,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            hour.getDayName(locale),
                            style: TextStyles.font12DarkGray400Weight(context).copyWith(
                              fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                              color: isToday ? ColorsManager.black : context.textSecondaryColor,
                            ),
                          ),
                          if (isToday) ...[
                            SizedBox(width: 6.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: ColorsManager.primaryColor,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                'today'.tr(),
                                style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w600, color: ColorsManager.white),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: isClosed
                            ? const Color(0xFFC62828).withOpacity(0.08)
                            : ColorsManager.primaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        isClosed ? 'closed'.tr() : '${hour.openTime} - ${hour.closeTime}',
                        style: TextStyles.font10DarkGray400Weight(context).copyWith(
                          fontWeight: FontWeight.w600,
                          color: isClosed ? const Color(0xFFC62828) : ColorsManager.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}