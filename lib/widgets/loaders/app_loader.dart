import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/utils/theme/app_colors.dart';

class AppLoader extends StatefulWidget {
  const AppLoader({super.key});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: CircularProgressIndicator.adaptive(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          backgroundColor: Colors.grey[300],
          strokeCap: StrokeCap.round,
          constraints: const BoxConstraints.tightFor(width: 40, height: 40),
        ),
      ),
    );
  }
}
