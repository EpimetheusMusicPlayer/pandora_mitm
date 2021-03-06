import 'package:flutter/material.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/state/pandora_mitm_bloc.dart';

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

  /// Handles a context menu selection.
  ///
  /// Returns true if the [selection] was handled.
  bool handleContextMenuSelection(T plugin, Object selection) => false;

  bool isPluginEnabled(PandoraMitmBloc pandoraMitmBloc);

  Future<void> enablePlugin(PandoraMitmBloc pandoraMitmBloc);

  Future<void> disablePlugin(PandoraMitmBloc pandoraMitmBloc);

  bool _supportsPlugin(PandoraMitmPlugin plugin) => plugin is T;
}

extension PluginUiSelectors on Iterable<PluginUi> {
  PluginUi<T> forPlugin<T extends PandoraMitmPlugin>(T plugin) =>
      firstWhere((pluginUi) => pluginUi._supportsPlugin(plugin)) as PluginUi<T>;
}
