// lib/feature/profile/ui/logic/cubit/profile_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tavo/feature/profile/ui/logic/cubit/profile_state.dart';
import 'package:tavo/feature/profile/data/repo/profile_repo.dart';

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

  Future<void> updateProfile({String? name, String? phone}) async {
    if (isClosed) return;
    emit(state.copyWith(updating: true, error: null, updateSuccess: null));
    try {
      final updatedUser = await _repo.updateUserProfile(
        name: name,
        phone: phone,
      );
      if (isClosed) return;
      emit(state.copyWith(
        updating: false,
        user: updatedUser,
        updateSuccess: 'تم التحديث بنجاح',
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(updating: false, error: e.toString()));
    }
  }

  void clearMessages() {
    if (isClosed) return;
    emit(state.copyWith(error: null, updateSuccess: null));
  }
}