import 'dart:async';

import 'package:iapetus/iapetus_data.dart';
import 'package:meta/meta.dart';
import 'package:mitmproxy_ri_client/mitmproxy_ri_client.dart' as mitm_ri;
import 'package:pandora_mitm/src/background_pandora_mitm.dart';
import 'package:pandora_mitm/src/encryption.dart';
import 'package:pandora_mitm/src/entities/api_request.dart';
import 'package:pandora_mitm/src/entities/pandora_message_set.dart';
import 'package:pandora_mitm/src/entities/pandora_response.dart';
import 'package:pandora_mitm/src/foreground_pandora_mitm.dart';
import 'package:pandora_mitm/src/pandora_mitm_plugin.dart';
import 'package:pandora_mitm/src/plugins/group.dart';

/// A mitmproxy Remote Interceptions client that can analyse and modify Pandora
/// JSON API messages.
///
/// The client can be started in either the main isolate with
/// [PandoraMitm.foreground], or a background isolate with
/// [PandoraMitm.background]. The latter is recommended in most cases,
/// especially if UIs are in use.
///
/// Analysis and modification behaviour is implemented through custom
/// [PandoraMitmPlugin] objects.
abstract class PandoraMitm {
  late final mitm_ri.Client _mitmRiClient;
  final _encryptionManager = EncryptionManager();
  final _disconnectionCompleter = Completer<void>();

  /// Create a new [PandoraMitm] instance, starting with the given [plugins].
  PandoraMitm([Iterable<PandoraMitmPlugin>? plugins]) {
    if (plugins != null) this.plugins.addAll(plugins);
  }

  /// Create a new [PandoraMitm], starting with the given [plugins], in the
  /// isolate that this constructor is called in.
  factory PandoraMitm.foreground([Iterable<PandoraMitmPlugin>? plugins]) =>
      ForegroundPandoraMitm(plugins);

  /// Create a new [PandoraMitm], starting with the given [plugins], in a new
  /// background isolate.
  ///
  /// Note that while the core code that handles message interception, parsing
  /// and decryption executes in the background isolate, plugins are still
  /// executed in the isolate that this constructor is called in.
  factory PandoraMitm.background([Iterable<PandoraMitmPlugin>? plugins]) =>
      BackgroundPandoraMitmClient(plugins);

  /// The list of plugins that are currently in use.
  ///
  /// This list can in theory be modified at any time, but note that many
  /// plugins expect to receive responses after requests. Removing them before
  /// they do so may cause memory leaks.
  List<PandoraMitmPlugin> get plugins;

  /// A [Future] that completes when the client disconnects from the mitmproxy
  /// Remote Interceptions server.
  Future<void> get done => _disconnectionCompleter.future;

  /// Connects to a mitmproxy Remote Interceptions server.
  ///
  /// This method can only be called once in the lifetime of a [PandoraMitm]
  /// object.
  ///
  /// The server [host] and [port] can be overwritten if need be - by default,
  /// they match the mitmproxy Remote Interceptions defaults.
  Future<void> connect({
    String host = 'localhost',
    int port = 8082,
  }) async {
    _mitmRiClient = await mitm_ri.Client.connect(
      host: host,
      port: port,
      getRequestSetSettings: _getRequestSetSettings,
      getResponseSetSettings: _getResponseSetSettings,
      handleRequest: _handleRequest,
      handleResponse: _handleResponse,
    )
      ..done.then((_) => _disconnectionCompleter.complete());
  }

  /// Disconnects from the mitmproxy Remote Interceptions server.
  Future<void> disconnect() async {
    await _mitmRiClient.disconnect();
  }

  @protected
  FutureOr<mitm_ri.MessageSetSettings> getPluginRequestMessageSetSettings(
    String flowId,
    String apiMethod,
    mitm_ri.RequestSummary requestSummary,
    mitm_ri.ResponseSummary? responseSummary,
  );

  @protected
  FutureOr<mitm_ri.MessageSetSettings> getPluginResponseMessageSetSettings(
    String flowId,
    String apiMethod,
    mitm_ri.RequestSummary requestSummary,
    mitm_ri.ResponseSummary responseSummary,
  );

  @protected
  FutureOr<PandoraMessageSet> handlePluginRequest(
    String flowId,
    PandoraApiRequest? originalApiRequest,
    PandoraResponse? originalResponse,
  );

