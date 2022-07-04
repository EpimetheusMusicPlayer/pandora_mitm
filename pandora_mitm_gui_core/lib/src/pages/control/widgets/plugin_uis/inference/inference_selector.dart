import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm/plugins.dart' as pmplg;
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/inference/inference_selection_bar.dart';
import 'package:pandora_mitm_gui_core/src/state/pandora_mitm_bloc.dart';

class InferenceSelector extends StatefulWidget {
  final pmplg.InferencePlugin plugin;
  final Widget Function(
    BuildContext context,
    ApiMethodInference inference,
    bool isRequestSelected,
  ) builder;

  const InferenceSelector({
    Key? key,
    required this.plugin,
    required this.builder,
  }) : super(key: key);

  @override
  State<InferenceSelector> createState() => _InferenceSelectorState();
}

class _InferenceSelectorState extends State<InferenceSelector> {
  late StreamSubscription<void> _apiMethodSubscription;
  late Future<Set<String>> _apiMethodsFuture;
  var _isRequestSelected = false;

  @override
  void initState() {
    super.initState();
    _bindToPlugin();
  }

  @override
  void didUpdateWidget(InferenceSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.plugin, oldWidget.plugin)) {
      _unbindFromPlugin().then((_) {
        if (mounted) _bindToPlugin();
      });
    }
  }

  @override
  void dispose() {
    _unbindFromPlugin();
    super.dispose();
  }

  void _bindToPlugin() {
    _apiMethodsFuture = Future.value(widget.plugin.inferredApiMethods);
    _apiMethodSubscription = widget.plugin.inferredApiMethodStream.listen((_) {
      setState(
        () {
          _apiMethodsFuture = Future.value(widget.plugin.inferredApiMethods);
        },
      );
    });
  }

  Future<void> _unbindFromPlugin() async {
    await _apiMethodSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Set<String>>(
      future: _apiMethodsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final apiMethods = snapshot.requireData;
        return BlocSelector<PandoraMitmBloc, PandoraMitmState,
            ApiMethodInference?>(
          selector: (state) => state.requireConnected.selectedInference,
          builder: (context, inference) {
            return Column(
              children: [
                InferenceSelectionBar(
                  apiMethods: apiMethods,
                  selectedApiMethod: inference?.method,
                  isRequestSelected: _isRequestSelected,
                  onApiMethodSelected: (selectedApiMethod) => context
                      .read<PandoraMitmBloc>()
                      .selectApiMethod(selectedApiMethod),
                  onMessageTypeSelected: (isRequestSelected) =>
                      setState(() => _isRequestSelected = isRequestSelected),
                  inProgress: false,
                ),
                const Divider(height: 0),
                if (inference != null)
                  Expanded(
                    child: widget.builder(
                      context,
                      inference,
                      _isRequestSelected,
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
