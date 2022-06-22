import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/idea.dart';

class RawJsonView extends StatefulWidget {
  static final theme = Map.of(ideaTheme)
    ..['root'] =
        ideaTheme['root']!.copyWith(backgroundColor: Colors.transparent);

  final Object jsonEncodable;

  const RawJsonView({
    Key? key,
    required this.jsonEncodable,
  }) : super(key: key);

  @override
  State<RawJsonView> createState() => _RawJsonViewState();
}

class _RawJsonViewState extends State<RawJsonView> {
  late String _jsonText;

  void _decodeJson() => _jsonText =
      const JsonEncoder.withIndent('  ').convert(widget.jsonEncodable);

  @override
  void initState() {
    super.initState();
    _decodeJson();
  }

  @override
  void didUpdateWidget(RawJsonView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.jsonEncodable != oldWidget.jsonEncodable) {
      _decodeJson();
    }
  }

  @override
  Widget build(BuildContext context) {
    return HighlightView(
      _jsonText,
      language: 'json',
      theme: RawJsonView.theme,
      padding: const EdgeInsets.all(8),
      textStyle: const TextStyle(fontFamily: 'JetBrains Mono'),
    );
  }
}
