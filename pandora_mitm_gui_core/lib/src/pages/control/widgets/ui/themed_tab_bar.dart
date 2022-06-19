import 'package:flutter/material.dart';

class ThemedTabBar extends StatelessWidget {
  final List<ThemedTabEntry> tabs;

  const ThemedTabBar({
    Key? key,
    required this.tabs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppBarTheme.of(context).toolbarHeight ?? kToolbarHeight,
      child: Card(
        color: Theme.of(context).primaryColor,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        shape: const Border(),
        elevation: AppBarTheme.of(context).elevation ?? 4,
        child: TabBar(
          isScrollable: true,
          tabs: tabs
              .map(
                (tabEntry) => Tab(
                  child: Row(
                    children: [
                      if (tabEntry.iconData != null)
                        Icon(tabEntry.iconData, size: 20),
                      const SizedBox(width: 8),
                      Text(tabEntry.name),
                    ],
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
  }
}

class ThemedTabEntry {
  final String name;
  final IconData? iconData;

  const ThemedTabEntry(this.name, this.iconData);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemedTabEntry &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          iconData == other.iconData;

  @override
  int get hashCode => Object.hash(name, iconData);
}
