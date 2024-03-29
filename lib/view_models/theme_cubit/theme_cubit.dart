import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial());
  ThemeMode themeMode = ThemeMode.light;
  void changeTheme() {
    if (themeMode == ThemeMode.light) {
      themeMode = ThemeMode.dark;
      emit(ThemeLight());
    } else {
      themeMode = ThemeMode.light;
      emit(ThemeDark());
    }
  }
}
