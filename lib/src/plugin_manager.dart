import 'package:pandora_mitm/pandora_mitm.dart';

/// An object that manages a list of plugins.
abstract class PluginManager {
  /// The current list of plugins.
  ///
  /// This list must not be modified; use the dedicated plugin loading methods
  /// instead.
  List<PandoraMitmPlugin> get plugins;

  /// A stream that emits the current list of plugins whenever it is changed.
  Stream<List<PandoraMitmPlugin>> get pluginListChanges;

  /// Adds a [plugin] to the end of the plugin list.
  void addPlugin(PandoraMitmPlugin plugin);

  /// Adds several [plugins] to the end of the plugin list.
  void addPlugins(Iterable<PandoraMitmPlugin> plugins);

  /// Inserts a [plugin] in the plugin list at the given [index].
  void insertPlugin(int index, PandoraMitmPlugin plugin);

  /// Inserts several [plugins] in the plugin list at the given [index].
  void insertPlugins(int index, Iterable<PandoraMitmPlugin> plugins);

  /// Removes all plugins equal to the given [plugin] from the plugin list.
  void removePlugin(PandoraMitmPlugin pluginToRemove);

  /// Removes all plugins equal to any of the given [pluginsToRemove] from the
  /// plugin list.
  void removePlugins(Set<PandoraMitmPlugin> pluginsToRemove);

  /// Removes all plugins in the range [start] (inclusive) to [end] (exclusive)
  /// from the plugin list.
  void removePluginRange(int start, int end);

  /// Removes the plugin at the given [index] from the plugin list.
  void removePluginAt(int index);
}
