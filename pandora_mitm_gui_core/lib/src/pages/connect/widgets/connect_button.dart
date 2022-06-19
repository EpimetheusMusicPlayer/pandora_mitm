import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_mitm_gui_core/src/state/pandora_mitm_bloc.dart';

class ConnectButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ConnectButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PandoraMitmBloc, PandoraMitmState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state is PandoraMitmDisconnected ? onPressed : null,
          child: const Text('Connect'),
        );
      },
    );
  }
}
