import 'dart:async';
import 'dart:isolate';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:pandora_mitm/plugin_dev.dart';

typedef BackgroundPluginIsolateEntrypoint<T, P extends PandoraMitmPlugin> = void
    Function(BackgroundPluginInitialPayload<T, P> payload);

typedef BackgroundPluginPluginFactory<T, P extends PandoraMitmPlugin> = P
    Function(T launchOptions);

abstract class BackgroundBasePlugin<T, P extends PandoraMitmPlugin>
    extends PandoraMitmPlugin {
  final _flowResponseStreamController =
      StreamController<_BackgroundPluginFlowResponse>.broadcast();
  late Future<SendPort> _sendPortFuture;

  @protected
  BackgroundPluginIsolateEntrypoint<T, P> get isolateEntrypoint;

  T get launchOptions;

  @protected
  BackgroundPluginPluginFactory<T, P> get pluginFactory;

  @override
  Future<void> attach() async {
    await super.attach();
    final sendPortCompleter = Completer<SendPort>();
    _sendPortFuture = sendPortCompleter.future;
    final receivePort = ReceivePort();
    receivePort.listen((message) {
      if (message is _InternalBackgroundPluginResponse) {
        if (message is _BackgroundPluginFlowResponse) {
          _flowResponseStreamController.add(message);
        } else if (message is _BackgroundPluginLogResponse) {
          message.log();
        } else if (message is _BackgroundPluginStoppedResponse) {
          receivePort.close();
        }
      } else if (message is SendPort) {
        sendPortCompleter.complete(message);
      }
    });
    Isolate.spawn(
      isolateEntrypoint,
      BackgroundPluginInitialPayload(
        sendPort: receivePort.sendPort,
        launchOptions: launchOptions,
        pluginFactory: pluginFactory,
      ),
    );
    await _sendPortFuture;
  }

  @override
  Future<void> detach() async {
    (await _sendPortFuture).send(const _BackgroundPluginStopRequest());
    await super.detach();
  }

  Future<R> _flow<R extends _BackgroundPluginFlowResponse>(
    _BackgroundPluginFlowRequest<R> request,
  ) async {
    (await _sendPortFuture).send(request);
    return await _flowResponseStreamController.stream
        .firstWhere((response) => response.flowId == request.flowId) as R;
  }

  @override
  Future<MessageSetSettings> getRequestSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary? responseSummary,
  ) =>
      _flow(
        _BackgroundPluginGetRequestSetSettingsRequest(
          flowId: flowId,
          apiMethod: apiMethod,
          requestSummary: requestSummary,
          responseSummary: responseSummary,
        ),
      ).then((result) => result.settings);

  @override
  Future<MessageSetSettings> getResponseSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary responseSummary,
  ) =>
      _flow(
        _BackgroundPluginGetResponseSetSettingsRequest(
          flowId: flowId,
          apiMethod: apiMethod,
          requestSummary: requestSummary,
          responseSummary: responseSummary,
        ),
      ).then((result) => result.settings);

  @override
  Future<PandoraMessageSet> handleRequest(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) =>
      _flow(
        _BackgroundPluginHandleRequestRequest(
          flowId: flowId,
          apiRequest: apiRequest,
          response: response,
        ),
      ).then((result) => result.messageSet);

  @override
  Future<PandoraMessageSet> handleResponse(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) =>
      _flow(
        _BackgroundPluginHandleResponseRequest(
          flowId: flowId,
          apiRequest: apiRequest,
          response: response,
        ),
      ).then((result) => result.messageSet);
}

