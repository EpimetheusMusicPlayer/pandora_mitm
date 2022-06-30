import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iapetus_meta/typing.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/state/inference_bloc.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/tabs/inference/inference_selection_bar.dart';

class InferenceSelector extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    String apiMethod,
    ValueType valueType,
  ) builder;

  const InferenceSelector({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InferenceBloc, InferenceState>(
      builder: (context, state) {
        return Column(
          children: [
            InferenceSelectionBar(
              apiMethods: state.apiMethods,
              selectedApiMethod: state.selectedApiMethod,
              isRequestSelected: state.isRequestSelected,
              onApiMethodSelected: (selectedApiMethod) => context
                  .read<InferenceBloc>()
                  .update(apiMethod: selectedApiMethod),
              onMessageTypeSelected: (isRequestSelected) => context
                  .read<InferenceBloc>()
                  .update(isRequestSelected: isRequestSelected),
              inProgress: state.status == InferenceStatus.inferring,
            ),
            const Divider(height: 0),
            if (state.selectedApiMethod != null && state.valueType != null)
              Expanded(
                child: builder(
                  context,
                  state.selectedApiMethod!,
                  state.valueType!,
                ),
              ),
          ],
        );
      },
    );
  }
}
