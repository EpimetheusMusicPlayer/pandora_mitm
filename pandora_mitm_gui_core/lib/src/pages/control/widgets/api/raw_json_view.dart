import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/idea.dart';

class RawJsonView extends StatefulWidget {
  static final theme = Map.of(ideaTheme)
    ..['root'] =
        ideaTheme['root']!.copyWith(backgroundColor: Colors.transparent);

  final Object jsonEncodable;
  final EdgeInsetsGeometry padding;

  const RawJsonView({
    Key? key,
    required this.jsonEncodable,
    this.padding = const EdgeInsets.all(8),
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
    final simpleTextView = SelectableText(
      _jsonText,
      style: TextStyle(
        color: RawJsonView.theme['root']!.color,
        fontFamily: 'JetBrains Mono',
      ),
    );

    // Limit syntax highlighting to JSON snippets smaller than 100,000
    // characters to avoid blocking the UI for extended periods of time.
    if (_jsonText.length > 100000) return simpleTextView;

    return HighlightView(
      _jsonText,
      language: 'json',
      theme: RawJsonView.theme,
      padding: widget.padding,
      textStyle: const TextStyle(fontFamily: 'JetBrains Mono'),
      progressIndicator: simpleTextView,
    );
  }
}
