import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:iapetus/iapetus.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/raw_json_view.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/json_copy_button.dart';

class ParsingErrorPreview extends StatelessWidget {
  final CheckedFromJsonException error;
  final VoidCallback reparse;

  const ParsingErrorPreview({
    Key? key,
    required this.error,
    required this.reparse,
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
            Row(
              children: [
                SizedBox(width: Theme.of(context).iconTheme.size ?? 24),
                Expanded(
                  child: Text(
                    '{ JSON parsing error }',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: false,
                    maxLines: 1,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.standard,
                  onPressed: reparse,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
                  _buildKeyValueTableRow(
                    'JSON',
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.data_object,
                                    color: Theme.of(context).errorColor,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      '${error.className}: ${error.key}: ${error.message}',
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  JsonCopyButton(jsonEncodable: error.map),
                                ],
                              ),
                              titlePadding: const EdgeInsets.all(16),
                              titleTextStyle: TextStyle(
                                color: Theme.of(context).errorColor,
                              ),
                              content: ColoredBox(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: RawJsonView(
                                  jsonEncodable: error.map,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                ),
                              ),
                              contentPadding: EdgeInsets.zero,
                            );
                          },
                        );
                      },
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Show'),
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
