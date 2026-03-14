// lib/feature/notifications/data/model/app_notification.dart
class AppNotification {
  final String id;
  final String title;
  final String message;
  final String timeAgo;
  final bool isRead;
  final String type;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.isRead,
    this.type = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AppNotification.fromJson(Map<String, dynamic> json, String locale) {
    final titleMap = json['title'] as Map<String, dynamic>? ?? {};
    final messageMap = json['message'] as Map<String, dynamic>? ?? {};
    final createdAt = DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now();

    String rawTitle = titleMap[locale]?.toString() ?? titleMap['ar']?.toString() ?? '';
    String rawMessage = messageMap[locale]?.toString() ?? messageMap['ar']?.toString() ?? '';

    rawTitle = _cleanTemplateString(rawTitle);
    rawMessage = _cleanTemplateString(rawMessage);

    return AppNotification(
      id: json['_id'] ?? '',
      title: rawTitle,
      message: rawMessage,
      timeAgo: _calcTimeAgo(createdAt, locale),
      isRead: json['isRead'] ?? false,
      type: json['type'] ?? '',
      createdAt: createdAt,
    );
  }

  static String _cleanTemplateString(String text) {
    if (text.isEmpty) return text;

    if (text.contains('(data) =>') || text.contains('=>')) {
      final backtickStart = text.indexOf('`');
      final backtickEnd = text.lastIndexOf('`');

      if (backtickStart != -1 && backtickEnd != -1 && backtickEnd > backtickStart) {
        text = text.substring(backtickStart + 1, backtickEnd);
      } else {
        final arrowIndex = text.indexOf('=>');
        if (arrowIndex != -1) {
          text = text.substring(arrowIndex + 2).trim();
          text = text.replaceAll('`', '');
        }
      }
    }

    text = text.replaceAllMapped(
      RegExp(r'\{\{(\w+)\}\}'),
      (match) {
        final key = match.group(1) ?? '';
        switch (key) {
          case 'orderNumber':
            return '#---';
          case 'restaurantName':
            return '';
          default:
            return '';
        }
      },
    );

    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    return text;
  }

  bool get isToday {
    final now = DateTime.now();
    return createdAt.year == now.year && createdAt.month == now.month && createdAt.day == now.day;
  }

  bool get isYesterday {
    final y = DateTime.now().subtract(const Duration(days: 1));
    return createdAt.year == y.year && createdAt.month == y.month && createdAt.day == y.day;
  }

  bool get isOlder => !isToday && !isYesterday;

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      message: message,
      timeAgo: timeAgo,
      isRead: isRead ?? this.isRead,
      type: type,
      createdAt: createdAt,
    );
  }

  static String _calcTimeAgo(DateTime date, String locale) {
    final diff = DateTime.now().difference(date);
    if (locale == 'ar') {
      if (diff.inMinutes < 1) return 'الآن';
      if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
      if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
      if (diff.inDays < 7) return 'منذ ${diff.inDays} يوم';
      return '${date.day}/${date.month}/${date.year}';
    } else {
      if (diff.inMinutes < 1) return 'Now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}