import 'dart:async';

import 'package:iapetus/iapetus.dart';
import 'package:pandora_mitm/plugins.dart' as pmplg;

mixin AnnotationStreamMixin on pmplg.StreamPlugin {
  late final Stream<MapEntry<String, MediaAnnotation>> mediaAnnotationStream =
      _createMediaAnnotationStream();

  Stream<MapEntry<String, MediaAnnotation>> _createMediaAnnotationStream() {
    final controller =
        StreamController<MapEntry<String, MediaAnnotation>>.broadcast();
    recordStream.forEach((record) async {
      final response = await record.responseFuture;
      response.apiResponse.when(
        ok: (result) {
          if (result is! Map<String, dynamic>) return;
          _extractMediaAnnotations(record.apiRequest.method, result)
              .forEach(controller.add);
        },
        fail: (code, message) {},
      );
    });
    return controller.stream;
  }

  Iterable<MapEntry<String, MediaAnnotation>> _extractMediaAnnotations(
    String apiMethod,
    Map<String, dynamic> responseJson,
  ) sync* {
    switch (apiMethod) {
      case 'catalog.v4.annotateObjects':
      case 'playlists.v7.annotatePlaylists':
        yield* _parseAnnotationMap(responseJson);
        break;
      case 'catalog.v4.getDetails':
      case 'playlists.v7.getTracks':
      case 'pods.v5.getAutoplaySongs':
        // These API methods all respond with 'annotation' fields containing
        // the standard annotation map structure.
        yield* _parseAnnotationMap(
          responseJson['annotations'] as Map<String, dynamic>,
        );
        break;
      default:
        // If an 'annotations' field exists in a response for an unknown API
        // method, it probably contains the standard annotation map structure.
        // Cautiously try to parse it.
        if (responseJson.containsKey('annotations')) {
          final annotationMapJson = responseJson['annotations'];
          if (annotationMapJson is! Map<String, dynamic>) break;
          yield* _parseAnnotationMap(
            responseJson['annotations'] as Map<String, dynamic>,
            ignoreUnknownFormats: true,
          );
        }

      // case 'catalog.v4.getDetails':
      //   final MediaDetailsSet detailsSet;
      //   if (responseJson.containsKey('trackDetails')) {
      //     detailsSet = TrackDetailsSet.fromJson(responseJson);
      //   } else if (responseJson.containsKey('genreDetails')) {
      //     detailsSet = GenreDetailsSet.fromJson(responseJson);
      //   } else {
      //     break;
      //   }
      //   yield* detailsSet.annotations.entries;
      //   break;
      //
      // case 'pods.v5.getAutoplaySongs':
      //   yield* SongRecommendationSet.fromJson(responseJson).annotations.entries;
      //   break;
    }
  }

  Iterable<MapEntry<String, MediaAnnotation>> _parseAnnotationMap(
    Map<String, dynamic> annotationMapJson, {
    bool ignoreUnknownFormats = false,
  }) sync* {
    for (final entry in annotationMapJson.entries) {
      final pandoraId = entry.key;
      final annotationJson = entry.value;

      if (annotationJson is! Map<String, dynamic>) {
        if (ignoreUnknownFormats) {
          // If the annotation field isn't even a map, it's unlikely any in the
          // annotation map will be of the standard format. Abort.
          break;
        } else {
          throw FormatException('Unknown annotation format!', annotationJson);
        }
      }

      try {
        yield MapEntry(pandoraId, MediaAnnotation.fromJson(annotationJson));
      } catch (e) {
        if (ignoreUnknownFormats &&
            (e is FormatException || e is CheckedFromJsonException)) {
          if (e is CheckedFromJsonException) {
            print(e.map);
          }

          // If the annotation field isn't parsed correctly, it's likely just
          // a minor problem with a specific field that may not occur with the
          // remaining annotation objects. Skip to the next one.
          continue;
        } else {
          rethrow;
        }
      }
    }
  }
}
