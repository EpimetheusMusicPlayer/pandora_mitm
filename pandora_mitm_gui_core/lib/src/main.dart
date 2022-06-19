import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_mitm_gui_core/src/pages/connect/page.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/page.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/feature_unlock/feature_unlock_plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/mitmproxy_ui_helper/mitmproxy_ui_helper_plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/reauthentication/reauthentication_plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/record_plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/state/pandora_mitm_bloc.dart';
import 'package:pandora_mitm_gui_core/src/theme.dart';

void runPandoraMitmGuiApp({
  List<PluginUi> extraPluginUis = const [],
  Map<String, Iterable<PluginUi>> extraPluginTemplates = const {},
}) =>
    runApp(
      PandoraMitmGuiApp(
        availablePluginUis: [
          ...extraPluginUis,
          const RecordPluginUi(),
          const ReauthenticationPluginUi(),
          const FeatureUnlockPluginUi(),
          const MitmproxyUiHelperPluginUi(),
        ],
        availablePluginTemplates: {
          'Blank': const [],
          'Recommended': const [RecordPluginUi()],
          'Recommended++': const [
            RecordPluginUi(),
            ReauthenticationPluginUi(),
            FeatureUnlockPluginUi(),
          ],
          'mitmproxy': const [MitmproxyUiHelperPluginUi()],
          ...extraPluginTemplates,
        },
      ),
    );

class PandoraMitmGuiApp extends StatefulWidget {
  final List<PluginUi> availablePluginUis;
  final Map<String, Iterable<PluginUi>> availablePluginTemplates;

  PandoraMitmGuiApp({
    Key? key,
    required this.availablePluginUis,
    required this.availablePluginTemplates,
  })  : assert(
          availablePluginTemplates.values.every(
            (pluginUiList) => pluginUiList.every(availablePluginUis.contains),
          ),
          'The plugin templates must only contain plugin uis that are generally available.',
        ),
        super(key: key);

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
            'control': (BuildContext context) => ControlPage(
                  availablePluginUis: widget.availablePluginUis,
                  availablePluginTemplates: widget.availablePluginTemplates,
                ),
          },
        ),
      ),
    );
  }
}
