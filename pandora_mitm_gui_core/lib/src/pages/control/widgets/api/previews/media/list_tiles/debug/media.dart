import 'package:flutter/material.dart';
import 'package:iapetus/iapetus.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/previews/media/list_tiles/debug/artist.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/previews/media/list_tiles/debug/track.dart';

class DebugMediaListTile extends StatelessWidget {
  final MediaAnnotation annotation;

  const DebugMediaListTile(this.annotation, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return annotation.map(
      track: DebugTrackListTile.new,
      artist: DebugArtistListTile.new,
      album: (_) => SizedBox(
        height: 92,
        child: Center(child: Text(annotation.pandoraId)),
      ),
      genre: (_) => SizedBox(
        height: 92,
        child: Center(child: Text(annotation.pandoraId)),
      ),
      playlist: (_) => SizedBox(
        height: 92,
        child: Center(child: Text(annotation.pandoraId)),
      ),
      composer: (_) => SizedBox(
        height: 92,
        child: Center(child: Text(annotation.pandoraId)),
      ),
      listener: (_) => SizedBox(
        height: 92,
        child: Center(child: Text(annotation.pandoraId)),
      ),
    );
  }
}
