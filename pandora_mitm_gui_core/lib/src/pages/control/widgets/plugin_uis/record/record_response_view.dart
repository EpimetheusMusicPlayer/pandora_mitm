import 'package:flutter/material.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/interactive_json_view.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/raw_json_view.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/record_response_preview.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/message_tab_bar.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/themed_tab_bar.dart';
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
    final previewFactory = getResponsePreviewFactory(plugin, record);

    return DefaultTabController(
      length: previewFactory == null ? 2 : 3,
      child: Column(
        children: [
          MessageTabBar(
            jsonEncodable: record.response?.apiResponse,
            tabEntries: [
              if (previewFactory != null)
                const ThemedTabEntry('Preview', Icons.preview),
              ...MessageTabBar.defaultTabEntries,
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<PandoraResponse>(
                key: ObjectKey(record.responseFuture),
                future: record.responseFuture,
                initialData: record.response,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final response = snapshot.data!;

                  return TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      if (previewFactory != null)
                        Center(child: previewFactory()),
                      InteractiveJsonView(
                        key: ObjectKey(response.apiResponse),
                        json: response.apiResponse.toJson(),
                        initialDepth: 1,
                      ),
                      RawJsonView(
                        jsonEncodable: response.apiResponse,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
