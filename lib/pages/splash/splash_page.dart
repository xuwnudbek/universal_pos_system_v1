import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/utils/functions/local_storage.dart';
import 'package:universal_pos_system_v1/utils/router/app_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    // If production, set duration to 3 seconds or more
    int durationInSeconds = kDebugMode ? 0 : 3;
    await Future.delayed(Duration(seconds: durationInSeconds));

    if (mounted) {
      final route = _checkAuthentication();
      log("Navigating to ${route.name} page");
      appRouter.goNamed(route.name);
    }
  }

  AppRoute _checkAuthentication() {
    String? role = LocalStorage.getUserRole();

    switch (role) {
      case "admin":
        return AppRoute.admin;
      case "cashier":
        return AppRoute.user;
      default:
        return AppRoute.auth;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Splash Screen',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 48),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
