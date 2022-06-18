import 'package:iapetus/iapetus_data.dart';
import 'package:pandora_mitm/plugin_dev.dart';

/// A [PandoraMitmPlugin] that forces Pandora clients to reauthenticate by
/// simulating an expired authentication token error.
///
/// By default, each client will only be reauthenticated once.
/// This can be reset, though - see [invalidate] for more details.
class ReauthenticationPlugin extends PandoraMitmPlugin
    with PandoraMitmPluginLogging {
  final _reauthenticatedClients = <String>{};

  @override
  String get logTag => 'reauthentication';

  /// Triggers a reauthentication on the next authorised API request.
  void invalidate() => _reauthenticatedClients.clear();

  @override
  MessageSetSettings getRequestSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary? responseSummary,
  ) =>
      _apiMethodIsAuthenticated(apiMethod)
          ? MessageSetSettings.includeRequestOnly
          : MessageSetSettings.skip;

  @override
  PandoraMessageSet handleRequest(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) {
    if (apiRequest?.authToken == null ||
        apiRequest!.deviceId == null ||
        // For some reason, the Pandora client sometimes calls even methods like
        // auth.userLogin with an existing authentication token.
        // A manual blacklist must be employed to prevent breaking the
        // authentication flow.
        !_apiMethodIsAuthenticated(apiRequest.method) ||
        _reauthenticatedClients.contains(apiRequest.deviceId)) {
      return PandoraMessageSet.preserve;
    } else {
      _reauthenticatedClients.add(apiRequest.deviceId!);
      log.info(
        'Re-authenticating client with device ID ${apiRequest.deviceId}.',
      );
      return const PandoraMessageSet(
        response: PandoraResponse(
          apiResponse: PandoraApiResponse.fail(
            code: PandoraApiErrorCode.invalidAuthToken,
            message: 'An unexpected error occurred',
          ),
        ),
      );
    }
  }

  static bool _apiMethodIsAuthenticated(String apiMethod) =>
      !(apiMethod.startsWith('auth.') ||
          apiMethod == 'user.associateDevice' ||
          apiMethod == 'user.disassociateDevice' ||
          apiMethod == 'user.createUser');
}
