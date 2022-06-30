import 'package:iapetus_meta/typing.dart';

class ApiMethodInference {
  final String method;
  final Iterable<NestedObjectValueTypeEntry>? requestValueTypeEntries;
  final Iterable<NestedObjectValueTypeEntry>? responseValueTypeEntries;

  const ApiMethodInference(
    this.method,
    this.requestValueTypeEntries,
    this.responseValueTypeEntries,
  );

  Map<String, dynamic> toJson() => {
        'method': method,
        if (requestValueTypeEntries != null)
          'requestTypes': requestValueTypeEntries?.toList(growable: false),
        if (responseValueTypeEntries != null)
          'responseTypes': responseValueTypeEntries?.toList(growable: false),
      };
}
