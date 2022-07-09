import 'dart:async';
import 'dart:isolate';

import 'package:mitmproxy_ri_client/mitmproxy_ri_client.dart' as mitm_ri;
import 'package:pandora_mitm/src/pandora_mitm.dart';
import 'package:pandora_mitm/src/pandora_mitm_backend.dart';
import 'package:pandora_mitm/src/pandora_mitm_background.dart';
import 'package:pandora_mitm/src/pandora_mitm_handler.dart';
import 'package:pandora_mitm/src/pandora_mitm_logger.dart';
import 'package:pandora_mitm/src/pandora_mitm_raw_message_parser.dart';

class ForegroundMitmproxyRiPandoraMitm
    with
        PandoraMitmMitmproxyRiBackendMixin,
        PandoraMitmRawMessageParsingMixin,
        PandoraMitmPluginGroupMixin,
        PandoraMitmLoggingMixin
    implements PluginCapablePandoraMitm {}

class BackgroundMitmproxyRiPandoraMitm
    with
        PandoraMitmBackgroundMixin,
        PandoraMitmPluginGroupMixin,
        PandoraMitmLoggingMixin
    implements PluginCapablePandoraMitm {
  @override
  void Function(SendPort sendPort) get isolateEntrypoint =>
      MitmproxyRiPandoraMitmBackgroundIsolate.new;
}

class MitmproxyRiPandoraMitmBackgroundIsolate = PandoraMitmBackgroundIsolate
    with PandoraMitmMitmproxyRiBackendMixin, PandoraMitmRawMessageParsingMixin;

/// A [PandoraMitm] HTTP interception backend mixin that uses mitmproxy and the
/// mitmproxy Remote Interceptions addon.
///
/// This backend requires a raw message parser.
/// [PandoraMitmRawMessageParsingMixin] is the recommended message parsing
/// implementation.
mixin PandoraMitmMitmproxyRiBackendMixin
    implements PandoraMitmBackend, PandoraMitmRawMessageParser {
  late final mitm_ri.Client _mitmRiClient;
  final _disconnectionCompleter = Completer<void>();

  @override
  Future<void> get done => _disconnectionCompleter.future;

  @override
  Future<void> connect({
    String host = 'localhost',
    int port = 8082,
    void Function(Object error, StackTrace)? onError,
  }) async {
    _mitmRiClient = mitm_ri.Client.connect(
      host: host,
      port: port,
      onError: onError,
      getRequestSetSettings: getRawRequestSetSettings,
      getResponseSetSettings: getRawResponseSetSettings,
      handleRequest: handleRawRequest,
      handleResponse: handleRawResponse,
    )..done.then((_) => _disconnectionCompleter.complete());
  }

  @override
  Future<void> disconnect() async {
    await _mitmRiClient.disconnect();
  }
}
