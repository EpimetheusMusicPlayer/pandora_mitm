import 'dart:async';

import 'package:iapetus/iapetus.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/plugins/super_stream.dart';

class RecordPlugin extends SuperStreamPlugin {
  late final _ListRecorder<PandoraMitmRecord> _messageRecordRecorder;
  late final _MapEntryRecorder<String, MediaAnnotation> _annotationRecorder;
  late final _MapEntryRecorder<PandoraMitmRecord, Object?> _objectRecorder;

  RecordPlugin({bool stripBoilerplate = false})
      : super(stripBoilerplate: stripBoilerplate) {
    _messageRecordRecorder = _ListRecorder(recordStream);
    _annotationRecorder = _MapEntryRecorder(mediaAnnotationStream);
    _objectRecorder = _MapEntryRecorder(objectStream);
  }

  List<PandoraMitmRecord> get messageRecords => _messageRecordRecorder.records;

  Stream<List<PandoraMitmRecord>> get messageRecordsStream =>
      _messageRecordRecorder.recordsStream;

  Map<String, MediaAnnotation> get annotationMap => _annotationRecorder.records;

  Stream<Map<String, MediaAnnotation>> get annotationsStream =>
      _annotationRecorder.recordsStream;

  Map<PandoraMitmRecord, Object?> get objectMap => _objectRecorder.records;

  Stream<Map<PandoraMitmRecord, Object?>> get objectsStream =>
      _objectRecorder.recordsStream;
}

abstract class _Recorder<T, C> {
  final void Function(C collection, T record) addRecord;
  final void Function(C collection) clearCollection;
  final C Function(C collection) duplicateCollection;
  final C Function(C collection) makeCollectionImmutable;

  final C _records;
  final _recordStreamController = StreamController<C>.broadcast();

  _Recorder(
    Stream<T> source, {
    required C Function() collectionFactory,
    required this.addRecord,
    required this.clearCollection,
    required this.duplicateCollection,
    required this.makeCollectionImmutable,
  }) : _records = collectionFactory() {
    _recordStreamController.addStream(
      source.map((record) {
        addRecord(_records, record);
        return duplicateCollection(_records);
      }),
    );
  }

  C get records => makeCollectionImmutable(_records);

  Stream<C> get recordsStream => _recordStreamController.stream;

  void clear() {
    clearCollection(_records);
    _recordStreamController.add(duplicateCollection(_records));
  }
}

class _ListRecorder<T> extends _Recorder<T, List<T>> {
  _ListRecorder(Stream<T> source)
      : super(
          source,
          collectionFactory: () => [],
          addRecord: (records, record) => records.add(record),
          clearCollection: (records) => records.clear(),
          duplicateCollection: (records) => List.of(records, growable: false),
          makeCollectionImmutable: List.unmodifiable,
        );
}

class _MapEntryRecorder<K, V> extends _Recorder<MapEntry<K, V>, Map<K, V>> {
  _MapEntryRecorder(Stream<MapEntry<K, V>> source)
      : super(
          source,
          collectionFactory: Map.new,
          addRecord: (records, record) => records[record.key] = record.value,
          clearCollection: (records) => records.clear(),
          duplicateCollection: (records) => Map.of(records),
          makeCollectionImmutable: Map.unmodifiable,
        );
}
