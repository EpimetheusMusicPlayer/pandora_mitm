import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:meta/meta.dart';
import 'package:mitmproxy_ri_client/mitmproxy_ri_client.dart' as mitm_ri;
import 'package:pandora_mitm/src/entities/api_request.dart';
import 'package:pandora_mitm/src/entities/pandora_message_set.dart';
import 'package:pandora_mitm/src/entities/pandora_response.dart';
import 'package:pandora_mitm/src/pandora_mitm.dart';
import 'package:pandora_mitm/src/pandora_mitm_plugin.dart';
import 'package:pandora_mitm/src/plugin_manager.dart';

class BackgroundPandoraMitmClient
    with PluginGroupPandoraMitmMixin
    implements PandoraMitm {
  late final ReceivePort _receivePort;
  late final SendPort _sendPort;

  final _disconnectionCompleter = Completer<void>();

  BackgroundPandoraMitmClient([Iterable<PandoraMitmPlugin>? plugins]) {
    if (plugins != null) pluginManager.addPlugins(plugins);
  }

  @override
  Future<void> get done => _disconnectionCompleter.future;

  @override
  Future<void> connect({String host = 'localhost', int port = 8082}) async {
    _receivePort = ReceivePort('BackgroundPandoraMitmClient');
    done.then((_) => _receivePort.close());

    final connectedCompleter = Completer<void>();
    _receivePort.listen((message) async {
      if (message is _RequestMessageSetSettingsServerMessage) {
        _sendPort.send(
          _MessageSetSettingsClientMessage(
            message.flowId,
            await getPluginRequestMessageSetSettings(
              message.flowId,
              message.apiMethod,
              message.requestSummary,
              message.responseSummary,
            ),
          ),
        );
      } else if (message is _ResponseMessageSetSettingsServerMessage) {
        _sendPort.send(
          _MessageSetSettingsClientMessage(
            message.flowId,
            await getPluginResponseMessageSetSettings(
              message.flowId,
              message.apiMethod,
              message.requestSummary,
              message.responseSummary,
            ),
          ),
        );
      } else if (message is _HandleRequestServerMessage) {
        _sendPort.send(
          _PandoraMessageSetClientMessage(
            message.flowId,
            await handlePluginRequest(
              message.flowId,
              message.originalApiRequest,
              message.originalResponse,
            ),
          ),
        );
      } else if (message is _HandleResponseServerMessage) {
        _sendPort.send(
          _PandoraMessageSetClientMessage(
            message.flowId,
            await handlePluginResponse(
              message.flowId,
              message.originalApiRequest,
              message.originalResponse,
            ),
          ),
        );
      } else if (message is _ConnectedServerMessage) {
        connectedCompleter.complete();
      } else if (message is _DisconnectedServerMessage) {
        _disconnectionCompleter.complete();
      } else if (message is SendPort) {
        (_sendPort = message).send(_ConnectClientMessage(host, port));
      } else if (message is _ExceptionServerMessage) {
        if (connectedCompleter.isCompleted) {
          Error.throwWithStackTrace(
            message.exception,
            message.stackTrace,
          );
        } else {
          connectedCompleter.completeError(
            message.exception,
            message.stackTrace,
          );
        }
      }
    });

    await Isolate.spawn(
      _BackgroundPandoraMitmServer.new,
      _receivePort.sendPort,
      debugName: 'BackgroundPandoraMitmServer isolate',
    );

    await connectedCompleter.future;
  }

  @override
  Future<void> disconnect() async =>
      _sendPort.send(const _DisconnectClientMessage());
}

class _BackgroundPandoraMitmServer extends PandoraMitm {
  final _receivePort = ReceivePort('BackgroundPandoraMitmServer');
  final SendPort _sendPort;

  final Map<String, Completer<mitm_ri.MessageSetSettings>>
      _messageSetSettingsCompleters = {};

  final Map<String, Completer<PandoraMessageSet>> _pandoraMessageSetCompleters =
      {};

  _BackgroundPandoraMitmServer(this._sendPort) {
    _sendPort.send(_receivePort.sendPort);

    done.then((_) {
      _sendPort.send(const _DisconnectedServerMessage());
      _receivePort.close();
    });

    _receivePort.forEach((Object? message) async {
      if (message is _MessageSetSettingsClientMessage) {
        _messageSetSettingsCompleters
            .remove(message.flowId)!
            .complete(message.messageSetSettings);
      } else if (message is _PandoraMessageSetClientMessage) {
        _pandoraMessageSetCompleters
            .remove(message.flowId)!
            .complete(message.pandoraMessageSet);
      } else if (message is _ConnectClientMessage) {
        try {
          await connect(host: message.host, port: message.port);
        } on SocketException catch (e, s) {
          _sendPort.send(_ExceptionServerMessage(e, s));
        }
        _sendPort.send(const _ConnectedServerMessage());
      } else if (message is _DisconnectClientMessage) {
        disconnect();
      }
    });
  }

  @override
  PluginManager get pluginManager => throw UnsupportedError(
        'Plugins are not natively supported in the background PandoraMitm server!',
      );

  Future<T> _sendServerFlowMessage<T>(
    _PandoraMitmBackgroundServerFlowMessage serverMessage,
    Map<String, Completer<T>> completerMap,
  ) {
    final resultFuture =
        (completerMap[serverMessage.flowId] = Completer()).future;
    _sendPort.send(serverMessage);
    return resultFuture;
  }

  Future<mitm_ri.MessageSetSettings> _getPluginMessageSetSettings(
    _MessageSetSettingsServerMessage serverMessage,
  ) =>
      _sendServerFlowMessage(serverMessage, _messageSetSettingsCompleters);

