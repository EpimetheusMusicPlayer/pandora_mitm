import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/tabs/record_list/record_list.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/tabs/record_list/record_view.dart';
import 'package:pandora_mitm_gui_core/src/plugins/record.dart';

class RecordListTab extends StatefulWidget {
  final RecordPlugin plugin;

  const RecordListTab({
    Key? key,
    required this.plugin,
  }) : super(key: key);

  @override
  State<RecordListTab> createState() => _RecordListTabState();
}

class _RecordListTabState extends State<RecordListTab> {
  PandoraMitmRecord? _selectedRecord;

  @override
  Widget build(BuildContext context) {
    return MultiSplitView(
      initialAreas: [
        Area(weight: 0.25, minimalWeight: 0.25),
        Area(weight: 0.75, minimalWeight: 0.5),
      ],
      children: [
        RecordListWidget(
          plugin: widget.plugin,
          selectedRecord: _selectedRecord,
          onRecordSelected: (record) {
            setState(() {
              _selectedRecord =
                  identical(record, _selectedRecord) ? null : record;
            });
          },
        ),
        if (_selectedRecord != null)
          RecordView(
            plugin: widget.plugin,
            record: _selectedRecord!,
          ),
      ],
    );
  }
}
