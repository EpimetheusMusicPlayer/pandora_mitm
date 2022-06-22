import 'package:flutter/material.dart';

extension PopupMenuTapDownUtils on TapDownDetails {
  RelativeRect calculateMenuPosition(BuildContext context) {
    final overlay =
        Overlay.of(context)!.context.findRenderObject()! as RenderBox;
    return RelativeRect.fromLTRB(
      globalPosition.dx,
      globalPosition.dy,
      overlay.size.width - globalPosition.dx,
      overlay.size.height - globalPosition.dy,
    );
  }
}
