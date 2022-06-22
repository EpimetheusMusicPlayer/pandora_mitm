import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:iapetus/iapetus.dart';

class ParsingErrorPreview extends StatelessWidget {
  final CheckedFromJsonException error;

  const ParsingErrorPreview({
    Key? key,
    required this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final labelTextStyle = Theme.of(context).textTheme.caption;
    TableRow _buildKeyValueTableRow(
      String label,
      Widget value, {
      bool valueHasPadding = false,
      EdgeInsets labelPadding = EdgeInsets.zero,
      TableCellVerticalAlignment verticalAlignment =
          TableCellVerticalAlignment.baseline,
    }) {
      return TableRow(
        children: [
          TableCell(
            verticalAlignment: verticalAlignment,
            child: Padding(
              padding: labelPadding,
              child: Text(
                label,
                style: labelTextStyle,
                textAlign: TextAlign.right,
                softWrap: false,
                maxLines: 1,
              ),
            ),
          ),
          const SizedBox.shrink(),
          TableCell(
            verticalAlignment: verticalAlignment,
            child: Padding(
              padding: EdgeInsets.only(bottom: valueHasPadding ? 0 : 4),
              child: value,
            ),
          ),
        ],
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '{ JSON parsing error }',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ExpandableTheme(
              data: const ExpandableThemeData(
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                iconPlacement: ExpandablePanelIconPlacement.left,
                iconPadding: EdgeInsets.zero,
                iconRotationAngle: pi / 2,
                expandIcon: Icons.keyboard_arrow_right,
              ),
              child: Table(
                columnWidths: const {
                  0: IntrinsicColumnWidth(),
                  1: FixedColumnWidth(8),
                  2: IntrinsicColumnWidth(),
                },
                textBaseline: TextBaseline.alphabetic,
                children: [
                  _buildKeyValueTableRow(
                    'Class',
                    SelectableText(
                      error.className ?? 'N/A',
                      style: const TextStyle(fontFamily: 'Jetbrains Mono'),
                    ),
                  ),
                  if (error.map.containsKey('pandoraId'))
                    _buildKeyValueTableRow(
                      'Pandora ID',
                      SelectableText(error.map['pandoraId'].toString()),
                    ),
                  _buildKeyValueTableRow(
                    'Key',
                    SelectableText(error.key ?? 'N/A'),
                  ),
                  _buildKeyValueTableRow(
                    'Message',
                    SelectableText(error.message ?? ''),
                  ),
                  if (error.innerError != null)
                    _buildKeyValueTableRow(
                      'Parse error',
                      labelPadding: const EdgeInsets.only(top: 3.5),
                      verticalAlignment: TableCellVerticalAlignment.top,
                      valueHasPadding: true,
                      ExpandablePanel(
                        header: const SizedBox.shrink(),
                        collapsed: const SizedBox.shrink(),
                        expanded: Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: SelectableText(error.innerError.toString()),
                        ),
                      ),
                    ),
                  if (error.innerStack != null)
                    _buildKeyValueTableRow(
                      'Stack trace',
                      labelPadding: const EdgeInsets.only(top: 3.5),
                      verticalAlignment: TableCellVerticalAlignment.top,
                      valueHasPadding: true,
                      ExpandablePanel(
                        header: const SizedBox.shrink(),
                        collapsed: const SizedBox.shrink(),
                        expanded: Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: SelectableText(
                            error.innerStack.toString(),
                            style: const TextStyle(
                              fontFamily: 'Jetbrains Mono',
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
