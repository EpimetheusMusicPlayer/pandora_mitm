import 'package:auto_scroll/auto_scroll.dart';
import 'package:flutter/material.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_consumers/record/recorder_builder.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/record_list_tile.dart';
import 'package:pandora_mitm_gui_core/src/plugins/record.dart';

class RecordListWidget extends StatelessWidget {
  final RecordPlugin plugin;
  final PandoraMitmRecord? selectedRecord;
  final ValueChanged<PandoraMitmRecord> onRecordSelected;

  const RecordListWidget({
    Key? key,
    required this.plugin,
    required this.selectedRecord,
    required this.onRecordSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RecorderBuilder<List<PandoraMitmRecord>>(
      recorder: plugin.messageRecorder,
      builder: (context, records) {
        return AutoScroller(
          lengthIdentifier: records.length,
          builder: (context, controller) => ListView.builder(
            controller: controller,
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return ColoredBox(
                color: Colors.transparent,
                // color: index.isOdd
                //     ? Theme.of(context).focusColor.withAlpha(0x7)
                //     : Colors.transparent,
                child: RecordListTile(
                  plugin: plugin,
                  record: record,
                  selected: identical(record, selectedRecord),
                  onPressed: () => onRecordSelected(record),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
