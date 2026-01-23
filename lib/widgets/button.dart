import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';

class Button extends StatefulWidget {
  const Button({
    super.key,
    required this.onPressed,
    required this.child,
    this.primaryColor,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Color? primaryColor;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButtonTheme(
      data: ElevatedButtonThemeData(),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size.fromHeight(AppButtonHeight.md),
          elevation: AppElevation.none,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          backgroundColor: widget.primaryColor ?? theme.primaryColor,
          foregroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        ),
        onPressed: widget.onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: widget.child,
        ),
      ),
    );
  }
}
