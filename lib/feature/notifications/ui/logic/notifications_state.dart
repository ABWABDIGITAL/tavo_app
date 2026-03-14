// lib/feature/notifications/ui/logic/notifications_state.dart
import 'package:tavo/feature/notifications/data/model/app_notification.dart';

class NotificationsState {
  final bool isLoading;
  final List<AppNotification> notifications;
  final String? error;
  final int unreadCount;

  const NotificationsState({
    this.isLoading = false,
    this.notifications = const [],
    this.error,
    this.unreadCount = 0,
  });

  List<AppNotification> get today => notifications.where((n) => n.isToday).toList();
  List<AppNotification> get yesterday => notifications.where((n) => n.isYesterday).toList();
  List<AppNotification> get older => notifications.where((n) => n.isOlder).toList();
  bool get hasUnread => unreadCount > 0 || notifications.any((n) => !n.isRead);

  NotificationsState copyWith({
    bool? isLoading,
    List<AppNotification>? notifications,
    String? error,
    int? unreadCount,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
      error: error,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}