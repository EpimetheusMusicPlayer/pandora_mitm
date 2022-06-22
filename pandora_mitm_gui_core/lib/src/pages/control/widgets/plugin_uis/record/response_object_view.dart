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
    return StreamBuilder<Object?>(
      initialData: plugin.objectMap[record],
      stream: plugin.objectStream
          .where((entry) => entry.key == record)
          .map((entry) => entry.value),
      builder: (context, snapshot) => builder(context, snapshot.data),
    );
  }
}
