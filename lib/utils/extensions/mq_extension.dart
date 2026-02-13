import 'package:flutter/widgets.dart';

enum WindowSize { lg, md, sm }

extension MqExtension on MediaQueryData {
  WindowSize get windowSize {
    final width = size.width;

    if (width >= 1200) {
      return WindowSize.lg;
    } else if (width >= 800) {
      return WindowSize.md;
    } else {
      return WindowSize.sm;
    }
  }
}
