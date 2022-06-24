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

abstract class Recorder<T, C> {
  final void Function(C collection, T record) addRecord;
  final void Function(C collection) clearCollection;
  final C Function(C collection) duplicateCollection;
  final C Function(C collection) makeCollectionImmutable;

  final C _records;
  final _recordStreamController = StreamController<C>.broadcast();

  Recorder(
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
