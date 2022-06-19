import 'package:flutter/material.dart';
import 'package:iapetus/iapetus.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/previews/media/list_tiles/debug/media.dart';
import 'package:pandora_mitm_gui_core/src/plugins/record.dart';

class AnnotationTab extends StatelessWidget {
  final RecordPlugin plugin;

  const AnnotationTab({
    Key? key,
    required this.plugin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, MediaAnnotation>>(
      initialData: plugin.annotationMap,
      stream: plugin.annotationsStream,
      builder: (context, snapshot) {
        final annotationMap = snapshot.data!;
        final annotations = annotationMap.values.toList(growable: false);
        return ListView.builder(
          primary: false,
          itemCount: annotations.length,
          itemBuilder: (context, index) {
            // return Text(index.toString());
            final annotation = annotations[index];
            return DebugMediaListTile(annotation);
          },
        );
      },
    );
  }
}
