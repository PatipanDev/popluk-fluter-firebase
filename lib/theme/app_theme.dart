import 'package:flutter/material.dart';
import 'colors.dart'; // อิมพอร์ตสีที่คุณกำหนดไว้

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.background,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black87,
    ),
    scaffoldBackgroundColor: AppColors.background, // กำหนดพื้นหลัง
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary, // สีของ AppBar
      foregroundColor: AppColors.background, // สีข้อความใน AppBar
      elevation: 2,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        color: AppColors.primary,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.fontcolor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.secondary,
      unselectedItemColor: AppColors.primary,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    useMaterial3: true,
  );
}
