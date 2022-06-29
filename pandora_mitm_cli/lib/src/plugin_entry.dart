import 'dart:io';

import 'package:meta/meta.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_cli/src/cli_option_parser.dart';

/// A plugin entry to be accessible via the CLI.
abstract class PluginEntry {
  const PluginEntry();

  /// The name of the plugin, to be used with the CLI plugins option.
  String get name;

  /// A description of the plugin.
  String get description;

  /// True if the plugin has a large potential impact to latency and system
  /// resources.
  bool get largePotentialImpact;

  /// Configuration flags for the plugin.
  Iterable<PluginFlag> get flags => const Iterable.empty();

  /// Configuration options for the plugin.
  Iterable<PluginOption<Object?>> get options => const Iterable.empty();

  /// Returns a [String] with an error message if there's a problem with the
  /// [selectedPluginEntries], or `null` otherwise.
  String? validatePluginList(List<PluginEntry> selectedPluginEntries) => null;

  /// Creates a [PandoraMitmPlugin] to be used.
  PandoraMitmPlugin create(
    Map<String, bool> flags,
    Map<String, Object?> options,
  );

  /// Writes a standardised log message.
  @protected
  void writeLogMessage({
    StringSink? customBuffer,
    required String flowId,
    required String source,
    String? status,
    String? method,
    String? extra,
  }) {
    final buffer = customBuffer ?? stdout;
    buffer.write('[');
    buffer.write(flowId);
    buffer.write('] ');
    buffer.write(source);
    if (status != null) {
      buffer.write(': ');
      buffer.write(status);
    }
    buffer.write(': ');
    buffer.write(method ?? '<unknown method>');
    if (extra != null) {
      buffer.write(' (');
      buffer.write(extra);
      buffer.write(')');
    }
    buffer.writeln();
  }
}

/// A plugin configuration option.
///
/// Supported types for [T] are:
/// - [String]
/// - [int]
/// - [double]
/// - [num]
/// - [Uri]
/// - A [List] of any of the above
class PluginOption<T> {
  /// The name of the option, to be used as a CLI option.
  final String name;

  /// A description of the option.
  final String description;

  /// True if the option is not mandatory.
  final bool optional;

  /// The default value of the option, if none is provided.
  final T? defaultValue;

  const PluginOption({
    required this.name,
    required this.description,
    this.optional = true,
    this.defaultValue,
  });

  /// Parses a [String] representation of the option value into type [T].
  T parse(String value) => CliOptionParser<T>(value)();

  /// Converts the option value into a [String] representation.
  static String display(Object value) => CliOptionParser.display(value);
}

/// A plugin configuration flag.
class PluginFlag extends PluginOption<bool> {
  const PluginFlag({
    required super.name,
    required super.description,
    super.defaultValue = false,
  });

  @override
  Never parse(String value) =>
      throw UnsupportedError('Flags should not be parsed manually!');
}
