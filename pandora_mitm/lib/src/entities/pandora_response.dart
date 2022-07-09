import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iapetus/iapetus_data.dart';

part 'pandora_response.freezed.dart';

/// A response from the Pandora JSON API server.
@freezed
class PandoraResponse with _$PandoraResponse {
  const factory PandoraResponse({
    @Default(200)
        int statusCode,
    String? reason,
    @Default({
      // Pandora evidently uses Envoy on their servers.
      'server': ['envoy'],

      // All API responses use a plaintext UTF-8 content type,
      // even if they're in decrypted JSON form.
      'content-type': ['text/plain;charset=utf-8'],
    })
        Map<String, List<String>> headers,
    @Default(false)
        bool encryptedBody,
    required PandoraApiResponse apiResponse,
  }) = _PandoraResponse;
}

extension ResultModification on SuccessfulPandoraApiResponse {
  /// Returns a new [SuccessfulPandoraApiResponse] with a new result containing
  /// the modified fields given in [modifiedFields].
  ///
  /// As Iapetus data structures do not always use every field given in an API
  /// response, fields may be lost in the process of deserialization,
  /// modification, and re-serialization.
  ///
  /// Using this method to modify API response results fixes this issue, as all
  /// fields not handled by Iapetus are copied from the original response to the
  /// new one.
  SuccessfulPandoraApiResponse copyWithModifiedResult(
    Map<String, dynamic> modifiedFields,
  ) =>
      copyWith(result: {...resultJson, ...modifiedFields});
}
