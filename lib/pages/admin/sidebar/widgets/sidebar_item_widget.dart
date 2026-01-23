import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/models/sidebar_item.dart';

class SidebarItemWidget extends StatelessWidget {
  const SidebarItemWidget({
    super.key,
    required this.item,
    required this.isExpanded,
    required this.isSelected,
    this.onTap,
  });

  final SidebarItem item;
  final bool isExpanded;
  final bool isSelected;
  final Function(SidebarItem item)? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: isExpanded
          ? ListTile(
              leading: Icon(item.iconData, size: 18),
              title: Text(item.title),
              selected: isSelected,
              onTap: () {
                onTap?.call(item);
              },
            )
          : InkWell(
              onTap: () {
                onTap?.call(item);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Icon(item.iconData),
              ),
            ),
    );
  }
}
