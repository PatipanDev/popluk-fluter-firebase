// lib/router.dart
import 'package:go_router/go_router.dart';

// page
import 'package:popluk/pages/signup_questions_page.dart';
import 'package:popluk/pages/login_or_signup_page.dart';
import 'package:popluk/pages/index_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => SignInOrSignUpPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => IndexPage(),
      ),
      GoRoute(
        path: '/signup_page',
        builder: (context, state) => SignupQuestionsPage(),
      ),
    ],
  );
}
