import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_request.freezed.dart';

/// An API request (to be) sent to the Pandora JSON API server.
@freezed
class PandoraApiRequest with _$PandoraApiRequest {
  const factory PandoraApiRequest({
    int? partnerId,
    String? authToken,
    String? deviceId,
    required String method,
    @Default(false) bool encrypted,
    required Map<String, dynamic> body,
  }) = _PandoraApiRequest;
}
