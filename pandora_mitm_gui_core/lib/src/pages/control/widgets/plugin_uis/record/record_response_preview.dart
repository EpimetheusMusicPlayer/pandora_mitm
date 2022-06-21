import 'package:flutter/material.dart';
import 'package:iapetus/iapetus.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/previews/api_error.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/previews/parsing_error.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/response_object_view.dart';
import 'package:pandora_mitm_gui_core/src/plugins/record.dart';

class RecordResponsePreview extends StatelessWidget {
  final RecordPlugin plugin;
  final PandoraMitmRecord record;

  const RecordResponsePreview({
    Key? key,
    required this.plugin,
    required this.record,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiResponse = record.response!.apiResponse;

    if (apiResponse is PandoraApiException) {
      return Center(child: ApiErrorPreview(error: apiResponse));
    }

    return Center(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(8),
        child: ResponseObjectView(
          plugin: plugin,
          record: record,
          builder: (context, responseObject) {
            if (responseObject is CheckedFromJsonException) {
              return ParsingErrorPreview(error: responseObject);
            }

            switch (record.apiRequest.method) {
              default:
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text.rich(TextSpan(
                      children: [
                        const TextSpan(text: 'Response preview for '),
                        TextSpan(
                          text: record.apiRequest.method,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' is not yet implemented.'),
                      ],
                    )),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
