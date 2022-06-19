import 'package:flutter/material.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/interactive_json_view.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/raw_json_view.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/message_tab_bar.dart';

class RecordRequestView extends StatelessWidget {
  final PandoraMitmRecord record;

  const RecordRequestView({
    Key? key,
    required this.record,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          MessageTabBar(jsonEncodable: record.apiRequest.body),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  InteractiveJsonView(
                    key: ObjectKey(record.apiRequest.body),
                    json: record.apiRequest.body,
                  ),
                  RawJsonView(
                    key: ObjectKey(record.apiRequest.body),
                    jsonEncodable: record.apiRequest.body,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}