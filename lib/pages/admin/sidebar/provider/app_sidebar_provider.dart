import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:universal_pos_system_v1/models/sidebar_item.dart';
import 'package:universal_pos_system_v1/utils/router/app_router.dart';

class AppSidebarProvider extends ChangeNotifier {
  bool isExpanded = true;
  double get sidebarWidth => isExpanded ? 250 : 70;

  final List<SidebarItem> sidebarItems = [
    SidebarItem(
      title: 'Sotuv',
      routeName: AppRoute.sales.name,
      iconData: LucideIcons.shoppingCart,
    ),
    SidebarItem(
      title: 'Maxsulotlar',
      routeName: AppRoute.items.name,
      iconData: LucideIcons.box,
    ),
    SidebarItem(
      title: 'Categories',
      routeName: AppRoute.categories.name,
      iconData: LucideIcons.tags,
    ),
    SidebarItem(
      title: 'Ombor',
      routeName: AppRoute.warehouse.name,
      iconData: LucideIcons.archive,
    ),
    SidebarItem(
      title: 'Olib kelish',
      routeName: AppRoute.procurement.name,
      iconData: LucideIcons.shoppingBag,
    ),
    SidebarItem(
      title: 'Xarajatlar',
      routeName: AppRoute.expenses.name,
      iconData: LucideIcons.dollarSign,
    ),
    SidebarItem(
      title: 'Hisobotlar',
      routeName: AppRoute.reports.name,
      iconData: LucideIcons.fileText,
    ),
    SidebarItem(
      title: 'Foydalanuvchilar',
      routeName: AppRoute.users.name,
      iconData: LucideIcons.users,
    ),
    SidebarItem(
      title: 'Sozlamalar',
      routeName: AppRoute.settings.name,
      iconData: LucideIcons.settings,
    ),
    SidebarItem(
      title: 'Backup',
      routeName: AppRoute.backup.name,
      iconData: LucideIcons.cloud,
    ),
  ];

  late SidebarItem _selectedItem;
  SidebarItem get selectedItem => _selectedItem;
  void selectItem(SidebarItem item) {
    _selectedItem = item;
    appRouter.goNamed(item.routeName);
    notifyListeners();
  }

  AppSidebarProvider() {
    _selectedItem = sidebarItems.first;
  }

  void toggleSidebar() {
    isExpanded = !isExpanded;
    notifyListeners();
  }
}
