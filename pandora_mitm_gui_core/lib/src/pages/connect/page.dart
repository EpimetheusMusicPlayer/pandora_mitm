import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_mitm_gui_core/src/pages/connect/widgets/connection_setup.dart';
import 'package:pandora_mitm_gui_core/src/state/pandora_mitm_bloc.dart';
import 'package:pandora_mitm_gui_core/src/widgets/splash_art.dart';

class ConnectPage extends StatelessWidget {
  const ConnectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    return Theme(
      data: baseTheme.copyWith(
        scaffoldBackgroundColor: Theme.of(context).colorScheme.background,
        brightness: Brightness.dark,
        textTheme: baseTheme.typography.white,
      ),
      child: Scaffold(
        body: BlocListener<PandoraMitmBloc, PandoraMitmState>(
          listener: (context, state) {
            if (state is ConnectionFailedPandoraMitmState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Connection failed.')),
              );
            }
          },
          child: Row(
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
        ),
      ),
    );
  }
}
