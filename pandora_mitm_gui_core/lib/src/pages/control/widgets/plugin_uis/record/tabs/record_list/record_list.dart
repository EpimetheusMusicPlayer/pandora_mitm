import 'package:auto_scroll/auto_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/consumers/connected_state_builder.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_consumers/record/recorder_builder.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/tabs/record_list/record_list_tile.dart';
import 'package:pandora_mitm_gui_core/src/plugins/record.dart';
import 'package:pandora_mitm_gui_core/src/state/pandora_mitm_bloc.dart';

class RecordListWidget extends StatelessWidget {
  final RecordPlugin plugin;

  const RecordListWidget({
    super.key,
    required this.plugin,
  });

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
              return ConnectedStateBuilder(
                selector: (state) => state.selectedRecord,
                builder: (context, selectedRecord) {
                  final isSelected = identical(record, selectedRecord);
                  return RecordListTile(
                    plugin: plugin,
                    record: record,
                    selected: isSelected,
                    onPressed: () {
                      if (isSelected) return;
                      context.read<PandoraMitmBloc>().selectRecord(index);
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
