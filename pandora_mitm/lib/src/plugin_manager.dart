import 'package:pandora_mitm/pandora_mitm.dart';

/// An object that uses [PandoraMitmPlugin]s.
abstract class PluginCapable {
  /// The [PluginManager] managing the plugin list in use.
  ///
  /// The plugin list in use can in theory be modified at any time, but note
  /// that many plugins expect to receive responses after requests. Removing
  /// them before they do so may cause memory leaks.
  PluginManager get pluginManager;
}

/// An object that manages a list of [PandoraMitmPlugin]s.
abstract class PluginManager {
  /// The current list of plugins.
  ///
  /// This list must not be modified; use the dedicated plugin loading methods
  /// instead.
  List<PandoraMitmPlugin> get plugins;

  /// A stream that emits the current list of plugins whenever it is changed.
  Stream<List<PandoraMitmPlugin>> get pluginListChanges;

  /// Adds a [plugin] to the end of the plugin list.
  Future<void> addPlugin(PandoraMitmPlugin plugin);

  /// Adds several [plugins] to the end of the plugin list.
  Future<void> addPlugins(Iterable<PandoraMitmPlugin> plugins);

  /// Inserts a [plugin] in the plugin list at the given [index].
  Future<void> insertPlugin(int index, PandoraMitmPlugin plugin);

  /// Inserts several [plugins] in the plugin list at the given [index].
  Future<void> insertPlugins(int index, Iterable<PandoraMitmPlugin> plugins);

  /// Moves a plugin from its current position ([oldIndex]) to a new one
  /// ([newIndex]).
  ///
  /// The plugin will not be detached in the process.
  void movePlugin(int oldIndex, int newIndex);

  /// Removes all plugins equal to the given [plugin] from the plugin list.
  Future<void> removePlugin(PandoraMitmPlugin pluginToRemove);

  /// Removes all plugins equal to any of the given [pluginsToRemove] from the
  /// plugin list.
  Future<void> removePlugins(Set<PandoraMitmPlugin> pluginsToRemove);

  /// Removes all plugins in the range [start] (inclusive) to [end] (exclusive)
  /// from the plugin list.
  Future<void> removePluginRange(int start, int end);

  /// Removes the plugin at the given [index] from the plugin list.
  Future<PandoraMitmPlugin> removePluginAt(int index);

  /// Removes all plugins from the plugin list.
  Future<void> removeAllPlugins();
}
