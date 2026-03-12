// lib/ui/cubit/notifications_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/app_notification.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsState.initial());

  Future<void> loadMock() async {
    emit(state.copyWith(isLoading: true));

    // UI Mock (بدّلها لاحقًا بـ API)
    final data = <AppNotification>[
      // اليوم
      const AppNotification(
        id: '1',
        section: NotificationSection.today,
        title: 'إلغاء حجز',
        message: 'تم إلغاء حجزك رقم #250041 من طرف المطعم',
        timeAgo: '3د',
        isRead: false,
      ),
      const AppNotification(
        id: '2',
        section: NotificationSection.today,
        title: 'إلغاء حجز',
        message: 'تم إلغاء حجزك رقم #250041 من طرف المطعم',
        timeAgo: '3د',
        isRead: false,
      ),
      const AppNotification(
        id: '3',
        section: NotificationSection.today,
        title: 'إلغاء حجز',
        message: 'تم إلغاء حجزك رقم #250041 من طرف المطعم',
        timeAgo: '3د',
        isRead: true,
      ),

      // أمس
      const AppNotification(
        id: '4',
        section: NotificationSection.yesterday,
        title: 'إلغاء حجز',
        message: 'تم إلغاء حجزك رقم #250041 من طرف المطعم',
        timeAgo: '3د',
        isRead: true,
      ),
      const AppNotification(
        id: '5',
        section: NotificationSection.yesterday,
        title: 'إلغاء حجز',
        message: 'تم إلغاء حجزك رقم #250041 من طرف المطعم',
        timeAgo: '3د',
        isRead: true,
      ),
    ];

    emit(state.copyWith(isLoading: false, items: data));
  }

  void markAllAsRead() {
    final updated = state.items.map((e) => e.copyWith(isRead: true)).toList();
    emit(state.copyWith(items: updated));
  }

  void markAsRead(String id) {
    final updated = state.items
        .map((e) => e.id == id ? e.copyWith(isRead: true) : e)
        .toList();
    emit(state.copyWith(items: updated));
  }
}