import 'package:flutter/material.dart';
import 'package:iapetus/iapetus.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/previews/media/list_tiles/artist.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/previews/media/list_tiles/debug/container.dart';

class DebugArtistListTile extends StatelessWidget {
  final ArtistAnnotation annotation;

  const DebugArtistListTile(this.annotation, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DebugMediaListTileContainer(
      mediaListTile: ArtistListTile(annotation),
      id: annotation.pandoraId,
      secondaryIds: annotation.primaryArtistIds,
    );
  }
}