abstract class BackgroundPluginHost<T, P extends PandoraMitmPlugin>
    extends PandoraMitmPlugin {
  final SendPort _sendPort;

  final P plugin;

  BackgroundPluginHost(BackgroundPluginInitialPayload<T, P> payload)
      : _sendPort = payload.sendPort,
        plugin = payload.buildPlugin() {
    _init();
  }

  Future<void> _init() async {
    final logSubscription = Logger.root.onRecord.listen(
      (record) =>
          _sendPort.send(_BackgroundPluginLogResponse.fromLogRecord(record)),
    );

    await plugin.attach();

    final receivePort = ReceivePort();
    receivePort.forEach((Object? message) async {
      if (message is _InternalBackgroundPluginRequest) {
        if (message is _BackgroundPluginGetRequestSetSettingsRequest) {
          final messageSetSettings = await plugin.getRequestSetSettings(
            message.flowId,
            message.apiMethod,
            message.requestSummary,
            message.responseSummary,
          );
          _sendPort.send(
            _BackgroundPluginGetRequestSetSettingsResponse(
              flowId: message.flowId,
              settings: messageSetSettings,
            ),
          );
        } else if (message is _BackgroundPluginGetResponseSetSettingsRequest) {
          final messageSetSettings = await plugin.getResponseSetSettings(
            message.flowId,
            message.apiMethod,
            message.requestSummary,
            message.responseSummary,
          );
          _sendPort.send(
            _BackgroundPluginGetResponseSetSettingsResponse(
              flowId: message.flowId,
              settings: messageSetSettings,
            ),
          );
        } else if (message is _BackgroundPluginHandleRequestRequest) {
          final messageSet = await plugin.handleRequest(
            message.flowId,
            message.apiRequest,
            message.response,
          );
          _sendPort.send(
            _BackgroundPluginHandleRequestResponse(
              flowId: message.flowId,
              messageSet: messageSet,
            ),
          );
        } else if (message is _BackgroundPluginHandleResponseRequest) {
          final messageSet = await plugin.handleResponse(
            message.flowId,
            message.apiRequest,
            message.response,
          );
          _sendPort.send(
            _BackgroundPluginHandleResponseResponse(
              flowId: message.flowId,
              messageSet: messageSet,
            ),
          );
        } else if (message is _BackgroundPluginStopRequest) {
          await plugin.detach();
          await logSubscription.cancel();
          receivePort.close();
          _sendPort.send(const _BackgroundPluginStoppedResponse());
        }
      }
    });

    _sendPort.send(receivePort.sendPort);
  }
}

typedef ForegroundBuildingBackgroundPluginIsolateEntrypoint<
        P extends PandoraMitmPlugin>
    = BackgroundPluginIsolateEntrypoint<P, P>;

/// Many [PandoraMitmPlugin]s can be sent through a [SendPort].
///
/// This [BackgroundBasePlugin] implementation constructs the plugin in the main
/// isolate, negating the need for [launchOptions].
///
/// See also:
///
/// * [ForegroundBuildingBackgroundPluginHost], the corresponding
///   [BackgroundPluginHost].
abstract class ForegroundBuildingBackgroundBasePlugin<
    P extends PandoraMitmPlugin> extends BackgroundBasePlugin<P, P> {
  @override
  ForegroundBuildingBackgroundPluginIsolateEntrypoint<P> get isolateEntrypoint;

  P buildPlugin();

  @override
  P get launchOptions => buildPlugin();

  @override
  BackgroundPluginPluginFactory<P, P> get pluginFactory =>
      _identityPluginFactory<P>;

  static P _identityPluginFactory<P extends PandoraMitmPlugin>(
    P launchOptions,
  ) =>
      launchOptions;
}

/// A [BackgroundPluginHost] implementation to be used with
/// [ForegroundBuildingBackgroundBasePlugin].
abstract class ForegroundBuildingBackgroundPluginHost<
    P extends PandoraMitmPlugin> extends BackgroundPluginHost<P, P> {
  ForegroundBuildingBackgroundPluginHost(super.payload);
}

class BackgroundPluginInitialPayload<T, P extends PandoraMitmPlugin> {
  final SendPort sendPort;
  final T _launchOptions;
  final BackgroundPluginPluginFactory<T, P> _pluginFactory;

  const BackgroundPluginInitialPayload({
    required this.sendPort,
    required T launchOptions,
    required P Function(T launchOptions) pluginFactory,
  })  : _launchOptions = launchOptions,
        _pluginFactory = pluginFactory;

  P buildPlugin() => _pluginFactory(_launchOptions);
}

abstract class _InternalBackgroundPluginRequest {}

abstract class _InternalBackgroundPluginResponse {}

abstract class _BackgroundPluginFlowMessage {
  String get flowId;
}

abstract class _BackgroundPluginFlowRequest<
        T extends _BackgroundPluginFlowResponse>
    implements _BackgroundPluginFlowMessage, _InternalBackgroundPluginRequest {}