  @protected
  FutureOr<PandoraMessageSet> handlePluginResponse(
    String flowId,
    PandoraApiRequest? originalApiRequest,
    PandoraResponse? originalResponse,
  );

  FutureOr<mitm_ri.MessageSetSettings> _getMessageSetSettings(
    mitm_ri.RequestSummary requestSummary,
    FutureOr<mitm_ri.MessageSetSettings> Function(String apiMethod)
        getWithApiMethod,
  ) {
    if (!(requestSummary.method == 'POST' &&
        requestSummary.url.host == partner.tunerHost &&
        requestSummary.url.path.startsWith('/services/json'))) {
      return mitm_ri.MessageSetSettings.skip;
    }

    final apiMethod = requestSummary.url.queryParameters['method'];
    if (apiMethod == null) return mitm_ri.MessageSetSettings.skip;

    return getWithApiMethod(apiMethod);
  }

  Future<mitm_ri.MessageSet> _handleMessage(
    mitm_ri.CompleteRequest? request,
    mitm_ri.CompleteResponse? response,
    FutureOr<PandoraMessageSet> Function(
      PandoraApiRequest? originalApiRequest,
      PandoraResponse? originalResponse,
    )
        handleWithPandoraMessages,
  ) async {
    late final PandoraApiRequest? originalApiRequest;
    late final bool originalRequestWasEncrypted;
    late final String? requestEncryptKey;
    late final Map<String, String> originalRequestQueryParameters;
    if (request == null) {
      originalApiRequest = null;
    } else {
      originalRequestQueryParameters = request.url.queryParameters;
      final partnerId = originalRequestQueryParameters.containsKey('partner_id')
          ? int.tryParse(originalRequestQueryParameters['partner_id']!)
          : null;
      final authToken = originalRequestQueryParameters['auth_token'];
      final method = originalRequestQueryParameters['method']!;

      final decryptedJson =
          _encryptionManager.decrypt(request.text!, request: true);
      if (decryptedJson == null) {
        throw FormatException(
          'Unknown encryption key encountered in API request!',
          request.text,
        );
      }
      originalRequestWasEncrypted = decryptedJson.wasEncrypted;
      requestEncryptKey = decryptedJson.key;
      final body = decryptedJson.json;

      originalApiRequest = PandoraApiRequest(
        partnerId: partnerId,
        authToken: authToken,
        method: method,
        deviceId: body['deviceId'] as String?,
        encrypted: originalRequestWasEncrypted,
        body: body,
      );
    }

    late final PandoraResponse? originalResponse;
    late final bool originalResponseWasEncrypted;
    late final String? responseEncryptKey;
    if (response == null) {
      originalResponse = null;
    } else {
      final decryptedJson =
          _encryptionManager.decrypt(response.text!, request: false);
      if (decryptedJson == null) {
        throw FormatException(
          'Unknown encryption key encountered in API response!',
          response.text,
        );
      }
      originalResponseWasEncrypted = decryptedJson.wasEncrypted;
      responseEncryptKey = decryptedJson.key;
      final body = decryptedJson.json;

      originalResponse = PandoraResponse(
        statusCode: response.statusCode,
        reason: response.reason,
        headers: response.headers,
        encryptedBody: originalResponseWasEncrypted,
        apiResponse: PandoraApiResponse.fromJson(body),
      );
    }

    final modifiedMessageSet =
        await handleWithPandoraMessages(originalApiRequest, originalResponse);
    final modifiedApiRequest = modifiedMessageSet.apiRequest;
    final modifiedResponse = modifiedMessageSet.response;

    // A null message should never be provided here unless the original message
    // was null.
    assert(modifiedApiRequest != null || originalApiRequest == null);
    assert(modifiedResponse != null || originalResponse == null);

    assert(
      modifiedApiRequest == null || request != null,
      'A custom request cannot be used if the original request has not been received!',
    );

    assert(
      modifiedApiRequest == null ||
          modifiedApiRequest.encrypted == false ||
          originalRequestWasEncrypted,
      'The original request was not encrypted. Encryption cannot be enabled!',
    );

    assert(
      modifiedResponse == null ||
          modifiedResponse.encryptedBody == false ||
          originalResponseWasEncrypted,
      'The original response was not encrypted. Encryption cannot be enabled!',
    );

    return mitm_ri.MessageSet(
      request: modifiedApiRequest == null
          ? null
          : request!.copyWithText(
              url: request.url.replace(
                queryParameters: {
                  ...originalRequestQueryParameters,
                  'partner_id': modifiedApiRequest.partnerId.toString(),
                  'auth_token': modifiedApiRequest.authToken,
                  'method': modifiedApiRequest.method,
                },
              ),
              _encryptionManager.encrypt(
                DecryptedJson(
                  modifiedApiRequest.body,
                  modifiedApiRequest.encrypted ? requestEncryptKey : null,
                ),
              ),
            ),
      response: modifiedResponse == null
          ? null
          : mitm_ri.CompleteResponse.withText(
              statusCode: modifiedResponse.statusCode,
              reason: modifiedResponse.reason,
              headers: modifiedResponse.headers,
              text: _encryptionManager.encrypt(
                DecryptedJson(
                  modifiedResponse.apiResponse.toJson(),
                  modifiedResponse.encryptedBody ? responseEncryptKey : null,
                ),
              ),
            ),
    );
  }

