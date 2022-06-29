import 'dart:async';

import 'package:iapetus/iapetus_data.dart';
import 'package:meta/meta.dart';
import 'package:mitmproxy_ri_client/mitmproxy_ri_client.dart' as mitm_ri;
import 'package:pandora_mitm/src/encryption.dart';
import 'package:pandora_mitm/src/entities/api_request.dart';
import 'package:pandora_mitm/src/entities/pandora_message_set.dart';
import 'package:pandora_mitm/src/entities/pandora_response.dart';
import 'package:pandora_mitm/src/pandora_mitm.dart';
import 'package:pandora_mitm/src/pandora_mitm_handler.dart';

/// A [PandoraMitmRawMessageParser] receives raw HTTP messages and converts
/// them into Pandora API data structures, filtering out non-Pandora-API
/// messages in the process. It then calls the appropriate [PandoraMitmHandler]
/// methods at the relevant times.
///
/// Implementations of this class can do the heavy lifting between
/// [PandoraMitmBackend] and [PandoraMitmHandler] implementations.
///
/// See also:
///
/// * [PandoraMitmRawMessageParsingMixin], a useful implementation of this
///   class.
abstract class PandoraMitmRawMessageParser implements PandoraMitmHandler {
  const PandoraMitmRawMessageParser._();

  FutureOr<mitm_ri.MessageSetSettings> getRawRequestSetSettings(
    String flowId,
    mitm_ri.RequestSummary requestSummary,
    mitm_ri.ResponseSummary? responseSummary,
  );

  FutureOr<mitm_ri.MessageSetSettings> getRawResponseSetSettings(
    String flowId,
    mitm_ri.RequestSummary requestSummary,
    mitm_ri.ResponseSummary responseSummary,
  );

  Future<mitm_ri.MessageSet> handleRawRequest(
    String flowId,
    mitm_ri.CompleteRequest? request,
    mitm_ri.CompleteResponse? response,
  );

  Future<mitm_ri.MessageSet> handleRawResponse(
    String flowId,
    mitm_ri.CompleteRequest? request,
    mitm_ri.CompleteResponse? response,
  );
}

/// A mixin that processes raw HTTP messages and calls the relevant
/// [PandoraMitm] message handling functions.
mixin PandoraMitmRawMessageParsingMixin implements PandoraMitmRawMessageParser {
  final _encryptionManager = EncryptionManager();

  @override
  FutureOr<mitm_ri.MessageSetSettings> getRawRequestSetSettings(
    String flowId,
    mitm_ri.RequestSummary requestSummary,
    mitm_ri.ResponseSummary? responseSummary,
  ) =>
      _getMessageSetSettings(
        requestSummary,
        (apiMethod) => getRequestMessageSetSettings(
          flowId,
          apiMethod,
          requestSummary,
          responseSummary,
        ),
      );

  @override
  FutureOr<mitm_ri.MessageSetSettings> getRawResponseSetSettings(
    String flowId,
    mitm_ri.RequestSummary requestSummary,
    mitm_ri.ResponseSummary responseSummary,
  ) =>
      _getMessageSetSettings(
        requestSummary,
        (apiMethod) => getResponseMessageSetSettings(
          flowId,
          apiMethod,
          requestSummary,
          responseSummary,
        ),
      );

  @override
  Future<mitm_ri.MessageSet> handleRawRequest(
    String flowId,
    mitm_ri.CompleteRequest? request,
    mitm_ri.CompleteResponse? response,
  ) =>
      _handleMessage(
        request,
        response,
        (originalApiRequest, originalResponse) =>
            handleRequest(flowId, originalApiRequest, originalResponse),
      );

  @override
  Future<mitm_ri.MessageSet> handleRawResponse(
    String flowId,
    mitm_ri.CompleteRequest? request,
    mitm_ri.CompleteResponse? response,
  ) =>
      _handleMessage(
        request,
        response,
        (originalApiRequest, originalResponse) =>
            handleResponse(flowId, originalApiRequest, originalResponse),
      );

  @protected
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

  @protected
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
}
