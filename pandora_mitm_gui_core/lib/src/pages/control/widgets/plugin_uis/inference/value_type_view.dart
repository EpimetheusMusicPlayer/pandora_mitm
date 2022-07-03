import 'package:flutter/material.dart';
import 'package:iapetus_meta/typing.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/ui/themed_tab_bar.dart';

class FlatValueTypeView extends StatelessWidget {
  final String name;
  final ValueType valueType;

  const FlatValueTypeView({
    Key? key,
    required this.name,
    required this.valueType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final objectEntries =
        valueType.flattenObjectTypes(name).toList(growable: false);

    return DefaultTabController(
      length: objectEntries.length,
      // https://github.com/flutter/flutter/issues/86584
      // A Material is needed to prevent ripples from tab children extending
      // beyond their appropriate area.
      child: Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ThemedTabBar(
              tabs: objectEntries.map(
                (entry) {
                  final IconData iconData;
                  switch (entry.parentCategory) {
                    case NestedObjectValueTypeParentCategory.root:
                    case NestedObjectValueTypeParentCategory.object:
                      iconData = Icons.data_object;
                      break;
                    case NestedObjectValueTypeParentCategory.map:
                      iconData = Icons.transform;
                      break;
                    case NestedObjectValueTypeParentCategory.list:
                      iconData = Icons.data_array;
                      break;
                  }

                  return ThemedTabEntry(entry.name, iconData);
                },
              ).toList(growable: false),
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: objectEntries
                    .map(
                      (entry) => ShallowJsonObjectValueTypeView(
                        valueType: entry.valueType,
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShallowJsonObjectValueTypeView extends StatelessWidget {
  final TypedJsonObjectValueType valueType;

  const ShallowJsonObjectValueTypeView({
    Key? key,
    required this.valueType,
  }) : super(key: key);

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
