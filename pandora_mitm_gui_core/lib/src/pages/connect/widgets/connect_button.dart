import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_mitm_gui_core/src/state/pandora_mitm_bloc.dart';

class ConnectButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ConnectButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PandoraMitmBloc, PandoraMitmState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.map(
            disconnected: (_) => true,
            connecting: (_) => false,
            connected: (_) => false,
            disconnecting: (_) => false,
            connectionFailed: (_) => true,
          )
              ? onPressed
              : null,
          child: const Text('Connect'),
        );
      },
    );
  }
}
