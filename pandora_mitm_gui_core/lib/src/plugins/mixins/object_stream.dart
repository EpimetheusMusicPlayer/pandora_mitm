import 'dart:async';

import 'package:iapetus/iapetus.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm/plugins.dart' as pmplg;

mixin ObjectStreamMixin on pmplg.StreamPlugin {
  late final Stream<MapEntry<PandoraMitmRecord, Object?>> objectStream =
      _createObjectStream();

  Stream<MapEntry<PandoraMitmRecord, Object?>> _createObjectStream() {
    final controller =
        StreamController<MapEntry<PandoraMitmRecord, Object?>>.broadcast();
    recordStream.forEach((record) async {
      final response = await record.responseFuture;
      response.apiResponse.map(
        ok: (apiResponse) {
          controller.add(
            MapEntry(
              record,
              _extractObject(record.apiRequest.method, apiResponse.result),
            ),
          );
        },
        fail: (error) => controller.add(MapEntry(record, error)),
      );
    });
    return controller.stream;
  }

  Object? _extractObject(String apiMethod, Object? response) {
    if (response is! Map<String, dynamic>) return null;
    switch (apiMethod) {
      case 'catalog.v4.annotateObjects':
      case 'playlists.v7.annotatePlaylists':
        return response.map(
          (pandoraId, annotationJson) => MapEntry(
            pandoraId,
            MediaAnnotation.fromJson(annotationJson as Map<String, dynamic>),
          ),
        );
      case 'catalog.v4.getDetails':
        return null;
      case 'contentservice.getcontent':
        return StationContentSet.fromJson(response);
      case 'station.getPlaylist':
        return (response['items'] as List<dynamic>)
            .cast<Map<String, dynamic>>()
            .map(
              (stationContentJson) =>
                  StationContent.fromJson(stationContentJson),
            )
            .toList(growable: false);
      case 'collections.v7.getItems':
        return CollectionListSegment.fromJson(response);
      case 'pods.v5.getAutoplaySongs':
        return SongRecommendationSet.fromJson(response);
      case 'playlists.v7.getTracks':
        return PlaylistSegment.fromJson(response);
      case 'onDemand.getAudioPlaybackInfo':
        return OnDemandMedia.fromJson(response);
      case 'feed.v1.getDirectory':
        return DirectoryResponse.fromJson(response);
      case 'user.getStationList':
        return StationList.fromJson(response);
      case 'auth.partnerLogin':
        return AuthenticatedPartner.fromJson(response);
      case 'auth.userLogin':
        return AuthenticatedUser.fromJson(response);
      case 'user.createUser':
        return AuthenticatedUser.fromJson(response);
      default:
        return null;
    }
  }
}
