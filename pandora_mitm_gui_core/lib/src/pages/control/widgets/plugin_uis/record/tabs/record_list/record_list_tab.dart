import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/tabs/record_list/record_list.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/tabs/record_list/record_view.dart';
import 'package:pandora_mitm_gui_core/src/plugins/record.dart';
import 'package:pandora_mitm_gui_core/src/state/pandora_mitm_bloc.dart';

class RecordListTab extends StatelessWidget {
  final RecordPlugin plugin;

  const RecordListTab({
    super.key,
    required this.plugin,
  });

  @override
  Widget build(BuildContext context) {
    return MultiSplitView(
      initialAreas: [
        Area(weight: 0.5, minimalWeight: 0.25),
        Area(weight: 0.5, minimalWeight: 0.5),
      ],
      children: [
        RecordListWidget(plugin: plugin),
        BlocSelector<PandoraMitmBloc, PandoraMitmState, PandoraMitmRecord?>(
          selector: (state) => state.requireConnected.selectedRecord,
          builder: (context, selectedRecord) {
            if (selectedRecord == null) return const SizedBox.shrink();
            return RecordView(plugin: plugin, record: selectedRecord);
          },
        ),
      ],
    );
  }
}
