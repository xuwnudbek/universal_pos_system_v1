import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:universal_pos_system_v1/models/sidebar_item.dart';
import 'package:universal_pos_system_v1/pages/admin/sidebar/widgets/sidebar_item_widget.dart';
import 'package:universal_pos_system_v1/utils/router/app_router.dart';

import './provider/app_sidebar_provider.dart';

class AppSidebar extends StatefulWidget {
  const AppSidebar({super.key});

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (context) => AppSidebarProvider(),
      builder: (context, asyncSnapshot) {
        return Consumer<AppSidebarProvider>(
          builder: (context, provider, _) {
            return AnimatedContainer(
              width: provider.sidebarWidth,
              duration: const Duration(milliseconds: 100),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                border: Border(
                  right: BorderSide(
                    color: theme.dividerColor,
                    width: 0.1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'POS Tizimi',
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          'Admin',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: Column(
                      children: [
                        ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(
                            horizontal: provider.isExpanded ? 8.0 : 0.0,
                          ),
                          children: provider.sidebarItems
                              .map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: SidebarItemWidget(
                                    item: item,
                                    isExpanded: provider.isExpanded,
                                    isSelected: provider.selectedItem == item,
                                    onTap: (item) {
                                      provider.selectItem(item);
                                    },
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        Spacer(),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                          child: SidebarItemWidget(
                            item: SidebarItem(
                              title: 'Logout',
                              routeName: AppRoute.logout.name,
                              iconData: LucideIcons.logOut,
                            ),
                            isExpanded: provider.isExpanded,
                            isSelected: false,
                            onTap: null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
