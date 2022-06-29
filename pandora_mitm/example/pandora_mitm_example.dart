import 'dart:async';
import 'dart:io';

import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm/plugins.dart' as pmplg;

void main() async {
  final streamPlugin = pmplg.StreamPlugin()
    ..recordStream.forEach((record) {
      stdout.writeln(
        '[${record.flowId}] API: SND: ${record.apiRequest.method}${record.apiRequest.encrypted ? ' (encrypted)' : ''}',
      );
      record.responseFuture.then(
        (response) => stdout.writeln(
          '[${record.flowId}] API: RCV: ${record.apiRequest.method}${response.encryptedBody ? ' (encrypted)' : ''}',
        ),
      );
    });

  final modificationDetectorPlugin = pmplg.ModificationDetectorPlugin()
    ..requestStageModifications.forEach(
      (modificationRecordSet) {
        if (!modificationRecordSet.wasModified) return;
        stdout.writeln(
          '[${modificationRecordSet.flowId}] MOD: REQ: ${modificationRecordSet.apiRequest.original?.method} (request: ${modificationRecordSet.apiRequest.wasModified}, response: ${modificationRecordSet.response.wasModified})',
        );
      },
    )
    ..responseStageModifications.forEach(
      (modificationRecordSet) {
        if (!modificationRecordSet.wasModified) return;
        stdout.writeln(
          '[${modificationRecordSet.flowId}] MOD: RSP: ${modificationRecordSet.apiRequest.original?.method} (request: ${modificationRecordSet.apiRequest.wasModified}, response: ${modificationRecordSet.response.wasModified})',
        );
      },
    );

  final PluginCapablePandoraMitm pandoraMitm =
      BackgroundMitmproxyRiPandoraMitm()
        ..pluginManager.addPlugins([
          streamPlugin,
          modificationDetectorPlugin,
          pmplg.FeatureUnlockPlugin(),
          modificationDetectorPlugin,
        ]);

  pandoraMitm.pluginManager.pluginListChanges.forEach(
      (pluginList) => stdout.writeln('Plugin list changed: $pluginList'));

  stdout.writeln('Connecting...');
  await pandoraMitm.connect();
  stdout.writeln('Connected.');

  // Plugins can be added at any time.
  pandoraMitm.pluginManager
      .addPlugin(pmplg.MitmproxyUiHelperPlugin(stripBoilerplate: true));

  late final StreamSubscription<ProcessSignal> sigintSubscription;
  sigintSubscription = ProcessSignal.sigint.watch().listen((_) async {
    sigintSubscription.cancel();
    await pandoraMitm.disconnect();
  });
  await pandoraMitm.done;
}
