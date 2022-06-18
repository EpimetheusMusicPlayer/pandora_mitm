import 'dart:async';

import 'package:iapetus/iapetus_data.dart';
import 'package:meta/meta.dart';
import 'package:pandora_mitm/plugin_dev.dart';

typedef ResponseModifier = FutureOr<PandoraApiResponse?> Function(
  PandoraApiRequest apiRequest,
  SuccessfulPandoraApiResponse apiResponse,
);

/// A [PandoraMitm] plugin base that modifies API responses for specific
/// endpoints.
///
/// To use this, extend this class, provide a set of [hookedEndpoints], and
/// implement the [getResponseModifierForEndpoint] function.
///
/// For example usage, consult the [FeatureUnlockPlugin] source code.
abstract class ResponseModificationBasePlugin extends PandoraMitmPlugin {
  const ResponseModificationBasePlugin();

  @protected
  Set<String> get hookedEndpoints;

  @protected
  ResponseModifier getResponseModifierForEndpoint(String endpoint);

  @override
  MessageSetSettings getResponseSetSettings(
    String flowId,
    String apiMethod,
    RequestSummary requestSummary,
    ResponseSummary responseSummary,
  ) =>
      hookedEndpoints.contains(apiMethod)
          ? MessageSetSettings.includeAll
          : MessageSetSettings.skip;

  @override
  Future<PandoraMessageSet> handleResponse(
    String flowId,
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  ) async {
    if (apiRequest == null ||
        response?.apiResponse is! SuccessfulPandoraApiResponse ||
        !hookedEndpoints.contains(apiRequest.method)) {
      return PandoraMessageSet.preserve;
    }

    final modifiedApiResponse =
        await getResponseModifierForEndpoint(apiRequest.method)(
      apiRequest,
      response!.apiResponse as SuccessfulPandoraApiResponse,
    );

    return modifiedApiResponse == null
        ? PandoraMessageSet.preserve
        : PandoraMessageSet(
            response: response.copyWith(apiResponse: modifiedApiResponse),
          );
  }
}
