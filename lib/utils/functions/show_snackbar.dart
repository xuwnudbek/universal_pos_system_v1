import 'package:flutter/material.dart';

enum SnackBarType {
  success,
  error,
  info,
  warning,
}

void showAppSnackBar(
  BuildContext context,
  String message, {
  SnackBarType type = SnackBarType.info,
  Duration duration = const Duration(seconds: 3),
}) {
  final theme = Theme.of(context);

  Color backgroundColor;
  IconData icon;

  switch (type) {
    case SnackBarType.success:
      backgroundColor = Colors.green;
      icon = Icons.check_circle_outline;
      break;
    case SnackBarType.error:
      backgroundColor = Colors.red;
      icon = Icons.error_outline;
      break;
    case SnackBarType.warning:
      backgroundColor = Colors.orange;
      icon = Icons.warning_amber_outlined;
      break;
    case SnackBarType.info:
      backgroundColor = theme.colorScheme.primary;
      icon = Icons.info_outline;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: 20,
        right: 20,
        left: MediaQuery.of(context).size.width - 420, // 400px width + 20px margin
      ),
      duration: duration,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 6,
    ),
  );
}
