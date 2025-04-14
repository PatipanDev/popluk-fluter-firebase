import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:popluk/firebase_options.dart';
import 'package:popluk/widget_tree.dart';
import 'package:popluk/theme/colors.dart'; // นำเข้า AppColors ที่คุณสร้างไว้

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.background, // ใช้ surface แทน background
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.black87, // เปลี่ยนจาก onBackground เป็น onSurface
        ),
        scaffoldBackgroundColor:
            AppColors.background, // ใช้ background สำหรับ Scaffold
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
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
            // color: const Color.fromARGB(255, 125, 122, 122)
          ),
          labelLarge: TextStyle(fontSize: 14, color: AppColors.primary),
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
      ),
      home: const WidgetTree(),
    );
  }
}
