import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_mitm/plugins.dart' as pmplg;
import 'package:pandora_mitm_extra/plugins.dart' as pmeplg;
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/inference/inference_plugin_main_panel.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/mixins/boilerplate_stripper_plugin_ui_mixin.dart';
import 'package:pandora_mitm_gui_core/src/state/pandora_mitm_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class InferencePluginUi extends PluginUi<pmeplg.InferenceServerPlugin>
    with BoilerplateStripperPluginUiMixin {
  const InferencePluginUi();

  @override
  String get displayName => 'Inference';

  @override
  String get description =>
      'Infers API request and response definitions over time.';

  @override
  IconData? get iconData => Icons.school;

  @override
  bool get hasMainPanel => true;

  @override
  Widget buildMainPanel(
    BuildContext context,
    pmeplg.InferenceServerPlugin<pmplg.InferencePlugin> plugin,
  ) =>
      InferencePluginMainPanel(plugin: plugin.inferencePlugin);

  @override
  pmplg.BoilerplateStripperPlugin getBoilerplateStripperPlugin(
    pmeplg.InferenceServerPlugin<pmplg.InferencePlugin> plugin,
  ) =>
      plugin.inferencePlugin;

  @override
  List<PopupMenuItem<Object?>> buildContextMenuItems(
    BuildContext context,
    pmeplg.InferenceServerPlugin plugin,
  ) {
    Future<void> launchWebUi() async => launchUrl(
          Uri(
            scheme: 'http',
            host: 'localhost',
            port: await plugin.runningPort,
          ),
          mode: LaunchMode.externalApplication,
        );

    return [
      if (plugin.running)
        // ignore: prefer_void_to_null
        PopupMenuItem<Null>(
          onTap: launchWebUi,
          child: const Text('Open webpage'),
        ),
      // ignore: prefer_void_to_null
      PopupMenuItem<Null>(
        onTap: () async {
          await plugin.changeServe(serve: !plugin.serve);
          if (!plugin.running) return;
          launchWebUi();
        },
        child: Text(plugin.running ? 'Stop HTTP server' : 'Start HTTP server'),
      ),
      // ignore: prefer_void_to_null
      PopupMenuItem<Null>(
        onTap: () async {
          await context.read<PandoraMitmBloc>().clearInferenceSelection();
          plugin.inferencePlugin.clear();
        },
        child: const Text('Clear inferences'),
      ),
      ...super.buildContextMenuItems(context, plugin),
    ];
  }

  @override
  bool isPluginEnabled(PandoraMitmBloc pandoraMitmBloc) =>
      pandoraMitmBloc.state.requireConnected.inferenceServerPlugin != null;

  @override
  Future<void> enablePlugin(PandoraMitmBloc pandoraMitmBloc) =>
      pandoraMitmBloc.enableInferenceServerPlugin();

  @override
  Future<void> disablePlugin(PandoraMitmBloc pandoraMitmBloc) =>
      pandoraMitmBloc.disableInferenceServerPlugin();
}
