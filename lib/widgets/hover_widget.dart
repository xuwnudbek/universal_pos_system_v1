import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';

class HoverWidget extends StatefulWidget {
  final Widget child;

  const HoverWidget({
    super.key,
    required this.child,
  });

  @override
  State<HoverWidget> createState() => _HoverWidgetState();
}

class _HoverWidgetState extends State<HoverWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: .1),
              blurRadius: _isHovered ? 8.0 : 0.0,
              spreadRadius: _isHovered ? 2.0 : 0.0,
            ),
          ],
          border: Border.all(
            color: colorScheme.primary,
            width: AppBorderWidth.normal,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
