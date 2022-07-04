import 'package:flutter/material.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/tabs/annotation_list/annotation_list_tab.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/tabs/record_list/record_list_tab.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/themed_tab_bar.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/themed_tabbed_section.dart';
import 'package:pandora_mitm_gui_core/src/plugins/record.dart';

class RecordPluginMainPanel extends StatelessWidget {
  final RecordPlugin plugin;

  const RecordPluginMainPanel({
    Key? key,
    required this.plugin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemedTabbedSection(
      tabBar: const ThemedTabBar(
        tabs: [
          ThemedTabEntry('Messages', Icons.cloud_sync),
          ThemedTabEntry('Metadata', Icons.library_music),
        ],
      ),
      children: [
        RecordListTab(plugin: plugin),
        AnnotationListTab(plugin: plugin),
      ],
    );
  }
}
