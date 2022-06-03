import 'package:pandora_mitm/plugins.dart' as pmplg;
import 'package:pandora_mitm_cli/src/plugin_entry.dart';

/// A [PluginEntry] for the [ReauthenticationPlugin] plugin.
class ReauthenticatePluginEntry extends PluginEntry {
  const ReauthenticatePluginEntry();

  @override
  String get name => 'reauthenticate';

  @override
  String get description =>
      'Forces the first Pandora client that connects to reauthenticate.';

  @override
  bool get largePotentialImpact => true;

  @override
  pmplg.ReauthenticationPlugin create(
    Map<String, bool> flags,
    Map<String, Object?> options,
  ) =>
      pmplg.ReauthenticationPlugin();
}
