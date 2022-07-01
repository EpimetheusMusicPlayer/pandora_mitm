import 'package:iapetus_meta/typing.dart';

abstract class ApiMethodInference {
  const ApiMethodInference();

  String get method;

  Iterable<NestedObjectValueTypeEntry>? get requestValueTypeEntries;

  Iterable<NestedObjectValueTypeEntry>? get responseValueTypeEntries;

  List<NestedObjectValueTypeEntry>? get computedRequestValueTypeEntries =>
      requestValueTypeEntries?.toList(growable: false);

  List<NestedObjectValueTypeEntry>? get computedResponseValueTypeEntries =>
      responseValueTypeEntries?.toList(growable: false);

  PrecomputedApiMethodInference precompute() => PrecomputedApiMethodInference(
        method,
        requestValueTypeEntries?.toList(growable: false),
        responseValueTypeEntries?.toList(growable: false),
      );

  Map<String, dynamic> toJson() => {
        'method': method,
        if (requestValueTypeEntries != null)
          'requestTypes': requestValueTypeEntries?.toList(growable: false),
        if (responseValueTypeEntries != null)
          'responseTypes': responseValueTypeEntries?.toList(growable: false),
      };
}

/// A lazy variant of [ApiMethodInference].
class LazyApiMethodInference extends ApiMethodInference {
  @override
  final String method;

  @override
  final Iterable<NestedObjectValueTypeEntry>? requestValueTypeEntries;

  @override
  final Iterable<NestedObjectValueTypeEntry>? responseValueTypeEntries;

  const LazyApiMethodInference(
    this.method,
    this.requestValueTypeEntries,
    this.responseValueTypeEntries,
  );
}

/// A non-lazy variant of [ApiMethodInference].
class PrecomputedApiMethodInference extends ApiMethodInference {
  @override
  final String method;

  @override
  final List<NestedObjectValueTypeEntry>? requestValueTypeEntries;

  @override
  final List<NestedObjectValueTypeEntry>? responseValueTypeEntries;

  @override
  List<NestedObjectValueTypeEntry>? get computedRequestValueTypeEntries =>
      requestValueTypeEntries;

  @override
  List<NestedObjectValueTypeEntry>? get computedResponseValueTypeEntries =>
      responseValueTypeEntries;

  @override
  PrecomputedApiMethodInference precompute() => this;

  const PrecomputedApiMethodInference(
    this.method,
    this.requestValueTypeEntries,
    this.responseValueTypeEntries,
  );
}
