import 'package:flutter/material.dart';
import 'package:pandora_mitm/plugins.dart' as pmplg;
import 'package:pandora_mitm_extra/plugins.dart' as pmeplg;
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/mixins/boilerplate_stripper_plugin_ui_mixin.dart';
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
      ...super.buildContextMenuItems(context, plugin),
    ];
  }

  @override
  pmeplg.InferenceServerPlugin buildPlugin() => pmeplg.InferenceServerPlugin(
        pmplg.BackgroundInferencePlugin.new,
        port: 46337,
        stripBoilerplate: true,
      );
}
