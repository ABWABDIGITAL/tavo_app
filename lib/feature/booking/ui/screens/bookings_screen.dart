// lib/feature/booking/ui/screens/bookings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/feature/booking/data/model/booking_model.dart';
import 'package:tavo/feature/booking/data/model/booking_status.dart';
import 'package:tavo/feature/booking/ui/widgets/booking_card.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<BookingModel> _bookings = const [
    BookingModel(
      id: '#128350',
      restaurantName: 'مطعم البيك',
      restaurantLogoUrl: 'https://picsum.photos/200/200?random=1',
      total: 360,
      address: 'طريق عرفات، بدر، الرياض',
      dateTimeText: '1 مارس 2026 - 3:00 م',
      seatsText: '3 كراسي محجوزة',
      status: BookingStatus.cancelled,
    ),
    BookingModel(
      id: '#128351',
      restaurantName: 'مطعم البيك',
      restaurantLogoUrl: 'https://picsum.photos/200/200?random=2',
      total: 360,
      address: 'طريق عرفات، بدر، الرياض',
      dateTimeText: '1 مارس 2026 - 3:00 م',
      seatsText: '3 كراسي محجوزة',
      status: BookingStatus.completed,
    ),
    BookingModel(
      id: '#128352',
      restaurantName: 'مطعم البيك',
      restaurantLogoUrl: 'https://picsum.photos/200/200?random=3',
      total: 360,
      address: 'طريق عرفات، بدر، الرياض',
      dateTimeText: '1 مارس 2026 - 3:00 م',
      seatsText: '3 كراسي محجوزة',
      status: BookingStatus.inProgress,
    ),
    BookingModel(
      id: '#128353',
      restaurantName: 'مطعم البيك',
      restaurantLogoUrl: 'https://picsum.photos/200/200?random=4',
      total: 360,
      address: 'طريق عرفات، بدر، الرياض',
      dateTimeText: '1 مارس 2026 - 3:00 م',
      seatsText: '3 كراسي محجوزة',
      status: BookingStatus.inProgress,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<BookingModel> _filter(BookingStatus status) =>
      _bookings.where((e) => e.status == status).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeaderWithTabs(context),
            SizedBox(height: 14.h),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _BookingsList(items: _filter(BookingStatus.inProgress)),
                  _BookingsList(items: _filter(BookingStatus.completed)),
                  _BookingsList(items: _filter(BookingStatus.cancelled)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderWithTabs(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      child: Row(
        children: [
          Text(
            'الحجوزات',
            style: TextStyles.font18Black400Weight(context).copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Container(
              height: 40.h,
              padding: EdgeInsets.all(3.r),
              decoration: BoxDecoration(
                color: ColorsManager.grey100,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: ColorsManager.black,
                unselectedLabelColor: ColorsManager.darkGray300,
                labelStyle: TextStyles.font12DarkGray400Weight(context).copyWith(
                 
                ),
                unselectedLabelStyle: TextStyles.font12DarkGray400Weight(context).copyWith(
                  fontWeight: FontWeight.w500,
                ),
                labelPadding: EdgeInsets.zero,
                indicator: BoxDecoration(
                  color: ColorsManager.white,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: ColorsManager.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                tabs: const [
                  Tab(text: 'قيد التنفيذ'),
                  Tab(text: 'مكتملة'),
                  Tab(text: 'ملغية'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingsList extends StatelessWidget {
  final List<BookingModel> items;

  const _BookingsList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 48.r,
              color: ColorsManager.darkGray300,
            ),
            SizedBox(height: 12.h),
            Text(
              'لا توجد حجوزات',
              style: TextStyles.font14DarkGray400Weight(context).copyWith(
                fontWeight: FontWeight.w600,
                color: ColorsManager.darkGray300,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (_, i) {
        final b = items[i];
        return BookingCard(
          bookingId: b.id,
          restaurantName: b.restaurantName,
          logoUrl: b.restaurantLogoUrl,
          total: b.total,
          address: b.address,
          dateTimeText: b.dateTimeText,
          seatsText: b.seatsText,
          status: b.status,
          onDetails: () {},
          onDelete: () {},
          onRate: () {},
          onCancel: () {},
        );
      },
    );
  }
}