// ignore_for_file: avoid_void_async

import 'dart:async';
import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iapetus/iapetus_data.dart';
import 'package:iapetus_meta/typing.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/plugins/record.dart';

class InferenceBloc extends Cubit<InferenceState> {
  final ListRecorder<PandoraMitmRecord> _recorder;
  late final StreamSubscription<RecorderEvent<PandoraMitmRecord>>
      _recorderEventSubscription;

  InferenceBloc({
    required ListRecorder<PandoraMitmRecord> recorder,
  })  : _recorder = recorder,
        super(InferenceState.initial) {
    _recorderEventSubscription = _recorder.eventStream.listen((event) {
      late final apiMethodSelection =
          event.records.map((record) => record.apiRequest.method);
      final apiMethods = SplayTreeSet.of(state.apiMethods);
      var selectedApiMethod = state.selectedApiMethod;
      switch (event.type) {
        case RecorderEventType.add:
          apiMethods.addAll(apiMethodSelection);
          break;
        case RecorderEventType.remove:
          apiMethods.removeAll(apiMethodSelection);
          if (!apiMethods.contains(selectedApiMethod)) {
            selectedApiMethod = null;
          }
          break;
        case RecorderEventType.clear:
          apiMethods.clear();
          selectedApiMethod = null;
          break;
      }
      emit(
        InferenceState(
          apiMethods: UnmodifiableSetView(apiMethods),
          selectedApiMethod: selectedApiMethod,
          isRequestSelected: state.isRequestSelected,
          // Use the existing value type estimate if the selected API method hasn't changed.
          // There's no convenient way to tell if it needs to (or should be, from a UI perspective) be updated.
          // Manual refresh functionality is provided for this purpose.
          status: selectedApiMethod == state.selectedApiMethod
              ? state.status
              : InferenceStatus.idle,
          valueType: selectedApiMethod == state.selectedApiMethod
              ? state.valueType
              : null,
        ),
      );
    });
  }

  void _infer({
    required String apiMethod,
    required bool isRequestSelected,
  }) async {
    emit(
      InferenceState(
        apiMethods: state.apiMethods,
        selectedApiMethod: apiMethod,
        isRequestSelected: isRequestSelected,
        status: InferenceStatus.inferring,
        valueType: state.valueType,
      ),
    );

    final apiRecordSelection = _recorder.records
        .where((record) => record.apiRequest.method == apiMethod);
    final messageValueSelection = isRequestSelected
        ? apiRecordSelection.map((record) => record.apiRequest.body)
        : apiRecordSelection
            .map((record) => record.response?.apiResponse)
            .whereType<SuccessfulPandoraApiResponse>()
            .map((apiResponse) => apiResponse.result);
    final valueType = await compute(
      estimateValueTypes,
      messageValueSelection.toList(growable: false),
    );

    if (state.selectedApiMethod != apiMethod ||
        state.isRequestSelected != isRequestSelected) {
      // The computation has been invalidated, as the parameters have changed.
      return;
    }
    assert(
      state.status != InferenceStatus.idle,
      'A different inference task completed for $apiMethod! It should not have been started.',
    );
    emit(
      InferenceState(
        apiMethods: state.apiMethods,
        selectedApiMethod: apiMethod,
        isRequestSelected: isRequestSelected,
        status: InferenceStatus.idle,
        valueType: valueType,
      ),
    );
  }

  void refresh() {
    assert(state.selectedApiMethod != null, 'No API method is selected!');
    assert(state.status == InferenceStatus.idle, 'Already refreshing!');
    _infer(
      apiMethod: state.selectedApiMethod!,
      isRequestSelected: state.isRequestSelected,
    );
  }

  void update({
    String? apiMethod,
    bool? isRequestSelected,
  }) {
    assert(
      apiMethod != null || isRequestSelected != null,
      'At least one setting must be changed!',
    );
    apiMethod ??= state.selectedApiMethod;
    isRequestSelected ??= state.isRequestSelected;
    if (apiMethod == null) return;
    _infer(apiMethod: apiMethod, isRequestSelected: isRequestSelected);
  }

  @override
  Future<void> close() async {
    await _recorderEventSubscription.cancel();
    await super.close();
  }
}

enum InferenceStatus { idle, inferring }

class InferenceState extends Equatable {
  final Set<String> apiMethods;
  final String? selectedApiMethod;
  final bool isRequestSelected;
  final InferenceStatus status;

  /// May be `null` if the value type is still being calculated.
  final ValueType? valueType;

  const InferenceState({
    required this.apiMethods,
    required this.selectedApiMethod,
    required this.isRequestSelected,
    required this.status,
    this.valueType,
  });

  static const initial = InferenceState(
    apiMethods: {},
    selectedApiMethod: null,
    isRequestSelected: false,
    status: InferenceStatus.idle,
  );

  @override
  List<Object?> get props => [
        selectedApiMethod,
        apiMethods,
        selectedApiMethod,
        isRequestSelected,
        status,
        valueType,
      ];
}
