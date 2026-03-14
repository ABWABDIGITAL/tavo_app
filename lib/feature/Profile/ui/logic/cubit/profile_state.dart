// lib/feature/profile/ui/logic/cubit/profile_state.dart
import 'package:tavo/feature/profile/data/model/user_model.dart';

class ProfileState {
  final bool loading;
  final bool updating;
  final UserModel? user;
  final String? error;
  final String? updateSuccess;

  const ProfileState({
    this.loading = false,
    this.updating = false,
    this.user,
    this.error,
    this.updateSuccess,
  });

  ProfileState copyWith({
    bool? loading,
    bool? updating,
    UserModel? user,
    String? error,
    String? updateSuccess,
  }) {
    return ProfileState(
      loading: loading ?? this.loading,
      updating: updating ?? this.updating,
      user: user ?? this.user,
      error: error,
      updateSuccess: updateSuccess,
    );
  }
}