import 'package:flutter/material.dart';
import 'package:iapetus/iapetus.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/previews/media/list_tiles/generic/three_line.dart';

class TrackListTile extends StatelessWidget {
  final TrackAnnotation annotation;
  final VoidCallback? onPlay;

  const TrackListTile(
    this.annotation, {
    Key? key,
    this.onPlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThreeLineMediaListTile(
      artUrl: annotation.icon?.artUrl,
      line1: Text(
        annotation.name,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      line2: Text(
        annotation.artistName,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
      line3: Text(
        '${annotation.albumName} - Track ${annotation.trackNumber}',
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontStyle: FontStyle.italic,
        ),
      ),
      duration: annotation.duration,
      isExplicit: annotation.explicitness == Explicitness.explicit,
      onPlay: onPlay,
    );
  }
}