abstract class _BackgroundPluginFlowResponse
    implements
        _BackgroundPluginFlowMessage,
        _InternalBackgroundPluginResponse {}

class _BackgroundPluginStopRequest implements _InternalBackgroundPluginRequest {
  const _BackgroundPluginStopRequest();
}

class _BackgroundPluginStoppedResponse
    implements _InternalBackgroundPluginResponse {
  const _BackgroundPluginStoppedResponse();
}

class _BackgroundPluginLogResponse
    implements _InternalBackgroundPluginResponse {
  final String loggerName;
  final Level level;
  final String message;
  final String? errorString;
  final StackTrace? stackTrace;

  const _BackgroundPluginLogResponse({
    required this.loggerName,
    required this.level,
    required this.message,
    required this.errorString,
    required this.stackTrace,
  });

  _BackgroundPluginLogResponse.fromLogRecord(LogRecord record)
      : this(
          loggerName: record.loggerName,
          level: record.level,
          message: record.message,
          errorString: record.error?.toString(),
          stackTrace: record.stackTrace,
        );

  void log() => Logger(loggerName).log(level, message, errorString, stackTrace);
}

class _BackgroundPluginGetRequestSetSettingsRequest
    implements
        _BackgroundPluginFlowRequest<
            _BackgroundPluginGetRequestSetSettingsResponse> {
  @override
  final String flowId;
  final String apiMethod;
  final RequestSummary requestSummary;
  final ResponseSummary? responseSummary;

  const _BackgroundPluginGetRequestSetSettingsRequest({
    required this.flowId,
    required this.apiMethod,
    required this.requestSummary,
    required this.responseSummary,
  });
}

class _BackgroundPluginGetRequestSetSettingsResponse
    implements _BackgroundPluginFlowResponse {
  @override
  final String flowId;
  final MessageSetSettings settings;

  const _BackgroundPluginGetRequestSetSettingsResponse({
    required this.flowId,
    required this.settings,
  });
}

class _BackgroundPluginGetResponseSetSettingsRequest
    implements
        _BackgroundPluginFlowRequest<
            _BackgroundPluginGetResponseSetSettingsResponse> {
  @override
  final String flowId;
  final String apiMethod;
  final RequestSummary requestSummary;
  final ResponseSummary responseSummary;

  const _BackgroundPluginGetResponseSetSettingsRequest({
    required this.flowId,
    required this.apiMethod,
    required this.requestSummary,
    required this.responseSummary,
  });
}

class _BackgroundPluginGetResponseSetSettingsResponse
    implements _BackgroundPluginFlowResponse {
  @override
  final String flowId;
  final MessageSetSettings settings;

  const _BackgroundPluginGetResponseSetSettingsResponse({
    required this.flowId,
    required this.settings,
  });
}

class _BackgroundPluginHandleRequestRequest
    implements
        _BackgroundPluginFlowRequest<_BackgroundPluginHandleRequestResponse> {
  @override
  final String flowId;
  final PandoraApiRequest? apiRequest;
  final PandoraResponse? response;

  const _BackgroundPluginHandleRequestRequest({
    required this.flowId,
    required this.apiRequest,
    required this.response,
  });
}

class _BackgroundPluginHandleRequestResponse
    implements _BackgroundPluginFlowResponse {
  @override
  final String flowId;
  final PandoraMessageSet messageSet;

  const _BackgroundPluginHandleRequestResponse({
    required this.flowId,
    required this.messageSet,
  });
}

class _BackgroundPluginHandleResponseRequest
    implements
        _BackgroundPluginFlowRequest<_BackgroundPluginHandleResponseResponse> {
  @override
  final String flowId;
  final PandoraApiRequest? apiRequest;
  final PandoraResponse? response;

  const _BackgroundPluginHandleResponseRequest({
    required this.flowId,
    required this.apiRequest,
    required this.response,
  });
}

class _BackgroundPluginHandleResponseResponse
    implements _BackgroundPluginFlowResponse {
  @override
  final String flowId;
  final PandoraMessageSet messageSet;

  const _BackgroundPluginHandleResponseResponse({
    required this.flowId,
    required this.messageSet,
  });
}
