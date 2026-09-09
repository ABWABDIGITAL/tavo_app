// lib/feature/Profile/ui/logic/cubit/profile_cubit.dart
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tavo/feature/Profile/ui/logic/cubit/profile_state.dart';
import 'package:tavo/feature/Profile/data/repo/profile_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _repo;

  ProfileCubit(this._repo) : super(const ProfileState());

  Future<void> loadProfile() async {
    if (isClosed) return;
    emit(state.copyWith(loading: true, error: null));
    try {
      final user = await _repo.getUserProfile();
      if (isClosed) return;
      emit(state.copyWith(loading: false, user: user));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> loadStats() async {
    if (isClosed) return;
    emit(state.copyWith(loading: true, error: null));
    try {
      final stats = await _repo.getUserStats();
      if (isClosed) return;
      emit(state.copyWith(loading: false, stats: stats));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> updateProfile({String? name, String? phone}) async {
    if (isClosed) return;
    emit(state.copyWith(updating: true, error: null, updateSuccess: null));
    try {
      final updatedUser = await _repo.updateUserProfile(
        name: name,
        phone: phone,
      );
      if (isClosed) return;
      emit(
        state.copyWith(
          updating: false,
          user: updatedUser,
          updateSuccess: 'تم التحديث بنجاح',
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(updating: false, error: e.toString()));
    }
  }

  Future<void> uploadAvatar(File imageFile) async {
    if (isClosed) return;
    emit(state.copyWith(uploadingAvatar: true, error: null));
    try {
      final updatedUser = await _repo.uploadAvatar(imageFile);
      if (isClosed) return;
      emit(
        state.copyWith(
          uploadingAvatar: false,
          user: updatedUser,
          updateSuccess: 'تم تحديث الصورة بنجاح',
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(uploadingAvatar: false, error: e.toString()));
    }
  }

  void clearMessages() {
    if (isClosed) return;
    emit(state.copyWith(error: null, updateSuccess: null));
  }
}
