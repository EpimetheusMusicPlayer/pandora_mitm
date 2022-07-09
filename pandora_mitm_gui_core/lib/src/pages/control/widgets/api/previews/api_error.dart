import 'package:flutter/material.dart';
import 'package:iapetus/iapetus.dart';

class ApiErrorPreview extends StatelessWidget {
  final PandoraApiException error;

  const ApiErrorPreview({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SelectableText.rich(
              TextSpan(
                style: TextStyle(color: Theme.of(context).errorColor),
                children: [
                  TextSpan(
                    text: error.code.value.toString(),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: ' - ${error.code.description}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SelectableText('"${error.message}"'),
          ],
        ),
      ),
    );
  }
}
