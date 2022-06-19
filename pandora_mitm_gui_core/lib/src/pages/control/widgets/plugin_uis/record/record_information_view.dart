import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pandora_mitm/pandora_mitm.dart';

class RecordInformationView extends StatelessWidget {
  final PandoraMitmRecord record;

  const RecordInformationView({
    Key? key,
    required this.record,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SelectableText(
                    // TODO: Disable line wrap. Blocked by https://github.com/flutter/flutter/issues/80435.
                    record.apiRequest.method,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy method',
                  onPressed: () => Clipboard.setData(
                    ClipboardData(text: record.apiRequest.method),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            SelectableText(
              record.flowId,
              style: Theme.of(context).textTheme.caption,
            ),
            const Divider(),
            if (record.apiRequest.partnerId != null)
              SelectableText.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Partner: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: record.apiRequest.partnerId!.toString()),
                  ],
                ),
              ),
            if (record.apiRequest.authToken != null)
              SelectableText.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Auth: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: record.apiRequest.authToken),
                  ],
                ),
              ),
            if (record.apiRequest.deviceId != null)
              SelectableText.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Device ID: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: record.apiRequest.deviceId,
                    ),
                  ],
                ),
              ),
            FutureBuilder<PandoraResponse>(
              future: record.responseFuture,
              initialData: record.response,
              builder: (context, snapshot) {
                final response = snapshot.data;
                final requestEncrypted = record.apiRequest.encrypted;
                final responseEncrypted = response?.encryptedBody ?? false;
                if (!(requestEncrypted || responseEncrypted)) {
                  return const SizedBox.shrink();
                }
                return SelectableText.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Encryption: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: requestEncrypted
                            ? responseEncrypted
                                ? 'Bidirectional'
                                : 'Request'
                            : responseEncrypted
                                ? 'Response'
                                : 'None',
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
