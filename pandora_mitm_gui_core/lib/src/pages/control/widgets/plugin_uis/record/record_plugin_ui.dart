import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/mixins/boilerplate_stripper_plugin_ui_mixin.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/state/inference_bloc.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/tabs/annotation_list/annotation_list_tab.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/tabs/inference/inference_tab.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/tabs/record_list/record_list_tab.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/themed_tab_bar.dart';
import 'package:pandora_mitm_gui_core/src/plugins/record.dart';

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
      _RecordPluginUi(plugin: plugin);

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
  RecordPlugin buildPlugin() => RecordPlugin(stripBoilerplate: true);
}

class _RecordPluginUi extends StatefulWidget {
  final RecordPlugin plugin;

  const _RecordPluginUi({
    Key? key,
    required this.plugin,
  }) : super(key: key);

  @override
  State<_RecordPluginUi> createState() => _RecordPluginUiState();
}

class _RecordPluginUiState extends State<_RecordPluginUi> {
  late InferenceBloc _inferenceBloc;

  @override
  void initState() {
    super.initState();
    _inferenceBloc = InferenceBloc(recorder: widget.plugin.messageRecorder);
  }

  @override
  void didUpdateWidget(_RecordPluginUi oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(
      widget.plugin.messageRecorder,
      oldWidget.plugin.messageRecorder,
    )) {
      _inferenceBloc.close();
      _inferenceBloc = InferenceBloc(recorder: widget.plugin.messageRecorder);
    }
  }

  @override
  void dispose() {
    _inferenceBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _inferenceBloc,
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const ThemedTabBar(
              tabs: [
                ThemedTabEntry('Messages', Icons.cloud_sync),
                ThemedTabEntry('Metadata', Icons.library_music),
                ThemedTabEntry('Inference', Icons.school),
              ],
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  RecordListTab(plugin: widget.plugin),
                  AnnotationListTab(plugin: widget.plugin),
                  InferenceTab(plugin: widget.plugin),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
