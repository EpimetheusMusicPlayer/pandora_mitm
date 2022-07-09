import 'package:flutter/material.dart';

class ThemedTabbedSection extends StatelessWidget {
  final Widget tabBar;
  final List<Widget> children;

  const ThemedTabbedSection({
    super.key,
    required this.tabBar,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    // https://github.com/flutter/flutter/issues/86584
    // A Material is needed to prevent ripples from tab children extending
    // beyond their appropriate area.
    return Material(
      child: DefaultTabController(
        length: children.length,
        child: Column(
          children: [
            tabBar,
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
