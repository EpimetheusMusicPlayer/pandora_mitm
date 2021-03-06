import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_highlight/flutter_highlight_background.dart';
import 'package:pandora_mitm_gui_core/src/pages/connect/page.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/page.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/feature_unlock/feature_unlock_plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/inference/inference_plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/mitmproxy_ui_helper/mitmproxy_ui_helper_plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/reauthentication/reauthentication_plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/record/record_plugin_ui.dart';
import 'package:pandora_mitm_gui_core/src/state/log_notifier.dart';
import 'package:pandora_mitm_gui_core/src/state/pandora_mitm_bloc.dart';
import 'package:pandora_mitm_gui_core/src/theme.dart';
import 'package:provider/provider.dart';

void runPandoraMitmGuiApp({
  List<PluginUi> extraPluginUis = const [],
  Map<String, List<PluginUi>> extraPluginTemplates = const {},
}) {
  runApp(
    PandoraMitmGuiApp(
      availablePluginUis: [
        ...extraPluginUis,
        const RecordPluginUi(),
        const ReauthenticationPluginUi(),
        const FeatureUnlockPluginUi(),
        const InferencePluginUi(),
        const MitmproxyUiHelperPluginUi(),
      ],
      availablePluginTemplates: {
        'Blank': const [],
        'Recommended': const [RecordPluginUi()],
        'Research': const [
          RecordPluginUi(),
          InferencePluginUi(),
          ReauthenticationPluginUi(),
          FeatureUnlockPluginUi(),
        ],
        'mitmproxy': const [MitmproxyUiHelperPluginUi()],
        ...extraPluginTemplates,
      },
    ),
  );
}

class PandoraMitmGuiApp extends StatefulWidget {
  final List<PluginUi> availablePluginUis;
  final Map<String, List<PluginUi>> availablePluginTemplates;

  PandoraMitmGuiApp({
    super.key,
    required this.availablePluginUis,
    required this.availablePluginTemplates,
  }) : assert(
          availablePluginTemplates.values.every(
            (pluginUiList) => pluginUiList.every(availablePluginUis.contains),
          ),
          'The plugin templates must only contain plugin uis that are generally available.',
        );

  @override
  State<PandoraMitmGuiApp> createState() => _PandoraMitmGuiAppState();
}

class _PandoraMitmGuiAppState extends State<PandoraMitmGuiApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final ui = MaterialApp(
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
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => LogNotifier(),
          lazy: false,
        ),
        BlocProvider(
          create: (BuildContext context) => PandoraMitmBloc(),
          lazy: false,
        ),
      ],
      child: BlocListener<PandoraMitmBloc, PandoraMitmState>(
        listener: (context, state) {
          if (state is ConnectedPandoraMitmState) {
            _navigatorKey.currentState!
                .pushReplacementNamed('control', arguments: state.pandoraMitm);
          } else {
            _navigatorKey.currentState!.pushReplacementNamed('/');
          }
        },
        listenWhen: (previous, current) =>
            (current is ConnectedPandoraMitmState &&
                previous is! ConnectedPandoraMitmState) ||
            (current is! ConnectedPandoraMitmState &&
                previous is ConnectedPandoraMitmState),
        child: kIsWeb ? ui : HighlightBackgroundEnvironment(child: ui),
      ),
    );
  }
}
