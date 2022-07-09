import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/flutter_highlight_background.dart';
import 'package:flutter_highlight/themes/idea.dart';

class RawCodeView extends StatelessWidget {
  static final theme = Map.of(ideaTheme)
    ..['root'] =
        ideaTheme['root']!.copyWith(backgroundColor: Colors.transparent);

  final String code;
  final String language;
  final EdgeInsetsGeometry padding;

  const RawCodeView({
    super.key,
    required this.code,
    required this.language,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    final simpleTextView = SelectableText(
      code,
      style: TextStyle(
        color: theme['root']!.color,
        fontFamily: 'JetBrains Mono',
      ),
    );

    // Limit syntax highlighting to code snippets smaller than 100,000
    // characters to avoid blocking the UI for extended periods of time.
    if (code.length > 100000) return simpleTextView;

    return HighlightView(
      code,
      language: language,
      theme: theme,
      padding: padding,
      textStyle: const TextStyle(fontFamily: 'JetBrains Mono'),
      progressIndicator: HighlightBackgroundProvider.maybeOf(context) == null
          ? null
          : simpleTextView,
    );
  }
}
