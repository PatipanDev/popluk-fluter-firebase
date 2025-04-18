import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// pages
import 'package:popluk/screens/login_page.dart';
import 'package:popluk/screens/signup_questions_page.dart';
import 'package:popluk/screens/login_or_signup_page.dart';
import 'package:popluk/screens/index_page.dart';
import 'package:popluk/screens/profile/edit_profile_page.dart';

class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((_) => notifyListeners());
  }
}

class AppRouter {
  static final AuthNotifier _authNotifier = AuthNotifier();

  static final GoRouter router = GoRouter(
    initialLocation: '/loginorsignup_page',
    refreshListenable: _authNotifier,
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final location = state.uri.toString();

      final unauthenticatedRoutes = [
        '/loginorsignup_page',
        '/login_page',
        '/signup_page',
      ];

      if (user == null && !unauthenticatedRoutes.contains(location)) {
        return '/loginorsignup_page';
      }

      if (user != null && unauthenticatedRoutes.contains(location)) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => IndexPage()),
      GoRoute(
        path: '/loginorsignup_page',
        builder: (context, state) => LogInOrSignUpPage(),
      ),
      GoRoute(path: '/login_page', builder: (context, state) => LoginPage()),
      GoRoute(
        path: '/signup_page',
        builder: (context, state) => SignupQuestionsPage(),
      ),
      GoRoute(
        path: '/edit_profile',
        builder: (context, state) => const EditProfilePage(),
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 300),
            child: const EditProfilePage(),
            transitionsBuilder: _slideTransition, // ใช้ transitionsBuilder
          );
        },
      ),
    ],
  );
}



// ฟังก์ชันแอนิเมชั่นสำหรับการสไลด์
Widget _slideTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  const begin = Offset(1.0, 0.0); // สไลด์จากขวา
  const end = Offset.zero;
  const curve = Curves.easeInOut; // ทำให้แอนิเมชันช้าลง

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  var offsetAnimation = animation.drive(tween);

  return SlideTransition(position: offsetAnimation, child: child);
}
