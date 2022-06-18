import 'package:pandora_mitm/src/entities/api_request.dart';
import 'package:pandora_mitm/src/entities/pandora_response.dart';

/// A record of an API request and response.
class PandoraMitmRecord {
  final String flowId;
  final PandoraApiRequest apiRequest;
  final Future<PandoraResponse> responseFuture;

  late final PandoraResponse _response;
  var _completed = false;

  PandoraMitmRecord(
    this.flowId,
    this.apiRequest,
    this.responseFuture,
  ) {
    responseFuture.then((response) {
      _completed = true;
      _response = response;
    });
  }

  PandoraResponse? get response => _completed ? _response : null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PandoraMitmRecord &&
          runtimeType == other.runtimeType &&
          flowId == other.flowId;

  @override
  int get hashCode => flowId.hashCode;
}
