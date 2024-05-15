import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hopelast_flutter/auth_state.dart';
import 'package:hopelast_flutter/pages/home_page.dart';
import 'package:provider/provider.dart';

import 'pages/registration_page.dart';
import 'pages/login_page.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
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
  redirect: (BuildContext context, GoRouterState state) {
    final authProvider = Provider.of<AuthState>(context, listen: false);
    var currentRoute = state.uri.toString();

    if (authProvider.isLoggedIn && currentRoute != '/') {
      return '/';
    } else if (!authProvider.isLoggedIn &&
        currentRoute != '/register' &&
        currentRoute != '/login') {
      return '/register';
    }

    return null;
  },
);
