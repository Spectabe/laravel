import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hopelast_flutter/auth_state.dart';
import 'package:hopelast_flutter/pages/home_page.dart';
import 'package:provider/provider.dart';

import 'pages/registration_page.dart';
import 'pages/login_page.dart';
import 'pages/welcome_page.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegistrationPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) async {
    final authProvider = Provider.of<AuthState>(context, listen: false);
    var currentRoute = state.uri.toString();

    if (!authProvider.isLoggedIn) {
      await authProvider.checkToken(context);
    }

    if (authProvider.isLoggedIn && currentRoute != '/') {
      return '/';
    } else if (!authProvider.isLoggedIn &&
        currentRoute != '/register' &&
        currentRoute != '/login') {
      return '/welcome';
    }

    return null;
  },
);
