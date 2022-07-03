import 'package:iapetus_meta/typing.dart';

abstract class ApiMethodInference {
  const ApiMethodInference();

  String get method;

  ValueType get requestValueType;

  ValueType get responseValueType;

  Iterable<NestedObjectValueTypeEntry> get requestValueTypeEntries;

  Iterable<NestedObjectValueTypeEntry> get responseValueTypeEntries;

  List<NestedObjectValueTypeEntry> get computedRequestValueTypeEntries =>
      requestValueTypeEntries.toList(growable: false);

  List<NestedObjectValueTypeEntry> get computedResponseValueTypeEntries =>
      responseValueTypeEntries.toList(growable: false);

  bool get unknownRequestValueType => requestValueType is UnknownValueType;

  bool get unknownResponseValueType => responseValueType is UnknownValueType;

  PrecomputedApiMethodInference precompute() => PrecomputedApiMethodInference(
        method: method,
        requestValueType: requestValueType,
        responseValueType: responseValueType,
      );

  Map<String, dynamic> toJson() => {
        'method': method,
        'requestTypes':
            unknownRequestValueType ? null : computedRequestValueTypeEntries,
        'responseTypes':
            unknownResponseValueType ? null : computedResponseValueTypeEntries,
      };
}

/// A lazy variant of [ApiMethodInference].
class LazyApiMethodInference extends ApiMethodInference {
  @override
  final String method;

  @override
  final ValueType requestValueType;

  @override
  final ValueType responseValueType;

  @override
  Iterable<NestedObjectValueTypeEntry> get requestValueTypeEntries =>
      requestValueType.flattenObjectTypes(method);

  @override
  Iterable<NestedObjectValueTypeEntry> get responseValueTypeEntries =>
      responseValueType.flattenObjectTypes(method);

  const LazyApiMethodInference({
    required this.method,
    required this.requestValueType,
    required this.responseValueType,
  });
}

/// A non-lazy variant of [ApiMethodInference].
class PrecomputedApiMethodInference extends ApiMethodInference {
  @override
  final String method;

  @override
  final ValueType requestValueType;

  @override
  final ValueType responseValueType;

  @override
  final List<NestedObjectValueTypeEntry> requestValueTypeEntries;

  @override
  final List<NestedObjectValueTypeEntry> responseValueTypeEntries;

  @override
  List<NestedObjectValueTypeEntry> get computedRequestValueTypeEntries =>
      requestValueTypeEntries;

  @override
  List<NestedObjectValueTypeEntry> get computedResponseValueTypeEntries =>
      responseValueTypeEntries;

  @override
  PrecomputedApiMethodInference precompute() => this;

  PrecomputedApiMethodInference({
    required this.method,
    required this.requestValueType,
    required this.responseValueType,
  })  : requestValueTypeEntries =
            requestValueType.flattenObjectTypes(method).toList(growable: false),
        responseValueTypeEntries = responseValueType
            .flattenObjectTypes(method)
            .toList(growable: false);
}
