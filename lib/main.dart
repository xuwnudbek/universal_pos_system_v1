import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/utils/theme/app_theme.dart';

import 'utils/router/app_router.dart';

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(const MyApp());
    },
    (error, stackTrace) {
      log("Error caught: $error");
      log("Stack trace: $stackTrace");
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Universal POS System',
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
