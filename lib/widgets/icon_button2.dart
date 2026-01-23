import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/utils/theme/app_colors.dart';

enum IconButton2Type {
  success,
  danger,
  warning,
  info,
  primary,
  secondary,
}

class IconButton2 extends StatelessWidget {
  const IconButton2({
    super.key,
    required this.icon,
    this.dimension = 36,
    this.type,
    this.onPressed,
  });

  final IconData icon;
  final double dimension;
  final IconButton2Type? type;
  final VoidCallback? onPressed;

  Color get _color {
    if (onPressed == null) {
      return Colors.grey;
    }

    if (type == null) {
      return Colors.black54;
    }

    switch (type!) {
      case IconButton2Type.success:
        return Colors.green.shade800;
      case IconButton2Type.danger:
        return Colors.red.shade800;
      case IconButton2Type.warning:
        return Colors.orange.shade800;
      case IconButton2Type.info:
        return Colors.blue.shade800;
      case IconButton2Type.primary:
        return AppColors.primary;
      case IconButton2Type.secondary:
        return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double radius = dimension * 0.2;
    final double iconSize = dimension * 0.5;

    return SizedBox.square(
      dimension: dimension,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.antiAlias, // MUHIM
        surfaceTintColor: Colors.transparent,
        child: InkWell(
          hoverColor: _color.withValues(alpha: .02),
          splashColor: _color.withValues(alpha: .1),
          onTap: onPressed,
          borderRadius: BorderRadius.circular(radius),
          child: Center(
            child: Icon(
              icon,
              size: iconSize,
              color: _color,
            ),
          ),
        ),
      ),
    );
  }
}
