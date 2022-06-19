import 'package:flutter/material.dart';
import 'package:pandora_mitm/pandora_mitm.dart';

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

  bool _supportsPlugin(PandoraMitmPlugin plugin) => plugin is T;
}

extension PluginUiSelectors on Iterable<PluginUi> {
  PluginUi<T> forPlugin<T extends PandoraMitmPlugin>(T plugin) =>
      firstWhere((pluginUi) => pluginUi._supportsPlugin(plugin)) as PluginUi<T>;
}
