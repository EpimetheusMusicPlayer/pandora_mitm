import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/state/pandora_mitm_bloc.dart';

class PluginAddButton extends StatefulWidget {
  final PluginManager pluginManager;
  final List<PluginUi> availablePluginUis;
  final Color? color;
  final double? size;
  final bool showTooltip;

  const PluginAddButton({
    Key? key,
    required this.pluginManager,
    required this.availablePluginUis,
    this.color,
    this.size,
    this.showTooltip = true,
  }) : super(key: key);

  @override
  State<PluginAddButton> createState() => _PluginAddButtonState();
}

class _PluginAddButtonState extends State<PluginAddButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: widget.size,
      color: widget.color,
      onPressed: context.select<PandoraMitmBloc, bool>(
        (pandoraMitmBloc) => pandoraMitmBloc.state.allPluginsEnabled,
      )
          ? null
          : () async {
              final selection = await showDialog<PluginUi>(
                context: context,
                builder: (context) {
                  final pandoraMitmBloc = context.watch<PandoraMitmBloc>();
                  final relevantPluginUis = widget.availablePluginUis.where(
                    (pluginUi) => !pluginUi.isPluginEnabled(pandoraMitmBloc),
                  );

                  return SimpleDialog(
                    title: const Text('Add plugin'),
                    children: relevantPluginUis
                        .map(
                          (pluginUi) => SimpleDialogOption(
                            onPressed: () => Navigator.pop(context, pluginUi),
                            child: ListTile(
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              contentPadding: EdgeInsets.zero,
                              mouseCursor: MouseCursor.defer,
                              leading: Icon(pluginUi.iconData),
                              title: Text(pluginUi.displayName),
                              subtitle: Text(pluginUi.description),
                            ),
                          ),
                        )
                        .toList(growable: false),
                  );
                },
              );
              if (selection == null) return;
              if (!mounted) return;
              final pandoraMitmBloc = context.read<PandoraMitmBloc>();
              await pandoraMitmBloc.waitUntilPluginListUpdated();
              await selection.enablePlugin(pandoraMitmBloc);
            },
      tooltip: widget.showTooltip ? 'Add plugin' : null,
      icon: const Icon(Icons.add),
    );
  }
}
