import 'package:flutter/material.dart';
import 'package:pandora_mitm_gui_core/src/pages/connect/widgets/connect_button.dart';
import 'package:pandora_mitm_gui_core/src/pages/connect/widgets/connection_form.dart';

class ConnectionSetupWidget extends StatefulWidget {
  const ConnectionSetupWidget({Key? key}) : super(key: key);

  @override
  State<ConnectionSetupWidget> createState() => _ConnectionSetupWidgetState();
}

class _ConnectionSetupWidgetState extends State<ConnectionSetupWidget> {
  final _formKey = GlobalKey<ConnectionFormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ConnectionForm(key: _formKey),
        const SizedBox(height: 16),
        ConnectButton(onPressed: () => _formKey.currentState!.submit()),
      ],
    );
  }
}
