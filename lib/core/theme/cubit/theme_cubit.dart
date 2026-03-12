import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.initial());

  void toggleTheme() {
    final newIsDark = !state.isDark;
    emit(ThemeState(
      themeMode: newIsDark ? ThemeModeType.dark : ThemeModeType.light,
      isDark: newIsDark,
    ));
  }

  void setTheme(ThemeModeType mode) {
    final isDark = mode == ThemeModeType.dark;
    emit(ThemeState(themeMode: mode, isDark: isDark));
  }
}
