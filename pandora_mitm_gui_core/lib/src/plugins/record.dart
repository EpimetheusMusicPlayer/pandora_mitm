import 'dart:async';
import 'dart:collection';

import 'package:iapetus/iapetus.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/plugins/super_stream.dart';

class RecordPlugin extends SuperStreamPlugin {
  late final _Recorder<PandoraMitmRecord> _messageRecordRecorder;
  late final _MapEntryRecorder<String, MediaAnnotation> _annotationRecorder;
  late final _MapEntryRecorder<PandoraMitmRecord, Object?> _objectRecorder;

  RecordPlugin() {
    _messageRecordRecorder = _Recorder(recordStream);
    _annotationRecorder = _MapEntryRecorder(mediaAnnotationStream);
    _objectRecorder = _MapEntryRecorder(objectStream);
  }

  List<PandoraMitmRecord> get messageRecords => _messageRecordRecorder.records;

  Stream<List<PandoraMitmRecord>> get messageRecordsStream =>
      _messageRecordRecorder.recordStream;

  Map<String, MediaAnnotation> get annotationMap => _annotationRecorder.records;

  Stream<Map<String, MediaAnnotation>> get annotationsStream =>
      _annotationRecorder.recordStream;

  Map<PandoraMitmRecord, Object?> get objectMap => _objectRecorder.records;

  Stream<Map<PandoraMitmRecord, Object?>> get objectsStream =>
      _objectRecorder.recordStream;
}

class _Recorder<T> {
  final _records = <T>[];
  final _recordStreamController = StreamController<List<T>>.broadcast();

  List<T> get records => UnmodifiableListView(_records);

  Stream<List<T>> get recordStream => _recordStreamController.stream;

  _Recorder(Stream<T> source) {
    _recordStreamController.addStream(
      source.map((record) => List.of(_records..add(record))),
    );
  }
}

class _MapEntryRecorder<K, V> {
  final _records = <K, V>{};
  final _recordStreamController = StreamController<Map<K, V>>.broadcast();

  Map<K, V> get records => UnmodifiableMapView(_records);

  Stream<Map<K, V>> get recordStream => _recordStreamController.stream;

  _MapEntryRecorder(Stream<MapEntry<K, V>> source) {
    _recordStreamController.addStream(
      source.map((entry) => Map.of(_records..[entry.key] = entry.value)),
    );
  }
}