  FutureOr<mitm_ri.MessageSetSettings> _getRequestSetSettings(
    String flowId,
    mitm_ri.RequestSummary requestSummary,
    mitm_ri.ResponseSummary? responseSummary,
  ) =>
      _getMessageSetSettings(
        requestSummary,
        (apiMethod) => getPluginRequestMessageSetSettings(
          flowId,
          apiMethod,
          requestSummary,
          responseSummary,
        ),
      );

  FutureOr<mitm_ri.MessageSetSettings> _getResponseSetSettings(
    String flowId,
    mitm_ri.RequestSummary requestSummary,
    mitm_ri.ResponseSummary responseSummary,
  ) =>
      _getMessageSetSettings(
        requestSummary,
        (apiMethod) => getPluginResponseMessageSetSettings(
          flowId,
          apiMethod,
          requestSummary,
          responseSummary,
        ),
      );

  Future<mitm_ri.MessageSet> _handleRequest(
    String flowId,
    mitm_ri.CompleteRequest? request,
    mitm_ri.CompleteResponse? response,
  ) =>
      _handleMessage(
        request,
        response,
        (originalApiRequest, originalResponse) =>
            handlePluginRequest(flowId, originalApiRequest, originalResponse),
      );

  Future<mitm_ri.MessageSet> _handleResponse(
    String flowId,
    mitm_ri.CompleteRequest? request,
    mitm_ri.CompleteResponse? response,
  ) =>
      _handleMessage(
        request,
        response,
        (originalApiRequest, originalResponse) =>
            handlePluginResponse(flowId, originalApiRequest, originalResponse),
      );
}

/// A [PandoraMitm] mixin that provides support for multiple plugins via an
/// internal [PluginGroup] plugin.
mixin PluginGroupPandoraMitmMixin implements PandoraMitm {
  final _pluginGroup = PluginGroup();

  @override
  List<PandoraMitmPlugin> get plugins => _pluginGroup.plugins;

  @protected
  @override
  FutureOr<mitm_ri.MessageSetSettings> getPluginRequestMessageSetSettings(
    String flowId,
    String apiMethod,
    mitm_ri.RequestSummary requestSummary,
    mitm_ri.ResponseSummary? responseSummary,
  ) =>
      _pluginGroup.getRequestSetSettings(
        flowId,
        apiMethod,
        requestSummary,
        responseSummary,
      );

  @protected
  @override
  FutureOr<mitm_ri.MessageSetSettings> getPluginResponseMessageSetSettings(
    String flowId,
    String apiMethod,
    mitm_ri.RequestSummary requestSummary,
    mitm_ri.ResponseSummary responseSummary,
  ) =>
      _pluginGroup.getResponseSetSettings(
        flowId,
        apiMethod,
        requestSummary,
        responseSummary,
      );

  @protected
  @override
  FutureOr<PandoraMessageSet> handlePluginRequest(
    String flowId,
    PandoraApiRequest? originalApiRequest,
    PandoraResponse? originalResponse,
  ) =>
      _pluginGroup.handleRequest(
        flowId,
        originalApiRequest,
        originalResponse,
      );

  @protected
  @override
  FutureOr<PandoraMessageSet> handlePluginResponse(
    String flowId,
    PandoraApiRequest? originalApiRequest,
    PandoraResponse? originalResponse,
  ) =>
      _pluginGroup.handleResponse(
        flowId,
        originalApiRequest,
        originalResponse,
      );
}
