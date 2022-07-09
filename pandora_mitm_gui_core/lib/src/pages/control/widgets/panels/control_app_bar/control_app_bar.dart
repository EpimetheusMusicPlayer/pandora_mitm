import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/state/pandora_mitm_bloc.dart';

class ControlAppBar extends StatelessWidget {
  final PluginCapablePandoraMitm pandoraMitm;

  const ControlAppBar({
    super.key,
    required this.pandoraMitm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      title: const Text('Pandora MITM'),
      toolbarHeight: (theme.appBarTheme.toolbarHeight ?? kToolbarHeight) - 2,
      backgroundColor: theme.primaryColor,
      titleTextStyle: theme.typography.white.headline6,
      iconTheme: theme.iconTheme.copyWith(color: Colors.white),
      leading: IconButton(
        onPressed: () => context.read<PandoraMitmBloc>().disconnect(),
        tooltip: 'Disconnect',
        icon: const Icon(Icons.power_settings_new),
      ),
    );
  }
}
