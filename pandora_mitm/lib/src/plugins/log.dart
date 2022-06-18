import 'dart:async';
import 'dart:io';

import 'package:pandora_mitm/plugin_dev.dart';

/// A [PandoraMitm] plugin that logs API request and response information.
///
/// To stream entire API requests and responses, consider [StreamPlugin]
/// instead.
class LogPlugin extends PandoraMitmPlugin {
  final FutureOr<void> Function(
    String flowId,
    String method, {
    required bool response,
  }) log;

  const LogPlugin([this.log = _defaultLogAction]);

  @override
  Future<MessageSetSettings> getRequestSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary? responseSummary,
  ) async {
    await log(flowId, apiMethod, response: false);
    return MessageSetSettings.skip;
  }

  @override
  Future<MessageSetSettings> getResponseSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary responseSummary,
  ) async {
    await log(flowId, apiMethod, response: true);
    return MessageSetSettings.skip;
  }

  static void _defaultLogAction(
    String flowId,
    String method, {
    required bool response,
  }) =>
      stdout.writeln('[$flowId] API: ${response ? 'RCV' : 'SND'}: $method');
}
