import 'package:flutter/material.dart';

class DebugMediaListTileContainer extends StatelessWidget {
  final Widget mediaListTile;
  final String id;
  final List<String> secondaryIds;

  const DebugMediaListTileContainer({
    Key? key,
    required this.mediaListTile,
    required this.id,
    this.secondaryIds = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              '$id ${secondaryIds.isEmpty ? '' : '(${secondaryIds.join(', ')})'}',
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          const Divider(height: 0),
          mediaListTile,
        ],
      ),
    );
  }
}
