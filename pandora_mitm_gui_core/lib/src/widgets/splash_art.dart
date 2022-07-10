import 'package:flutter/material.dart';

class SplashArt extends StatelessWidget {
  const SplashArt({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          'Pandora\nMITM',
          style: Theme.of(context).textTheme.displaySmall,
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: kElevationToShadow[2],
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'packages/pandora_mitm_gui_core/assets/epimetheus_icon.png',
                width: 48,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'An Epimetheus\nproject',
              style:
                  Theme.of(context).textTheme.caption!.copyWith(fontSize: 20),
            ),
          ],
        ),
      ],
    );
  }
}
