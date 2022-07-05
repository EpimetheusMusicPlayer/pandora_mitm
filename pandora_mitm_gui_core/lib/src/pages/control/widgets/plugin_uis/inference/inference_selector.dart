import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm/plugins.dart' as pmplg;
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/controls/api_method_dropdown.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/plugin_uis/inference/inference_api_method_selector.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/themed_tab_bar.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/themed_tabbed_section.dart';
import 'package:pandora_mitm_gui_core/src/state/pandora_mitm_bloc.dart';

class InferenceSelector extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return InferenceApiMethodSetBuilder(
      plugin: plugin,
      builder: (context, apiMethods) {
        if (apiMethods == null) return const SizedBox.shrink();
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
                      builder(
                        context,
                        inference,
                        true,
                      ),
                      builder(
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
