import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// pages
import 'package:popluk/pages/login_page.dart';
import 'package:popluk/pages/signup_questions_page.dart';
import 'package:popluk/pages/login_or_signup_page.dart';
import 'package:popluk/pages/index_page.dart';
import 'package:popluk/pages/profile/edit_profile_page.dart';

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
      GoRoute(
        path: '/',
        builder: (context, state) => IndexPage(),
      ),
      GoRoute(
        path: '/loginorsignup_page',
        builder: (context, state) => LogInOrSignUpPage(),
      ),
      GoRoute(
        path: '/login_page',
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: '/signup_page',
        builder: (context, state) => SignupQuestionsPage(),
      ),
       GoRoute(
        path: '/edit_profile',
        builder: (context, state) => EditProfilePage(),
      ),
    ],
  );
}
