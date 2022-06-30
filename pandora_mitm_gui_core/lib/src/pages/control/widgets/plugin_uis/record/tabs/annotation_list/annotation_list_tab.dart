import 'package:flutter/material.dart';
import 'package:iapetus/iapetus.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/previews/media/list_tiles/debug/media.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_consumers/record/recorder_builder.dart';
import 'package:pandora_mitm_gui_core/src/plugins/record.dart';

class AnnotationListTab extends StatelessWidget {
  final RecordPlugin plugin;

  const AnnotationListTab({
    Key? key,
    required this.plugin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RecorderBuilder<Map<String, MediaAnnotation>>(
      recorder: plugin.annotationRecorder,
      builder: (context, annotationMap) {
        final annotations = annotationMap.values.toList(growable: false);
        return ListView.builder(
          primary: false,
          itemCount: annotations.length,
          itemBuilder: (context, index) {
            final annotation = annotations[index];
            return DebugMediaListTile(annotation);
          },
        );
      },
    );
  }
}
