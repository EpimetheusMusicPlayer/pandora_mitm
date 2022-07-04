import 'package:flutter/material.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/json_copy_button.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/themed_tab_bar.dart';

class MessageTabBar extends StatelessWidget {
  static const defaultTabEntries = [
    ThemedTabEntry(title: Text('JSON'), icon: Icon(Icons.data_object)),
    ThemedTabEntry(title: Text('Raw'), icon: Icon(Icons.raw_on)),
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
    return ThemedTabBar(
      tabs: tabEntries,
      actions: [JsonCopyButton(jsonEncodable: jsonEncodable)],
    );
  }
}
