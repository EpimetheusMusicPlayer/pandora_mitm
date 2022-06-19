import 'package:flutter/material.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/annotation_tab.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/message_tab.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/themed_tab_bar.dart';
import 'package:pandora_mitm_gui_core/src/plugins/record.dart';

class RecordPluginUi extends PluginUi<RecordPlugin> {
  const RecordPluginUi();

  @override
  String get displayName => 'Record';

  @override
  String get description => 'Records API requests and responses.';

  @override
  IconData get iconData => Icons.videocam;

  @override
  bool get hasMainPanel => true;

  @override
  Widget buildMainPanel(BuildContext context, RecordPlugin plugin) =>
      _RecordPluginUi(plugin: plugin);

  @override
  RecordPlugin buildPlugin() => RecordPlugin();
}

class _RecordPluginUi extends StatelessWidget {
  final RecordPlugin plugin;

  const _RecordPluginUi({
    Key? key,
    required this.plugin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const ThemedTabBar(
            tabs: [
              ThemedTabEntry('Messages', Icons.cloud_sync),
              ThemedTabEntry('Metadata', Icons.library_music),
            ],
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                MessageTab(plugin: plugin),
                AnnotationTab(plugin: plugin),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
