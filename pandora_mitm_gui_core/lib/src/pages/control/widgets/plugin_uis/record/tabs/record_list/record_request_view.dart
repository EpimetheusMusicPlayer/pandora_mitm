import 'package:flutter/material.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/interactive_json_view.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/raw_json_view.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/message_tab_bar.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/themed_tabbed_section.dart';

class RecordRequestView extends StatelessWidget {
  final PandoraMitmRecord record;

  const RecordRequestView({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedTabbedSection(
      tabBar: MessageTabBar(jsonEncodable: record.apiRequest.body),
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
    );
  }
}
