import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_mitm_gui_core/src/pages/connect/page.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/page.dart';
import 'package:pandora_mitm_gui_core/src/state/pandora_mitm_bloc.dart';
import 'package:pandora_mitm_gui_core/src/theme.dart';

void runPandoraMitmGuiApp() => runApp(const PandoraMitmGuiApp());

class PandoraMitmGuiApp extends StatefulWidget {
  const PandoraMitmGuiApp({Key? key}) : super(key: key);

  @override
  State<PandoraMitmGuiApp> createState() => _PandoraMitmGuiAppState();
}

class _PandoraMitmGuiAppState extends State<PandoraMitmGuiApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => PandoraMitmBloc(),
      child: BlocListener<PandoraMitmBloc, PandoraMitmState>(
        listener: (context, state) {
          if (state is PandoraMitmConnected) {
            _navigatorKey.currentState!
                .pushReplacementNamed('control', arguments: state.pandoraMitm);
          } else {
            _navigatorKey.currentState!.pushReplacementNamed('/');
          }
        },
        listenWhen: (previous, current) =>
            (current is PandoraMitmConnected &&
                previous is! PandoraMitmConnected) ||
            (current is! PandoraMitmConnected &&
                previous is PandoraMitmConnected),
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          title: 'Pandora MITM',
          theme: themeData,
          darkTheme: darkThemeData,
          routes: {
            '/': (BuildContext context) => const ConnectPage(),
            'control': (BuildContext context) => const ControlPage(),
          },
        ),
      ),
    );
  }
}
