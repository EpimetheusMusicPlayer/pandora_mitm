import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iapetus_meta/typing.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/raw_code_view.dart';

class InferenceCodegenButton extends StatelessWidget {
  final ApiMethodInference inference;
  final bool generateRequest;

  const InferenceCodegenButton({
    super.key,
    required this.inference,
    required this.generateRequest,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 36,
      icon: Image.asset(
        'packages/pandora_mitm_gui_core/assets/epimetheus_icon.png',
      ),
      tooltip: 'Generate Iapetus code',
      onPressed: () async {
        final name =
            '${inference.method.substring(inference.method.lastIndexOf('.') + 1)}_${generateRequest ? 'request' : 'response'}';
        final library = (generateRequest
                ? inference.requestValueTypeEntries
                : inference.responseValueTypeEntries)
            .buildLibrary(name);
        final code = library.render();

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.code),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Iapetus code - ${inference.method} ${generateRequest ? 'request' : 'response'}',
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    tooltip: 'Copy code',
                    onPressed: () =>
                        Clipboard.setData(ClipboardData(text: code)),
                  ),
                ],
              ),
              titlePadding: const EdgeInsets.all(16),
              content: ColoredBox(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: RawCodeView(
                  code: code,
                  language: 'dart',
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              contentPadding: EdgeInsets.zero,
            );
          },
        );
      },
    );
  }
}
