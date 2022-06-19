import 'package:flutter/material.dart';
import 'package:json_view/json_view.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/raw_json_view.dart';

class InteractiveJsonView extends StatelessWidget {
  final Map<String, dynamic> json;
  final int initialDepth;

  const InteractiveJsonView({
    Key? key,
    required this.json,
    this.initialDepth = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController.none(
      child: JsonConfig(
        data: JsonConfigData(
          color: JsonColorScheme(
            nullColor: RawJsonView.theme['literal']!.color,
            boolColor: RawJsonView.theme['literal']!.color,
            numColor: RawJsonView.theme['number']!.color,
            stringColor: RawJsonView.theme['string']!.color,
            normalColor: RawJsonView.theme['root']!.color,
          ),
          style: JsonStyleScheme(depth: initialDepth),
          animationDuration: const Duration(milliseconds: 200),
        ),
        child: JsonView(json: json),
      ),
    );
  }
}
