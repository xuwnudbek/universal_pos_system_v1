import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/pages/user/sales/sales_page.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SalesPage(),
    );
  }
}
