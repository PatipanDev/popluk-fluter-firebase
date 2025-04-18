import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:popluk/firebase_options.dart';
import 'package:popluk/theme/app_theme.dart';
import 'package:popluk/router.dart';
import 'package:provider/provider.dart';
import 'package:popluk/providers/user_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()..loadUser()),
      // เพิ่ม Provider อื่น ๆ ได้ตรงนี้
    ],
    child: const MyApp(),
  ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
