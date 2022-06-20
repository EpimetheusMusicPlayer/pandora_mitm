import 'package:pandora_mitm/plugin_dev.dart';

/// A plugin that can be configured not to explicitly intercept messages itself,
/// and rather only process messages intercepted by other plugins.
abstract class PassiveCapablePlugin implements PandoraMitmPlugin {
  /// If true, this plugin will only observe or modify API messages that have
  /// been intercepted by other plugins.
  ///
  /// This may vastly reduce the amount of data being streamed and processed.
  abstract bool passive;
}
