import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/state/pandora_mitm_bloc.dart';

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
    return BlocSelector<PandoraMitmBloc, PandoraMitmState, ApiMethodInference?>(
      selector: (state) => state.requireConnected.selectedInference,
      builder: builder,
    );
  }
}
