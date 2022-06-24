import 'package:flutter/widgets.dart';
import 'package:pandora_mitm_gui_core/src/plugins/record.dart';

class RecorderBuilder<C> extends StatelessWidget {
  final Recorder<Object, C> recorder;
  final Widget Function(BuildContext context, C records) builder;

  const RecorderBuilder({
    Key? key,
    required this.recorder,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<C>(
      initialData: recorder.records,
      stream: recorder.recordsStream,
      builder: (context, snapshot) => builder(context, snapshot.requireData),
    );
  }
}
