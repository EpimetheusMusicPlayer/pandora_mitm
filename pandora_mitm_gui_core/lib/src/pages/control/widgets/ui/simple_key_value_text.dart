import 'package:flutter/material.dart';

class SimpleKeyValueText extends StatelessWidget {
  final String label;
  final String value;

  const SimpleKeyValueText(
    this.label,
    this.value, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
