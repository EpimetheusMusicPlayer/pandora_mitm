import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm/plugins.dart' as pmplg;
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/feature_unlock/feature_unlock_plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/mitmproxy_ui_helper/mitmproxy_ui_helper_plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/reauthentication/reauthentication_plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/record_plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/plugins/record.dart';

abstract class PluginUi<T extends PandoraMitmPlugin> {
  const PluginUi();

  String get displayName;

  String get description;

  IconData? get iconData => null;

  bool get hasMainPanel => false;

  Widget buildMainPanel(BuildContext context, T plugin) =>
      throw UnsupportedError('This plugin does not have a main panel.');

  List<PopupMenuItem<Object?>> buildContextMenuItems(
    BuildContext context,
    T plugin,
  ) =>
      const [];

  void handleContextMenuSelection(T plugin, Object selection) {}

  T buildPlugin();

  static PluginUi<T> fromPlugin<T extends PandoraMitmPlugin>(T plugin) {
    if (plugin is RecordPlugin) {
      return const RecordPluginUi() as PluginUi<T>;
    }
    if (plugin is pmplg.FeatureUnlockPlugin) {
      return const FeatureUnlockPluginUi() as PluginUi<T>;
    }
    if (plugin is pmplg.ReauthenticationPlugin) {
      return const ReauthenticationPluginUi() as PluginUi<T>;
    }
    if (plugin is pmplg.MitmproxyUiHelperPlugin) {
      return const MitmproxyUiHelperPluginUi() as PluginUi<T>;
    }
    throw UnsupportedError('Plugin type ${plugin.runtimeType} not supported!');
  }
}
