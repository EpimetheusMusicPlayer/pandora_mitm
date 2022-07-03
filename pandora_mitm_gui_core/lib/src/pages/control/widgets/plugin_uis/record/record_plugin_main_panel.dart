import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/state/inference_bloc.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/tabs/annotation_list/annotation_list_tab.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/tabs/inference/inference_tab.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/tabs/record_list/record_list_tab.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/themed_tab_bar.dart';
import 'package:pandora_mitm_gui_core/src/plugins/record.dart';

class RecordPluginMainPanel extends StatefulWidget {
  final RecordPlugin plugin;

  const RecordPluginMainPanel({
    Key? key,
    required this.plugin,
  }) : super(key: key);

  @override
  State<RecordPluginMainPanel> createState() => _RecordPluginMainPanelState();
}

class _RecordPluginMainPanelState extends State<RecordPluginMainPanel> {
  late InferenceBloc _inferenceBloc;

  @override
  void initState() {
    super.initState();
    _inferenceBloc = InferenceBloc(recorder: widget.plugin.messageRecorder);
  }

  @override
  void didUpdateWidget(RecordPluginMainPanel oldWidget) {
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
