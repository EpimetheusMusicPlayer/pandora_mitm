import 'package:flutter/material.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/interactive_json_view.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/raw_json_view.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/tabs/record_list/record_response_preview.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/message_tab_bar.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/themed_tab_bar.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/themed_tabbed_section.dart';
import 'package:pandora_mitm_gui_core/src/plugins/record.dart';

class RecordResponseView extends StatelessWidget {
  final RecordPlugin plugin;
  final PandoraMitmRecord record;

  const RecordResponseView({
    Key? key,
    required this.plugin,
    required this.record,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PandoraResponse>(
      key: ObjectKey(record.responseFuture),
      future: record.responseFuture,
      initialData: record.response,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final response = snapshot.data!;

        return ThemedTabbedSection(
          tabBar: MessageTabBar(
            jsonEncodable: record.response?.apiResponse,
            tabEntries: const [
              ...MessageTabBar.defaultTabEntries,
              ThemedTabEntry(title: Text('Preview'), icon: Icon(Icons.preview)),
            ],
          ),
          children: [
            InteractiveJsonView(
              key: ObjectKey(response.apiResponse),
              json: response.apiResponse.toJson(),
              initialDepth: 1,
            ),
            RawJsonView(
              jsonEncodable: response.apiResponse,
            ),
            RecordResponsePreview(
              plugin: plugin,
              record: record,
            ),
          ],
        );
      },
    );
  }
}
