import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/pages/auth/provider/auth_provider.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({
    super.key,
    required this.sidebar,
    required this.content,
  });

  final Widget sidebar;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          sidebar,
          Expanded(child: content),
        ],
      ),
    );
  }
}
