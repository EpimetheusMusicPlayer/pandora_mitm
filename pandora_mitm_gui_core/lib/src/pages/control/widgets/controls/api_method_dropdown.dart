import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/consumers/connected_state_builder.dart';
import 'package:pandora_mitm_gui_core/src/state/pandora_mitm_bloc.dart';

class ApiMethodDropdown extends StatelessWidget {
  final Set<String> apiMethods;
  final bool selectionValid;
  final TextStyle? textStyle;

  const ApiMethodDropdown({
    super.key,
    required this.apiMethods,
    this.selectionValid = true,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    const hintText = 'API method';
    return ConnectedStateBuilder<String?>(
      selector: (state) => state.selectedApiMethod,
      builder: (context, selectedApiMethod) {
        return DropdownButton<String>(
          hint: _SelectedDropdownMenuItem(Text(hintText, style: textStyle)),
          disabledHint: _SelectedDropdownMenuItem(
            Text(
              hintText,
              style:
                  textStyle?.copyWith(color: textStyle?.color?.withAlpha(0xB2)),
            ),
          ),
          value: selectionValid ? selectedApiMethod : null,
          onChanged: (apiMethod) =>
              context.read<PandoraMitmBloc>().selectApiMethod(apiMethod),
          iconEnabledColor: textStyle?.color,
          // focusColor:
          //     Colors.transparent /* https://stackoverflow.com/q/71066871 */,
          items: apiMethods
              .map(
                (apiMethod) => DropdownMenuItem(
                  value: apiMethod,
                  child: Text(apiMethod),
                ),
              )
              .toList(growable: false),
          selectedItemBuilder: (_) => apiMethods
              .map(
                (apiMethod) => _SelectedDropdownMenuItem(
                  Text(apiMethod, style: textStyle),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

class _SelectedDropdownMenuItem extends StatelessWidget {
  final Widget child;

  const _SelectedDropdownMenuItem(this.child);

  @override
  Widget build(BuildContext context) {
    return DropdownMenuItem(
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: child,
      ),
    );
  }
}
