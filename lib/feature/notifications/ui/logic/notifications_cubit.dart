// lib/feature/notifications/ui/logic/notifications_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tavo/core/network/api_exception.dart';
import 'package:tavo/feature/notifications/data/repo/notifications_repo.dart';
import 'package:tavo/feature/notifications/ui/logic/notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo _repo;

  NotificationsCubit(this._repo) : super(const NotificationsState());

  Future<void> loadNotifications(String locale) async {
    if (isClosed) return;
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final results = await Future.wait([
        _repo.getNotifications(locale),
        _repo.getUnreadCount(),
      ]);

      if (isClosed) return;

      emit(state.copyWith(
        isLoading: false,
        notifications: (results[0] as List).cast(),
        unreadCount: results[1] as int,
      ));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, error: e.message));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> markAsRead(String id) async {
    final updated = state.notifications.map((n) {
      if (n.id == id) return n.copyWith(isRead: true);
      return n;
    }).toList();
    final newUnread = updated.where((n) => !n.isRead).length;
    emit(state.copyWith(notifications: updated, unreadCount: newUnread));

    try {
      await _repo.markAsRead(id);
    } catch (_) {}
  }

  Future<void> markAllAsRead() async {
    final updated = state.notifications.map((n) => n.copyWith(isRead: true)).toList();
    emit(state.copyWith(notifications: updated, unreadCount: 0));

    try {
      await _repo.markAllAsRead();
    } catch (_) {}
  }

  Future<void> refresh(String locale) async {
    await loadNotifications(locale);
  }
}