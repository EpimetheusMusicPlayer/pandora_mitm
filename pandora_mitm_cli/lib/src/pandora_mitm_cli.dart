import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_cli/src/cli_option_parser.dart';
import 'package:pandora_mitm_cli/src/plugin_entries/feature_unlock.dart';
import 'package:pandora_mitm_cli/src/plugin_entries/inference.dart';
import 'package:pandora_mitm_cli/src/plugin_entries/lite_log.dart';
import 'package:pandora_mitm_cli/src/plugin_entries/log.dart';
import 'package:pandora_mitm_cli/src/plugin_entries/modification_detector.dart';
import 'package:pandora_mitm_cli/src/plugin_entries/reauthenticate.dart';
import 'package:pandora_mitm_cli/src/plugin_entries/ui_helper.dart';
import 'package:pandora_mitm_cli/src/plugin_entry.dart';
import 'package:pandora_mitm_cli/src/template.dart';

/// The main entry point for the CLI.
///
/// [variantName] is a custom CLI variant name, displayed on launch.
/// [arguments] is the list of CLI arguments.
/// [extraPluginEntries] can be provided to add custom plugin entries to the
/// CLI.
/// [extraTemplates] can be provided to add custom plugin list templates to the
/// CLI.
/// [defaultTemplate] can be set to choose a custom default template.
/// [onConnect] can be used to perform an action once the connection to the
/// HTTP interception backend is established.
Future<void> run(
  String variantName,
  List<String> arguments, {
  List<PluginEntry> extraPluginEntries = const [],
  List<Template> extraTemplates = const [],
  String? defaultTemplate = 'ui',
  FutureOr<void> Function(PluginCapablePandoraMitm pandoraMitm)? onConnect,
}) async {
  final pluginEntries = {
    for (final pluginEntry in [
      const LiteLogPluginEntry(),
      const LogPluginEntry(),
      const FeatureUnlockPluginEntry(),
      const ReauthenticatePluginEntry(),
      const InferencePluginEntry(),
      const UiHelperPluginEntry(),
      ModificationDetectorPluginEntry(),
      ...extraPluginEntries,
    ])
      pluginEntry.name: pluginEntry,
  };

  final templates = {
    for (final templateEntry in [
      const Template(
        'cli',
        'A template for performant CLI logging.',
        ['lite_log'],
      ),
      const Template(
        'ui',
        'A template to enhance the mitmproxy UI experience.',
        ['log', 'ui_helper'],
      ),
      const Template(
        'unlock',
        'A template for unlocking features.',
        [
          'lite_log',
          'modification_detector',
          'reauthenticate',
          'feature_unlock',
          'modification_detector',
        ],
      ),
      const Template(
        'unlock-ui',
        'A cross between the unlock and ui templates.',
        [
          'log',
          'modification_detector',
          'reauthenticate',
          'feature_unlock',
          'modification_detector',
          'ui_helper',
        ],
      ),
      ...extraTemplates,
    ])
      templateEntry.name: templateEntry,
  };

  final argParser = ArgParser()
    ..addSeparator('Program options:')
    ..addOption(
      'help',
      abbr: 'h',
      help: 'Print program or plugin usage information.',
      allowedHelp: {
        'all': 'Print usage information for the program and all plugins.',
        for (final pluginName in pluginEntries.keys)
          pluginName: 'Print usage information for the $pluginName plugin.',
      },
      aliases: const ['usage'],
    )
    ..addOption(
      'host',
      help:
          'The hostname or IP address of the mitmproxy remote interceptions server.',
      defaultsTo: 'localhost',
    )
    ..addOption(
      'port',
      help: 'The port of the mitmproxy remote interceptions server.',
      defaultsTo: '8082',
    )
    ..addOption(
      'template',
      abbr: 't',
      help: 'A template plugin list to use.',
      allowed: templates.keys,
      allowedHelp: {
        for (final template in templates.values)
          template.name:
              '${template.description} (${template.plugins.join(',')})',
      },
      defaultsTo: defaultTemplate,
    )
    ..addOption(
      'plugins',
      abbr: 'p',
      help: 'A comma-separated list of plugins to use.',
      allowedHelp: {
        for (final pluginEntry in pluginEntries.values)
          pluginEntry.name: pluginEntry.descriptionWithImpactWarning,
      },
      defaultsTo: '',
    );

  argParser.addSeparator('Plugin options:');
  for (final pluginEntry in pluginEntries.values) {
    pluginEntry.addToArgParser(argParser);
  }

  stdout.writeln('Pandora MITM CLI ($variantName edition)');

  late final ArgResults argResults;
  late final String? helpTarget;
  try {
    argResults = argParser.parse(arguments);
    helpTarget = argResults['help'] as String?;
  } on FormatException catch (e) {
    switch (e.message) {
      case 'Missing argument for "help".':
        helpTarget = 'all';
        break;
      default:
        stderr.writeln(e.message);
        exit(2);
    }
  }

  if (helpTarget != null) {
    switch (helpTarget) {
      case 'all':
        stdout.writeln(argParser.usage);
        return;
      default:
        if (!pluginEntries.containsKey(helpTarget)) {
          stderr.writeln('Invalid help target: $helpTarget');
          exit(2);
        }
        final pluginEntry = pluginEntries[helpTarget]!;
        final pluginParser = ArgParser();
        pluginEntry.addToArgParser(pluginParser);
        if (pluginParser.options.isEmpty) {
          stdout.writeln('The ${pluginEntry.name} plugin has no options.');
        } else {
          stdout.writeln(pluginParser.usage);
        }
        return;
    }
  }

  final templateWasProvided = argResults.wasParsed('template');
  final pluginsWereProvided = argResults.wasParsed('plugins');
  if (templateWasProvided && pluginsWereProvided) {
    stderr.writeln(
      'Cannot use select a template and individual plugins at the same time.',
    );
    exit(2);
  }

  final host = argResults['host'] as String;
  final port = CliOptionParser<int>(argResults['port'] as String)();

  final List<String> selectedPluginNames;
  if (pluginsWereProvided) {
    selectedPluginNames =
        CliOptionParser<List<String>>(argResults['plugins'] as String)();
    for (final pluginName in selectedPluginNames) {
      if (!pluginEntries.containsKey(pluginName)) {
        stderr.writeln('Unknown plugin: $pluginName');
        exit(2);
      }
    }
  } else {
    final selectedTemplateName = argResults['template'];
    if (templateWasProvided) {
      if (!templates.containsKey(selectedTemplateName)) {
        stderr.writeln('Unknown template: $selectedTemplateName');
        exit(2);
      }
    }
    selectedPluginNames = templates[selectedTemplateName]!.plugins;
  }

  final selectedPluginEntries = selectedPluginNames
      .map((pluginName) => pluginEntries[pluginName]!)
      .toList(growable: false);

  for (final pluginEntry in selectedPluginEntries) {
    final validationMessage =
        pluginEntry.validatePluginList(selectedPluginEntries);
    if (validationMessage != null) {
      stderr.writeln(validationMessage);
      exit(2);
    }
  }

  final plugins = selectedPluginEntries
      .map(
        (pluginEntry) => pluginEntry.create(
          {
            for (final flag in pluginEntry.flags)
              flag.name: argResults[flag.name] as bool,
          },
          {
            for (final option in pluginEntry.options)
              option.name: argResults[option.name] == null
                  ? option.defaultValue
                  : option.parse(argResults[option.name] as String),
          },
        ),
      )
      .toList(growable: false);

  Logger.root.onRecord.listen(
    (record) => stdout.writeln(
        '[${record.level.name}] [${record.loggerName}] ${record.message}'),
  );

  final pandoraMitm = BackgroundMitmproxyRiPandoraMitm()
    ..pluginManager.addPlugins(plugins);

  stdout.writeln('Plugins enabled: ${selectedPluginNames.join(',')}');
  stdout.writeln('Connecting to ws://$host:$port...');

  try {
    await pandoraMitm.connect(host: host, port: port);
  } on SocketException catch (e) {
    stderr.writeln(
        'Could not connect to ws://$host:$port: ${e.message} (${e.osError})');
    exit(-1);
  }
  await onConnect?.call(pandoraMitm);

  stdout.writeln('Connected to ws://$host:$port.');

  late final StreamSubscription<ProcessSignal> sigintSubscription;
  sigintSubscription = ProcessSignal.sigint.watch().listen((_) async {
    sigintSubscription.cancel();
    await pandoraMitm.disconnect();
  });
  await pandoraMitm.done;

  stdout.writeln('Disconnected from ws://$host:$port.');
}

extension on PluginEntry {
  String get descriptionWithImpactWarning {
    final buffer = StringBuffer(description);
    if (largePotentialImpact) {
      buffer.write(' (large potential performance impact)');
    }
    return buffer.toString();
  }

  void addToArgParser(ArgParser argParser) {
    argParser.addSeparator('$name: $descriptionWithImpactWarning');
    for (final flag in flags) {
      argParser.addFlag(
        flag.name,
        help: flag.description,
        defaultsTo: flag.defaultValue,
        negatable: false,
      );
    }
    for (final option in options) {
      argParser.addOption(
        option.name,
        help: option.description,
        defaultsTo: option.defaultValue == null
            ? null
            : PluginOption.display(option.defaultValue!),
        mandatory: !option.optional,
      );
    }
  }
}
