import 'package:flutter/material.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/tabs/record_list/record_information_view.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/tabs/record_list/record_request_view.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/tabs/record_list/record_response_view.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/themed_tab_bar.dart';
import 'package:pandora_mitm_gui_core/src/plugins/record.dart';

class RecordView extends StatelessWidget {
  final RecordPlugin plugin;
  final PandoraMitmRecord record;

  const RecordView({
    Key? key,
    required this.plugin,
    required this.record,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: RecordInformationView(record: record),
          ),
          const ThemedTabBar(
            tabs: [
              ThemedTabEntry('Request', Icons.upload),
              ThemedTabEntry('Response', Icons.download),
            ],
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                RecordRequestView(record: record),
                RecordResponseView(plugin: plugin, record: record),
              ],
            ),
          ),
        ],
      ),
    );
  }
}