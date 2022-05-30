import 'package:pandora_mitm/src/entities/api_request.dart';
import 'package:pandora_mitm/src/entities/pandora_response.dart';

/// A record of an API request and response.
class PandoraMitmRecord {
  final String flowId;
  final PandoraApiRequest apiRequest;
  final Future<PandoraResponse> responseFuture;

  const PandoraMitmRecord(
    this.flowId,
    this.apiRequest,
    this.responseFuture,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PandoraMitmRecord &&
          runtimeType == other.runtimeType &&
          flowId == other.flowId;

  @override
  int get hashCode => flowId.hashCode;
}
