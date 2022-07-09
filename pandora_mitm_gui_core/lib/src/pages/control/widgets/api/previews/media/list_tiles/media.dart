import 'package:flutter/material.dart';
import 'package:iapetus/iapetus.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/previews/media/list_tiles/artist.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/previews/media/list_tiles/track.dart';

class MediaListTile extends StatelessWidget {
  final MediaAnnotation annotation;

  const MediaListTile(this.annotation, {super.key});

  @override
  Widget build(BuildContext context) {
    return annotation.map(
      track: TrackListTile.new,
      artist: ArtistListTile.new,
      album: (_) => const SizedBox(height: 92, child: Placeholder()),
      genre: (_) => const SizedBox(height: 92, child: Placeholder()),
      playlist: (_) => const SizedBox(height: 92, child: Placeholder()),
      composer: (_) => const SizedBox(height: 92, child: Placeholder()),
      listener: (_) => const SizedBox(height: 92, child: Placeholder()),
    );
  }
}
