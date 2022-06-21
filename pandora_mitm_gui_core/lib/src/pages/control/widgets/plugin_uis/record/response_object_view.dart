import 'package:flutter/widgets.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/plugins/record.dart';

class ResponseObjectView extends StatelessWidget {
  final RecordPlugin plugin;
  final PandoraMitmRecord record;
  final Widget Function(BuildContext context, Object? responseObject) builder;

  const ResponseObjectView({
    Key? key,
    required this.plugin,
    required this.record,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (plugin.objectMap.containsKey(record)) {
      return builder(context, plugin.objectMap[record]);
    } else {
      return FutureBuilder<Map<PandoraMitmRecord, Object?>>(
        future: plugin.objectsStream
            .firstWhere((objectMap) => objectMap.containsKey(record)),
        builder: (context, snapshot) {
          final objectMap = snapshot.data;
          return builder(context, objectMap == null ? null : objectMap[record]);
        },
      );
    }
  }
}
