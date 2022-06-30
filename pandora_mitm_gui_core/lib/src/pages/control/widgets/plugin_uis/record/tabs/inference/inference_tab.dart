import 'package:flutter/material.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_consumers/record/recorder_builder.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/tabs/inference/inference_selector.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/tabs/inference/value_type_view.dart';
import 'package:pandora_mitm_gui_core/src/plugins/record.dart';

class InferenceTab extends StatefulWidget {
  final RecordPlugin plugin;

  const InferenceTab({
    Key? key,
    required this.plugin,
  }) : super(key: key);

  @override
  State<InferenceTab> createState() => _InferenceTabState();
}

class _InferenceTabState extends State<InferenceTab> {
  @override
  Widget build(BuildContext context) {
    return RecorderBuilder<List<PandoraMitmRecord>>(
      recorder: widget.plugin.messageRecorder,
      builder: (context, records) {
        return InferenceSelector(
          builder: (context, apiMethod, valueType) {
            return FlatValueTypeView(name: apiMethod, valueType: valueType);
          },
        );
      },
    );
  }
}
