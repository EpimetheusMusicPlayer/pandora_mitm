import 'dart:async';

import 'package:iapetus/iapetus.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/plugins/super_stream.dart';

class RecordPlugin extends SuperStreamPlugin {
  late final ListRecorder<PandoraMitmRecord> messageRecorder;
  late final MapEntryRecorder<String, MediaAnnotation> annotationRecorder;
  late final MapEntryRecorder<PandoraMitmRecord, Object?> objectRecorder;

  RecordPlugin({bool stripBoilerplate = false})
      : super(stripBoilerplate: stripBoilerplate) {
    messageRecorder = ListRecorder(recordStream);
    annotationRecorder = MapEntryRecorder(mediaAnnotationStream);
    objectRecorder = MapEntryRecorder(objectStream);
  }
}

enum RecorderEventType { add, remove, clear }

class RecorderEvent<T> {
  final RecorderEventType type;
  final List<T> records;

  const RecorderEvent(this.type, [this.records = const []]);
}

abstract class Recorder<T, C> {
  final void Function(C collection, T record) _addRecord;
  final void Function(C collection) _clearCollection;
  final C Function(C collection) _duplicateCollection;
  final C Function(C collection) _makeCollectionImmutable;

  final C _records;
  final _recordStreamController = StreamController<C>.broadcast();
  final _eventStreamController = StreamController<RecorderEvent<T>>.broadcast();

  Recorder(
    Stream<T> source, {
    required C Function() collectionFactory,
    required Function(C collection, T record) addRecord,
    required Function(C collection) clearCollection,
    required C Function(C collection) duplicateCollection,
    required C Function(C collection) makeCollectionImmutable,
  })  : _records = collectionFactory(),
        _addRecord = addRecord,
        _clearCollection = clearCollection,
        _duplicateCollection = duplicateCollection,
        _makeCollectionImmutable = makeCollectionImmutable {
    source.listen((record) {
      _addRecord(_records, record);
      _recordStreamController.add(_duplicateCollection(_records));
      _eventStreamController
          .add(RecorderEvent(RecorderEventType.add, [record]));
    });
  }

  C get records => _makeCollectionImmutable(_records);

  Stream<C> get recordsStream => _recordStreamController.stream;

  Stream<RecorderEvent<T>> get eventStream => _eventStreamController.stream;

  void clear() {
    _clearCollection(_records);
    _recordStreamController.add(_duplicateCollection(_records));
    _eventStreamController.add(const RecorderEvent(RecorderEventType.clear));
  }
}

class ListRecorder<T> extends Recorder<T, List<T>> {
  ListRecorder(Stream<T> source)
      : super(
          source,
          collectionFactory: () => [],
          addRecord: (records, record) => records.add(record),
          clearCollection: (records) => records.clear(),
          duplicateCollection: (records) => List.of(records, growable: false),
          makeCollectionImmutable: List.unmodifiable,
        );
}

class MapEntryRecorder<K, V> extends Recorder<MapEntry<K, V>, Map<K, V>> {
  MapEntryRecorder(Stream<MapEntry<K, V>> source)
      : super(
          source,
          collectionFactory: Map.new,
          addRecord: (records, record) => records[record.key] = record.value,
          clearCollection: (records) => records.clear(),
          duplicateCollection: (records) => Map.of(records),
          makeCollectionImmutable: Map.unmodifiable,
        );
}
