import 'package:flutter/material.dart';
import 'package:iapetus_meta/typing.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/themed_tab_bar.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/themed_tabbed_section.dart';

class FlatValueTypeView extends StatelessWidget {
  final List<NestedObjectValueTypeEntry> nestedObjectEntries;
  final List<Widget>? actions;

  const FlatValueTypeView({
    super.key,
    required this.nestedObjectEntries,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedTabbedSection(
      tabBar: ThemedTabBar(
        tabs: nestedObjectEntries.map(
          (entry) {
            final Icon icon;
            switch (entry.parentCategory) {
              case NestedObjectValueTypeParentCategory.root:
              case NestedObjectValueTypeParentCategory.object:
                icon = const Icon(Icons.data_object);
                break;
              case NestedObjectValueTypeParentCategory.map:
                icon = const Icon(Icons.transform);
                break;
              case NestedObjectValueTypeParentCategory.list:
                icon = const Icon(Icons.data_array);
                break;
            }

            return ThemedTabEntry(title: Text(entry.name), icon: icon);
          },
        ).toList(growable: false),
        actions: actions,
      ),
      children: nestedObjectEntries
          .map(
            (entry) => ShallowJsonObjectValueTypeView(
              valueType: entry.valueType,
            ),
          )
          .toList(growable: false),
    );
  }
}

class ShallowJsonObjectValueTypeView extends StatelessWidget {
  final TypedJsonObjectValueType valueType;

  const ShallowJsonObjectValueTypeView({
    super.key,
    required this.valueType,
  });

  @override
  Widget build(BuildContext context) {
    final entries = valueType.fieldValueTypes.entries.toList(growable: false);

    return ListView.builder(
      primary: false,
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return ListTile(
          dense: true,
          tileColor:
              index.isOdd ? Theme.of(context).hoverColor : Colors.transparent,
          title: Text(
            entry.key,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          trailing: Text(
            entry.value.name + (entry.value.optional ? ' (Optional)' : ''),
          ),
        );
      },
    );
  }
}
