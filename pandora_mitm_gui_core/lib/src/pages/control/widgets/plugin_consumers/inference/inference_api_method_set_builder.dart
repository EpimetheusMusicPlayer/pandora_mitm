import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pandora_mitm/plugins.dart' as pmplg;

class InferenceApiMethodSetBuilder extends StatefulWidget {
  final pmplg.InferencePlugin plugin;
  final Widget Function(BuildContext context, Set<String>? apiMethods) builder;

  const InferenceApiMethodSetBuilder({
    Key? key,
    required this.plugin,
    required this.builder,
  }) : super(key: key);

  @override
  State<InferenceApiMethodSetBuilder> createState() =>
      _InferenceApiMethodSetBuilderState();
}

class _InferenceApiMethodSetBuilderState
    extends State<InferenceApiMethodSetBuilder> {
  late StreamSubscription<void> _apiMethodSubscription;
  Set<String>? _apiMethods;

  @override
  void initState() {
    super.initState();
    _bindToPlugin();
  }

  @override
  void didUpdateWidget(InferenceApiMethodSetBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.plugin, oldWidget.plugin)) {
      _unbindFromPlugin().then((_) => _bindToPlugin());
    }
  }

  @override
  void dispose() {
    _unbindFromPlugin();
    super.dispose();
  }

  Future<void> _bindToPlugin() async {
    Future<void> _updateApiMethods() async {
      final apiMethods = Set.of(await widget.plugin.inferredApiMethods);
      if (!mounted) return;
      setState(() => _apiMethods = apiMethods);
    }

    // Initialize the inferred API method set in case the stream emits an event
    // before the initial set is retrieved.
    _apiMethods = {};
    _apiMethodSubscription =
        widget.plugin.inferredApiMethodStream.listen((apiMethod) {
      if (!mounted) return;
      if (apiMethod == null) {
        // An API method inference has been cleared. Request the set again.
        _updateApiMethods();
      } else {
        // Otherwise, a new API method inference has been made. Add it to the
        // set.
        setState(() => _apiMethods!.add(apiMethod));
      }
    });
    await _updateApiMethods();
  }

  Future<void> _unbindFromPlugin() async {
    await _apiMethodSubscription.cancel();
    if (mounted) setState(() => _apiMethods = null);
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _apiMethods);
}
