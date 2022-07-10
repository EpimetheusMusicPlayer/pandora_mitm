import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_mitm_gui_core/src/state/pandora_mitm_bloc.dart';

class ConnectedStateBuilder<T> extends StatelessWidget {
  static final _disconnectedIndicator = Object();

  final BlocWidgetSelector<ConnectedPandoraMitmState, T>? selector;
  final BlocWidgetBuilder<T> builder;

  const ConnectedStateBuilder({
    super.key,
    this.selector,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PandoraMitmBloc, PandoraMitmState, Object?>(
      selector: (state) {
        if (state is! ConnectedPandoraMitmState) return _disconnectedIndicator;
        return (selector ?? _identitySelector)(state);
      },
      builder: (context, selection) {
        if (identical(selection, _disconnectedIndicator)) {
          return const SizedBox.shrink();
        }
        return builder(context, selection as T);
      },
    );
  }

  static ConnectedPandoraMitmState _identitySelector(
    ConnectedPandoraMitmState state,
  ) =>
      state;
}
