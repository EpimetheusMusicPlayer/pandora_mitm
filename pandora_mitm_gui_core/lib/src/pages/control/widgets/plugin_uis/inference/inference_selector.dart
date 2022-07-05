import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm/plugins.dart' as pmplg;
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/controls/api_method_dropdown.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/themed_tab_bar.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/themed_tabbed_section.dart';
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
            final tabBarTextTheme =
                Theme.of(context).primaryTextTheme.bodyText1!;
            return ThemedTabbedSection(
              tabBar: ThemedTabBar(
                alignment: Alignment.centerRight,
                leading: [
                  Theme(
                    data: ThemeData(
                      inputDecorationTheme:
                          Theme.of(context).inputDecorationTheme.copyWith(
                                iconColor: tabBarTextTheme.color,
                                contentPadding:
                                    const EdgeInsets.only(left: 20, right: 4),
                              ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: DropdownButtonHideUnderline(
                        child: ApiMethodDropdown(
                          apiMethods: apiMethods,
                          selectionValid: inference != null,
                          textStyle: tabBarTextTheme,
                        ),
                      ),
                    ),
                  )
                ],
                tabs: const [
                  ThemedTabEntry(
                    title: Text('Request'),
                    icon: Icon(Icons.upload),
                  ),
                  ThemedTabEntry(
                    title: Text('Response'),
                    icon: Icon(Icons.download),
                  ),
                ],
              ),
              children: inference == null
                  ? const [SizedBox.shrink(), SizedBox.shrink()]
                  : [
                      widget.builder(
                        context,
                        inference,
                        true,
                      ),
                      widget.builder(
                        context,
                        inference,
                        false,
                      ),
                    ],
            );
          },
        );
      },
    );
  }
}
