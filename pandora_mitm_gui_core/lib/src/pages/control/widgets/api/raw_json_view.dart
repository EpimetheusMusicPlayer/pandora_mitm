import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/idea.dart';

class RawJsonView extends StatelessWidget {
  static final theme = Map.of(ideaTheme)
    ..['root'] =
        ideaTheme['root']!.copyWith(backgroundColor: Colors.transparent);

  final Object jsonEncodable;

  const RawJsonView({
    Key? key,
    required this.jsonEncodable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final jsonText =
        const JsonEncoder.withIndent('    ').convert(jsonEncodable);

    return HighlightView(
      jsonText,
      language: 'json',
      theme: theme,
      padding: const EdgeInsets.all(8),
      textStyle: const TextStyle(fontFamily: 'JetBrains Mono'),
    );
  }
}
