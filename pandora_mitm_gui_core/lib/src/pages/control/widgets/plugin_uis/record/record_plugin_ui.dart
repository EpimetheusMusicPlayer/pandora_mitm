import 'package:flutter/material.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/mixins/boilerplate_stripper_plugin_ui_mixin.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/record_plugin_main_panel.dart';
import 'package:pandora_mitm_gui_core/src/plugins/record.dart';
import 'package:pandora_mitm_gui_core/src/state/pandora_mitm_bloc.dart';

class RecordPluginUi extends PluginUi<RecordPlugin>
    with BoilerplateStripperPluginUiMixin {
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
      RecordPluginMainPanel(plugin: plugin);

  @override
  List<PopupMenuItem<Object?>> buildContextMenuItems(
    BuildContext context,
    RecordPlugin plugin,
  ) =>
      [
        // ignore: prefer_void_to_null
        PopupMenuItem<Null>(
          onTap: () => plugin
            ..messageRecorder.clear()
            ..objectRecorder.clear(),
          child: const Text('Clear messages'),
        ),
        // ignore: prefer_void_to_null
        PopupMenuItem<Null>(
          onTap: plugin.annotationRecorder.clear,
          child: const Text('Clear annotations'),
        ),
        ...super.buildContextMenuItems(context, plugin),
      ];

  @override
  bool isPluginEnabled(PandoraMitmBloc pandoraMitmBloc) =>
      pandoraMitmBloc.connectedState.recordPlugin != null;

  @override
  Future<void> enablePlugin(PandoraMitmBloc pandoraMitmBloc) =>
      pandoraMitmBloc.enableRecordPlugin();

  @override
  Future<void> disablePlugin(PandoraMitmBloc pandoraMitmBloc) =>
      pandoraMitmBloc.disableRecordPlugin();
}
