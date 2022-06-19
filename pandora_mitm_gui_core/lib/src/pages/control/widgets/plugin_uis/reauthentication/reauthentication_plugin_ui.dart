import 'package:flutter/material.dart';
import 'package:pandora_mitm/plugins.dart' as pmplg;
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_ui.dart';

class ReauthenticationPluginUi extends PluginUi<pmplg.ReauthenticationPlugin> {
  const ReauthenticationPluginUi();

  @override
  String get displayName => 'Reauthentication';

  @override
  String get description =>
      'Fakes invalid token error responses to trigger re-authentications.';

  @override
  IconData? get iconData => Icons.login;

  @override
  pmplg.ReauthenticationPlugin buildPlugin() => pmplg.ReauthenticationPlugin();

  @override
  List<PopupMenuItem<Object?>> buildContextMenuItems(
    BuildContext context,
    pmplg.ReauthenticationPlugin plugin,
  ) =>
      [
        // ignore: prefer_void_to_null
        PopupMenuItem<Null>(
          onTap: plugin.invalidate,
          child: const Text('Invalidate sessions'),
        ),
      ];
}
