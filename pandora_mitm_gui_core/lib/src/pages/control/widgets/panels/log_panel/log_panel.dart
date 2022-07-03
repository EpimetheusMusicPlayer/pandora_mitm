import 'package:auto_scroll/auto_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/panels/log_panel/log_tile.dart';
import 'package:pandora_mitm_gui_core/src/state/log_notifier.dart';

class LogPanel extends StatelessWidget {
  const LogPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final records = context.watch<LogNotifier>().records;
    return AutoScroller(
      lengthIdentifier: records.length,
      builder: (context, scrollController) {
        return ListView.builder(
          controller: scrollController,
          primary: false,
          itemCount: records.length,
          itemBuilder: (context, index) => LogTile(record: records[index]),
        );
      },
    );
  }
}
