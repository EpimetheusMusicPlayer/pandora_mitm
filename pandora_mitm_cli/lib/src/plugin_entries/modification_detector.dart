import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm/plugins.dart' as pmplg;
import 'package:pandora_mitm_cli/src/plugin_entry.dart';

/// A [PluginEntry] for the [ModificationDetectorPlugin] plugin.
class ModificationDetectorPluginEntry extends PluginEntry {
  late final _modificationDetectorPlugin = pmplg.ModificationDetectorPlugin()
    ..requestStageModifications.forEach((recordSet) {
      if (recordSet.wasModified) _writeRecordMessage(recordSet, 'REQ');
    })
    ..responseStageModifications.forEach((recordSet) {
      if (recordSet.wasModified) _writeRecordMessage(recordSet, 'RSP');
    });

  @override
  String get name => 'modification_detector';

  @override
  String get description => 'Detects modifications across a range of plugins.';

  @override
  bool get largePotentialImpact => false;

  @override
  String? validatePluginList(List<PluginEntry> selectedPluginEntries) =>
      selectedPluginEntries
              .whereType<ModificationDetectorPluginEntry>()
              .length
              .isOdd
          ? 'The $name plugin can only be used in pairs!'
          : null;

  @override
  pmplg.ModificationDetectorPlugin create(
    Map<String, bool> flags,
    Map<String, Object?> options,
  ) =>
      _modificationDetectorPlugin;

  void _writeRecordMessage(
    PandoraMitmModificationRecordSet recordSet,
    String stage, [
    StringSink? customBuffer,
  ]) =>
      writeLogMessage(
        customBuffer: customBuffer,
        flowId: recordSet.flowId,
        source: 'MOD',
        status: stage,
        method: recordSet.apiRequest.original?.method,
        extra:
            'request: ${recordSet.apiRequest.wasModified}, response: ${recordSet.response.wasModified}',
      );
}
