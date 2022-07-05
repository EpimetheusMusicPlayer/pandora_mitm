import 'package:flutter/material.dart';
import 'package:json_view/json_view.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/raw_code_view.dart';

class InteractiveJsonView extends StatelessWidget {
  final Map<String, dynamic> json;
  final int initialDepth;
  final ScrollPhysics? physics;

  const InteractiveJsonView({
    Key? key,
    required this.json,
    this.initialDepth = 0,
    this.physics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController.none(
      child: JsonConfig(
        data: JsonConfigData(
          color: JsonColorScheme(
            nullColor: RawCodeView.theme['literal']!.color,
            boolColor: RawCodeView.theme['literal']!.color,
            numColor: RawCodeView.theme['number']!.color,
            stringColor: RawCodeView.theme['string']!.color,
            normalColor: RawCodeView.theme['root']!.color,
          ),
          style: JsonStyleScheme(depth: initialDepth),
          animationDuration: const Duration(milliseconds: 200),
        ),
        child: JsonView(
          json: json,
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          physics: physics,
        ),
      ),
    );
  }
}
