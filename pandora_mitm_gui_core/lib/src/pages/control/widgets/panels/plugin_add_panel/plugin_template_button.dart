import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/state/pandora_mitm_bloc.dart';
import 'package:popup_menu_title/popup_menu_title.dart';

class PluginTemplateButton extends StatelessWidget {
  final PluginManager pluginManager;
  final Map<String, List<PluginUi>> availablePluginTemplates;

  const PluginTemplateButton({
    Key? key,
    required this.pluginManager,
    required this.availablePluginTemplates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Iterable<PluginUi>>(
      itemBuilder: (context) => [
        const PopupMenuTitle(title: 'Plugin templates'),
        for (final pluginTemplateEntry in availablePluginTemplates.entries)
          PopupMenuItem(
            value: pluginTemplateEntry.value,
            child: Text(pluginTemplateEntry.key),
          ),
      ],
      onSelected: (pluginUiList) async {
        final pandoraMitmBloc = context.read<PandoraMitmBloc>();
        await pandoraMitmBloc.waitUntilPluginListUpdated();
        await pandoraMitmBloc.disableAllPlugins();
        for (final pluginUi in pluginUiList) {
          await pluginUi.enablePlugin(pandoraMitmBloc);
        }
      },
      tooltip: 'Use plugin template',
      icon: const Icon(Icons.keyboard_arrow_down),
    );
  }
}
