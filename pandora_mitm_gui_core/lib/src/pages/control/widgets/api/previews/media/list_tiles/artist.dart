import 'package:flutter/material.dart';
import 'package:iapetus/iapetus.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/previews/media/list_tiles/generic/three_line.dart';

class ArtistListTile extends StatelessWidget {
  final ArtistAnnotation annotation;

  const ArtistListTile(this.annotation, {super.key});

  @override
  Widget build(BuildContext context) {
    return ThreeLineListTile(
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
        '${annotation.albumCount} album${annotation.albumCount == 1 ? '' : 's'}',
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
      line3: Text(
        '${annotation.trackCount} track${annotation.trackCount == 1 ? '' : 's'}',
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
