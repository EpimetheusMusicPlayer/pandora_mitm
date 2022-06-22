import 'package:flutter/material.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/json_copy_button.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/themed_tab_bar.dart';

class MessageTabBar extends StatelessWidget {
  static const defaultTabEntries = [
    ThemedTabEntry('JSON', Icons.data_object),
    ThemedTabEntry('Raw', Icons.raw_on),
  ];

  final Object? jsonEncodable;
  final List<ThemedTabEntry> tabEntries;

  const MessageTabBar({
    Key? key,
    required this.jsonEncodable,
    this.tabEntries = defaultTabEntries,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        ThemedTabBar(tabs: tabEntries),
        Positioned(
          right: 8,
          bottom: 8,
          child: IconTheme(
            data: IconThemeData(
              color: Theme.of(context).typography.white.headline6!.color,
            ),
            child: JsonCopyButton(jsonEncodable: jsonEncodable),
          ),
        )
      ],
    );
  }
}
