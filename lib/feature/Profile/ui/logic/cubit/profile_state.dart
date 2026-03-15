// lib/feature/Profile/ui/logic/cubit/profile_state.dart
import 'package:tavo/feature/Profile/data/model/user_model.dart';
import 'package:tavo/feature/Profile/data/model/user_stats.dart';

class ProfileState {
  final bool loading;
  final bool updating;
  final bool uploadingAvatar;
  final UserModel? user;
  final UserStats? stats;
  final String? error;
  final String? updateSuccess;

  const ProfileState({
    this.loading = false,
    this.updating = false,
    this.uploadingAvatar = false,
    this.user,
    this.stats,
    this.error,
    this.updateSuccess,
  });

  ProfileState copyWith({
    bool? loading,
    bool? updating,
    bool? uploadingAvatar,
    UserModel? user,
    UserStats? stats,
    String? error,
    String? updateSuccess,
    bool clearUser = false,
    bool clearStats = false,
  }) {
    return ProfileState(
      loading: loading ?? this.loading,
      updating: updating ?? this.updating,
      uploadingAvatar: uploadingAvatar ?? this.uploadingAvatar,
      user: clearUser ? null : (user ?? this.user),
      stats: clearStats ? null : (stats ?? this.stats),
      error: error,
      updateSuccess: updateSuccess,
    );
  }
}
