import 'package:flutter/material.dart';
import 'package:iapetus/iapetus.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/previews/media/list_tiles/debug/container.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/previews/media/list_tiles/track.dart';

class DebugTrackListTile extends StatelessWidget {
  final TrackAnnotation annotation;

  const DebugTrackListTile(this.annotation, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DebugMediaListTileContainer(
      mediaListTile: TrackListTile(annotation),
      id: annotation.pandoraId,
      secondaryIds: [annotation.artistId, annotation.albumId],
    );
  }
}
