import 'package:flutter/widgets.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/consumers/connected_state_builder.dart';

class SelectedInferenceBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    ApiMethodInference? selectedInference,
  ) builder;

  const SelectedInferenceBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ConnectedStateBuilder(
      selector: (state) => state.selectedInference,
      builder: builder,
    );
  }
}