  Future<PandoraMessageSet> _handlePluginMessage(
    _HandleMessageServerMessage serverMessage,
  ) =>
      _sendServerFlowMessage(serverMessage, _pandoraMessageSetCompleters);

  @protected
  @override
  Future<mitm_ri.MessageSetSettings> getPluginRequestMessageSetSettings(
    String flowId,
    String apiMethod,
    mitm_ri.RequestSummary requestSummary,
    mitm_ri.ResponseSummary? responseSummary,
  ) =>
      _getPluginMessageSetSettings(
        _RequestMessageSetSettingsServerMessage(
          flowId,
          apiMethod,
          requestSummary,
          responseSummary,
        ),
      );

  @protected
  @override
  Future<mitm_ri.MessageSetSettings> getPluginResponseMessageSetSettings(
    String flowId,
    String apiMethod,
    mitm_ri.RequestSummary requestSummary,
    mitm_ri.ResponseSummary responseSummary,
  ) =>
      _getPluginMessageSetSettings(
        _ResponseMessageSetSettingsServerMessage(
          flowId,
          apiMethod,
          requestSummary,
          responseSummary,
        ),
      );

  @protected
  @override
  Future<PandoraMessageSet> handlePluginRequest(
    String flowId,
    PandoraApiRequest? originalApiRequest,
    PandoraResponse? originalResponse,
  ) =>
      _handlePluginMessage(
        _HandleRequestServerMessage(
          flowId,
          originalApiRequest,
          originalResponse,
        ),
      );

  @protected
  @override
  Future<PandoraMessageSet> handlePluginResponse(
    String flowId,
    PandoraApiRequest? originalApiRequest,
    PandoraResponse? originalResponse,
  ) =>
      _handlePluginMessage(
        _HandleResponseServerMessage(
          flowId,
          originalApiRequest,
          originalResponse,
        ),
      );
}

abstract class _PandoraMitmBackgroundClientMessage {
  const _PandoraMitmBackgroundClientMessage();
}

class _ConnectClientMessage implements _PandoraMitmBackgroundClientMessage {
  final String host;
  final int port;

  const _ConnectClientMessage(this.host, this.port);
}

class _DisconnectClientMessage implements _PandoraMitmBackgroundClientMessage {
  const _DisconnectClientMessage();
}

class _MessageSetSettingsClientMessage
    implements _PandoraMitmBackgroundClientMessage {
  final String flowId;
  final mitm_ri.MessageSetSettings messageSetSettings;

  const _MessageSetSettingsClientMessage(this.flowId, this.messageSetSettings);
}

class _PandoraMessageSetClientMessage
    implements _PandoraMitmBackgroundClientMessage {
  final String flowId;
  final PandoraMessageSet pandoraMessageSet;

  const _PandoraMessageSetClientMessage(this.flowId, this.pandoraMessageSet);
}

abstract class _PandoraMitmBackgroundServerMessage {
  const _PandoraMitmBackgroundServerMessage();
}

class _ConnectedServerMessage implements _PandoraMitmBackgroundServerMessage {
  const _ConnectedServerMessage();
}

class _DisconnectedServerMessage
    implements _PandoraMitmBackgroundServerMessage {
  const _DisconnectedServerMessage();
}

abstract class _PandoraMitmBackgroundServerFlowMessage
    implements _PandoraMitmBackgroundServerMessage {
  String get flowId;
}

abstract class _MessageSetSettingsServerMessage
    implements _PandoraMitmBackgroundServerFlowMessage {
  String get apiMethod;

  mitm_ri.RequestSummary get requestSummary;

  mitm_ri.ResponseSummary? get responseSummary;

  const _MessageSetSettingsServerMessage();
}

class _RequestMessageSetSettingsServerMessage
    extends _MessageSetSettingsServerMessage {
  @override
  final String flowId;

  @override
  final String apiMethod;

  @override
  final mitm_ri.RequestSummary requestSummary;

  @override
  final mitm_ri.ResponseSummary? responseSummary;

  const _RequestMessageSetSettingsServerMessage(
    this.flowId,
    this.apiMethod,
    this.requestSummary,
    this.responseSummary,
  );
}

class _ResponseMessageSetSettingsServerMessage
    implements _MessageSetSettingsServerMessage {
  @override
  final String flowId;

  @override
  final String apiMethod;

  @override
  final mitm_ri.RequestSummary requestSummary;

  @override
  final mitm_ri.ResponseSummary responseSummary;

  const _ResponseMessageSetSettingsServerMessage(
    this.flowId,
    this.apiMethod,
    this.requestSummary,
    this.responseSummary,
  );
}

abstract class _HandleMessageServerMessage
    implements _PandoraMitmBackgroundServerFlowMessage {
  PandoraApiRequest? get originalApiRequest;

  PandoraResponse? get originalResponse;

  const _HandleMessageServerMessage();
}

class _HandleRequestServerMessage implements _HandleMessageServerMessage {
  @override
  final String flowId;

  @override
  final PandoraApiRequest? originalApiRequest;

  @override
  final PandoraResponse? originalResponse;

  const _HandleRequestServerMessage(
    this.flowId,
    this.originalApiRequest,
    this.originalResponse,
  );
}

class _HandleResponseServerMessage implements _HandleMessageServerMessage {
  @override
  final String flowId;

  @override
  final PandoraApiRequest? originalApiRequest;

  @override
  final PandoraResponse? originalResponse;

  const _HandleResponseServerMessage(
    this.flowId,
    this.originalApiRequest,
    this.originalResponse,
  );
}

class _ExceptionServerMessage implements _PandoraMitmBackgroundServerMessage {
  final Exception exception;
  final StackTrace stackTrace;

  const _ExceptionServerMessage(this.exception, this.stackTrace);
}
