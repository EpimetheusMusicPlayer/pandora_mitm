import 'package:flutter/material.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/tabs/record_list/record_list_tab.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/themed_tab_bar.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/themed_tabbed_section.dart';
import 'package:pandora_mitm_gui_core/src/plugins/record.dart';

class RecordPluginMainPanel extends StatelessWidget {
  final RecordPlugin plugin;

  const RecordPluginMainPanel({
    super.key,
    required this.plugin,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedTabbedSection(
      tabBar: const ThemedTabBar(
        tabs: [
          ThemedTabEntry(
            title: Text('Messages'),
            icon: Icon(Icons.cloud_sync),
          ),
        ],
      ),
      children: [
        RecordListTab(plugin: plugin),
      ],
    );
  }
}
