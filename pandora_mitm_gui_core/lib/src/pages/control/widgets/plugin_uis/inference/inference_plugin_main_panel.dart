import 'package:flutter/material.dart';
import 'package:pandora_mitm/plugins.dart' as pmplg;
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/inference/inference_selector.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/inference/value_type_view.dart';

class InferencePluginMainPanel extends StatelessWidget {
  final pmplg.InferencePlugin plugin;

  const InferencePluginMainPanel({
    Key? key,
    required this.plugin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InferenceSelector(
      plugin: plugin,
      builder: (context, inference, isRequestSelected) {
        return FlatValueTypeView(
          nestedObjectEntries: isRequestSelected
              ? inference.computedRequestValueTypeEntries
              : inference.computedResponseValueTypeEntries,
        );
      },
    );
  }
}
