import 'package:flutter/material.dart';

class ThemedTabBar extends StatelessWidget {
  final List<ThemedTabEntry> tabs;
  final List<Widget> actions;

  const ThemedTabBar({
    Key? key,
    required this.tabs,
    this.actions = const [],
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
        child: IconTheme(
          data: IconThemeData(
            color: Theme.of(context).typography.white.headline6!.color,
          ),
          child: Row(
            children: [
              Expanded(
                child: TabBar(
                  isScrollable: true,
                  tabs: tabs
                      .map(
                        (tabEntry) => Tab(
                          child: Row(
                            children: [
                              if (tabEntry.icon != null)
                                IconTheme.merge(
                                  data: const IconThemeData(size: 20),
                                  child: tabEntry.icon!,
                                ),
                              const SizedBox(width: 8),
                              tabEntry.title,
                            ],
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
              ...actions,
            ],
          ),
        ),
      ),
    );
  }
}

class ThemedTabEntry {
  final Widget title;
  final Widget? icon;

  const ThemedTabEntry({
    required this.title,
    this.icon,
  });
}
