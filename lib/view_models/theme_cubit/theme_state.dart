part of 'theme_cubit.dart';

@immutable
sealed class ThemeState {}

final class ThemeInitial extends ThemeState {}

final class ThemeLight extends ThemeState {}

final class ThemeDark extends ThemeState {}
