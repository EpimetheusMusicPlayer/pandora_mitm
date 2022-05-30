import 'package:iapetus/iapetus_data.dart';
import 'package:pandora_mitm/plugin_dev.dart';

/// A [PandoraMitmPlugin] that forces Pandora clients to reauthenticate by
/// simulating an expired authentication token error.
///
/// This plugin only works properly with one Pandora client at a time - if more
/// than one client is using the proxy, only the first client to make an
/// authorised request after [invalidate] has been called will be forced to
/// reauthenticate.
class ReauthenticationPlugin extends PandoraMitmPlugin {
  bool _shouldReauthenticate;

  /// Creates a [ReauthenticationPlugin] instance.
  ///
  /// Setting [startInvalid] to true (the default) is equivalent to calling
  /// [invalidate].
  ReauthenticationPlugin({
    bool startInvalid = true,
  }) : _shouldReauthenticate = startInvalid;

  /// Triggers a reauthentication on the next authorised API request.
  void invalidate() => _shouldReauthenticate = true;

  @override
  MessageSetSettings getRequestSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary? responseSummary,
  ) =>
      (!_shouldReauthenticate || !_apiMethodIsAuthenticated(apiMethod))
          ? MessageSetSettings.skip
          : MessageSetSettings.includeRequestOnly;

  @override
  PandoraMessageSet handleRequest(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) {
    if (!_shouldReauthenticate ||
        apiRequest?.authToken == null ||
        // For some reason, the Pandora client sometimes call even methods like
        // auth.userLogin with an authentication token.
        // A manual blacklist must be employed.
        !_apiMethodIsAuthenticated(apiRequest!.method)) {
      return PandoraMessageSet.preserve;
    } else {
      _shouldReauthenticate = false;
      return const PandoraMessageSet(
        response: PandoraResponse(
          apiResponse: PandoraApiResponse.fail(
            code: PandoraApiErrorCodes.invalidAuthToken,
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
