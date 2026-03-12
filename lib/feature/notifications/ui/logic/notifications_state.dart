// lib/ui/cubit/notifications_state.dart


import '../../data/model/app_notification.dart';

class NotificationsState {
  final bool isLoading;
  final List<AppNotification> items;

  const NotificationsState({
    required this.isLoading,
    required this.items,
  });

  factory NotificationsState.initial() {
    return const NotificationsState(isLoading: false, items: []);
  }

  NotificationsState copyWith({
    bool? isLoading,
    List<AppNotification>? items,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
    );
  }

  List<AppNotification> get today =>
      items.where((e) => e.section == NotificationSection.today).toList();

  List<AppNotification> get yesterday =>
      items.where((e) => e.section == NotificationSection.yesterday).toList();

  bool get hasUnread => items.any((e) => !e.isRead);
}