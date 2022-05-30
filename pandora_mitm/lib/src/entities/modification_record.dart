import 'package:pandora_mitm/src/entities/api_request.dart';
import 'package:pandora_mitm/src/entities/pandora_response.dart';

class PandoraMitmModificationRecord<T> {
  final T original;
  final bool wasModified;

  const PandoraMitmModificationRecord(
    this.original, {
    required this.wasModified,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PandoraMitmModificationRecord &&
          runtimeType == other.runtimeType &&
          original == other.original &&
          wasModified == other.wasModified;

  @override
  int get hashCode => Object.hash(
        original,
        wasModified,
      );
}

class PandoraMitmModificationRecordSet {
  final String flowId;
  final PandoraMitmModificationRecord<PandoraApiRequest?> apiRequest;
  final PandoraMitmModificationRecord<PandoraResponse?> response;

  const PandoraMitmModificationRecordSet(
    this.flowId,
    this.apiRequest,
    this.response,
  );

  bool get wasModified => apiRequest.wasModified || response.wasModified;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PandoraMitmModificationRecordSet &&
          runtimeType == other.runtimeType &&
          flowId == other.flowId &&
          apiRequest == other.apiRequest &&
          response == other.response;

  @override
  int get hashCode => Object.hash(
        flowId,
        apiRequest,
        response,
      );
}
