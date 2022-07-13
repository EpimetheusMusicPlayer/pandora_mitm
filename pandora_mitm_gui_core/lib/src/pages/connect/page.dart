import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_mitm_gui_core/src/pages/connect/widgets/browser_warning.dart';
import 'package:pandora_mitm_gui_core/src/pages/connect/widgets/connection_setup.dart';
import 'package:pandora_mitm_gui_core/src/state/pandora_mitm_bloc.dart';
import 'package:pandora_mitm_gui_core/src/widgets/splash_art.dart';

class ConnectPage extends StatelessWidget {
  const ConnectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocListener<PandoraMitmBloc, PandoraMitmState>(
        listener: (context, state) {
          if (state is ConnectionFailedPandoraMitmState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Connection failed.')),
            );
          }
        },
        child: Theme(
          data: baseTheme.copyWith(
            scaffoldBackgroundColor: Theme.of(context).colorScheme.background,
            brightness: Brightness.dark,
            textTheme: baseTheme.typography.white,
          ),
          child: Center(
            child: IntrinsicWidth(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SplashArt(),
                      SizedBox(width: 64),
                      SizedBox(
                        width: 256,
                        child: ConnectionSetupWidget(),
                      ),
                    ],
                  ),
                  if (kIsWeb)
                    const Padding(
                      padding: EdgeInsets.only(top: 32),
                      child: BrowserWarning(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
