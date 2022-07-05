import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/raw_code_view.dart';

class RawJsonView extends StatefulWidget {
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
  Widget build(BuildContext context) => RawCodeView(
        code: _jsonText,
        language: 'json',
        padding: widget.padding,
      );
}
