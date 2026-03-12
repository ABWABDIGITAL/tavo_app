// lib/core/theme/cubit/theme_state.dart

import 'package:equatable/equatable.dart';

enum ThemeModeType { light, dark }

class ThemeState extends Equatable {
  final ThemeModeType themeMode;
  final bool isDark;

  const ThemeState({
    required this.themeMode,
    required this.isDark,
  });

  factory ThemeState.initial() {
    return const ThemeState(
      themeMode: ThemeModeType.light,
      isDark: false,
    );
  }

  ThemeState copyWith({
    ThemeModeType? themeMode,
    bool? isDark,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  List<Object?> get props => [themeMode, isDark];
}