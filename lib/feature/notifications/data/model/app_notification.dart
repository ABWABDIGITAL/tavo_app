// lib/data/model/app_notification.dart
enum NotificationSection { today, yesterday }

class AppNotification {
  final String id;
  final NotificationSection section;
  final String title;
  final String message;
  final String timeAgo;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.section,
    required this.title,
    required this.message,
    required this.timeAgo,
    this.isRead = false,
  });

  AppNotification copyWith({
    bool? isRead,
  }) {
    return AppNotification(
      id: id,
      section: section,
      title: title,
      message: message,
      timeAgo: timeAgo,
      isRead: isRead ?? this.isRead,
    );
  }
}