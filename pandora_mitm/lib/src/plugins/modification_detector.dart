import 'dart:async';

import 'package:pandora_mitm/plugin_dev.dart';
import 'package:pandora_mitm/src/entities/modification_record.dart';

/// A [PandoraMitm] plugin to detect modifications made to API requests and
/// responses.
///
/// This plugin detects modifications made over a _range_ of plugins; to use it,
/// add the same instance twice to the plugin list, with other plugins to
/// observe in-between.
///
/// The plugin can be added to the plugin list more than twice, as long as an
/// even number are in use - observances will be made between each pair of
/// entries. Adding an odd number of instances will result in a substantial
/// memory leak.
class ModificationDetectorPlugin extends PandoraMitmPlugin {
  final Map<String, PandoraMessageSet> _originalMessageSets = {};

  final _requestStageModifications =
      StreamController<PandoraMitmModificationRecordSet>.broadcast();
  final _responseStageModifications =
      StreamController<PandoraMitmModificationRecordSet>.broadcast();

  @override
  String get name => 'modification_detector';

  /// Modifications detected at a flow's request stage.
  Stream<PandoraMitmModificationRecordSet> get requestStageModifications =>
      _requestStageModifications.stream;

  /// Modifications detected at a flow's response stage.
  Stream<PandoraMitmModificationRecordSet> get responseStageModifications =>
      _responseStageModifications.stream;

  /// Modifications detected at any stage in a flow.
  Stream<PandoraMitmModificationRecordSet> get anyStageModifications async* {
    await for (final requestStageModificationRecordSet
        in requestStageModifications) {
      // Wait for the response stage to be observed.
      // This is guaranteed to happen after the request stage is observed, as
      // even unmodified stages still produce records.
      final flowId = requestStageModificationRecordSet.flowId;
      final responseStageModificationRecordSet =
          await responseStageModifications.firstWhere(
        (modificationRecordSet) => modificationRecordSet.flowId == flowId,
      );

      // Merge the two flow stage modification record sets and yield the result.
      // Original messages from the request stage will be used before messages
      // from the response stage.
      // If a message was modified in either the request or response stage, it
      // will be marked as modified in the merged record set.
      yield PandoraMitmModificationRecordSet(
        flowId,
        PandoraMitmModificationRecord(
          requestStageModificationRecordSet.apiRequest.original ??
              responseStageModificationRecordSet.apiRequest.original,
          wasModified:
              requestStageModificationRecordSet.apiRequest.wasModified ||
                  responseStageModificationRecordSet.apiRequest.wasModified,
        ),
        PandoraMitmModificationRecord(
          requestStageModificationRecordSet.response.original ??
              responseStageModificationRecordSet.response.original,
          wasModified: requestStageModificationRecordSet.response.wasModified ||
              responseStageModificationRecordSet.response.wasModified,
        ),
      );
    }
  }

  Future<PandoraMessageSet> _handleMessage<T>(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
    Sink<PandoraMitmModificationRecordSet> sink,
  ) async {
    final modificationRecordSet = _diffMessages(
      flowId,
      PandoraMessageSet(apiRequest: apiRequest, response: response),
    );
    if (modificationRecordSet != null) sink.add(modificationRecordSet);
    return PandoraMessageSet.preserve;
  }

  @override
  Future<PandoraMessageSet> handleRequest(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) =>
      _handleMessage(
        flowId,
        apiRequest,
        response,
        _requestStageModifications,
      );

  @override
  Future<PandoraMessageSet> handleResponse(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) =>
      _handleMessage(
        flowId,
        apiRequest,
        response,
        _responseStageModifications,
      );

  /// Checks differences between the messages in the [messageSet] and the
  /// original messages recorded at the beginning of the current flow stage.
  ///
  /// Returns a [PandoraMitmModificationRecordSet] describing the differences
  /// found, or `null` if the messages given are the initial messages to record.
  PandoraMitmModificationRecordSet? _diffMessages(
    String flowId,
    PandoraMessageSet messageSet,
  ) {
    if (_originalMessageSets.containsKey(flowId)) {
      final originalMessageSet = _originalMessageSets.remove(flowId)!;
      assert(
        originalMessageSet.apiRequest == null || messageSet.apiRequest != null,
        'The modified API request cannot be null if the original was not!',
      );
      assert(
        originalMessageSet.response == null || messageSet.response != null,
        "The response cannot be null if the original wasn't!",
      );
      return PandoraMitmModificationRecordSet(
        flowId,
        PandoraMitmModificationRecord(
          originalMessageSet.apiRequest,
          wasModified: messageSet.apiRequest != originalMessageSet.apiRequest,
        ),
        PandoraMitmModificationRecord(
          originalMessageSet.response,
          wasModified: messageSet.response != originalMessageSet.response,
        ),
      );
    } else {
      _originalMessageSets[flowId] = messageSet;
      return null;
    }
  }
}
