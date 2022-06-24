import 'package:flutter/material.dart';
import 'package:iapetus/iapetus.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/api_request_method_icon.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_consumers/record/response_object_view.dart';
import 'package:pandora_mitm_gui_core/src/plugins/record.dart';

class RecordListTile extends StatelessWidget {
  final RecordPlugin plugin;
  final PandoraMitmRecord record;
  final bool selected;
  final VoidCallback? onPressed;

  const RecordListTile({
    Key? key,
    required this.plugin,
    required this.record,
    this.selected = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PandoraResponse>(
      future: record.responseFuture,
      initialData: record.response,
      builder: (context, snapshot) {
        final response = snapshot.data;

        final accentColor = response?.apiResponse.when(
          ok: (result) => null,
          fail: (code, message) => Theme.of(context).errorColor,
        );

        return ListTile(
          dense: true,
          onTap: onPressed,
          selected: selected,
          selectedTileColor: Theme.of(context).focusColor,
          selectedColor: accentColor,
          textColor: accentColor,
          leading: ApiRequestMethodIcon(method: record.apiRequest.method),
          title:
              record.apiRequest.encrypted || (response?.encryptedBody ?? false)
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(child: Text(record.apiRequest.method)),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.lock_outline,
                          size: 16,
                          color: accentColor,
                        ),
                      ],
                    )
                  : Text(record.apiRequest.method),
          subtitle: response?.apiResponse.when(
            ok: (result) => null,
            fail: (code, message) => Text(
              message,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          trailing: response?.apiResponse.when(
            ok: (result) => ResponseObjectView(
              plugin: plugin,
              record: record,
              builder: (context, responseObject) {
                if (responseObject is CheckedFromJsonException) {
                  return Icon(
                    Icons.data_object,
                    color: Theme.of(context).errorColor,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            fail: (code, message) => Text(code.description),
          ),
        );
      },
    );
  }
}
