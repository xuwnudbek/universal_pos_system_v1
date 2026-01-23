import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:universal_pos_system_v1/utils/theme/app_colors.dart';

class AppShimmerLoader extends StatelessWidget {
  const AppShimmerLoader({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.0,
      height: 100.0,
      child: Shimmer.fromColors(
        baseColor: AppColors.border,
        highlightColor: AppColors.surface,
        child: child ?? Container(),
      ),
    );
  }
}
