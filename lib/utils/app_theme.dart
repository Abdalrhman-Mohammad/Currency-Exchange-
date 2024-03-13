import 'package:currency_exchange/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.silver),
    scaffoldBackgroundColor: AppColors.silver,
    inputDecorationTheme: const InputDecorationTheme(
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24))),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24))),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24))),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24))),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24))),
    ),
  );
  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.black),
    scaffoldBackgroundColor: AppColors.black,
    inputDecorationTheme: const InputDecorationTheme(
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24))),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24))),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24))),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24))),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24))),
    ),
  );
}
