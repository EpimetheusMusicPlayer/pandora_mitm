import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pandora_mitm/src/entities/api_request.dart';
import 'package:pandora_mitm/src/entities/pandora_response.dart';

part 'pandora_message_set.freezed.dart';

/// A set of Pandora [apiRequest]s and [response]s.
@freezed
class PandoraMessageSet with _$PandoraMessageSet {
  const factory PandoraMessageSet({
    PandoraApiRequest? apiRequest,
    PandoraResponse? response,
  }) = _PandoraMessageSet;

  /// An empty [PandoraMessageSet].
  ///
  /// This can be used in scenarios where no messages should be modified.
  static const preserve = PandoraMessageSet();
}
