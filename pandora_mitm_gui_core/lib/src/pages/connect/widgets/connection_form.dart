import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_mitm_gui_core/src/state/pandora_mitm_bloc.dart';

class ConnectionForm extends StatefulWidget {
  const ConnectionForm({Key? key}) : super(key: key);

  @override
  State<ConnectionForm> createState() => ConnectionFormState();
}

class ConnectionFormState extends State<ConnectionForm> {
  final _formKey = GlobalKey<FormState>();
  late String _host;
  late int _port;

  void submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    context.read<PandoraMitmBloc>().connect(host: _host, port: _port);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Host',
                  hintText: 'localhost',
                ),
                onSaved: (value) =>
                    _host = value?.isEmpty ?? true ? 'localhost' : value!,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Port',
                  hintText: '8082',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return null;
                  if (int.tryParse(value!) == null) {
                    return 'Invalid port number.';
                  }
                  return null;
                },
                onSaved: (value) =>
                    _port = value?.isEmpty ?? true ? 8082 : int.parse(value!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
