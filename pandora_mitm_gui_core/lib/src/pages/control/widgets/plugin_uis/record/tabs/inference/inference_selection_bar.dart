import 'package:flutter/material.dart';

class InferenceSelectionBar extends StatelessWidget {
  final Set<String> apiMethods;
  final String? selectedApiMethod;
  final bool isRequestSelected;
  final ValueSetter<String> onApiMethodSelected;
  final ValueSetter<bool> onMessageTypeSelected;
  final bool inProgress;

  const InferenceSelectionBar({
    Key? key,
    required this.apiMethods,
    required this.selectedApiMethod,
    required this.isRequestSelected,
    required this.onApiMethodSelected,
    required this.onMessageTypeSelected,
    required this.inProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Theme(
        data: ThemeData(
          inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
        ),
        child: DropdownButtonHideUnderline(
          child: Row(
            children: [
              IntrinsicWidth(
                child: InputDecorator(
                  decoration: const InputDecoration(),
                  child: DropdownButton<String>(
                    hint: const Text('API method'),
                    value: selectedApiMethod,
                    onChanged: (apiMethod) => onApiMethodSelected(apiMethod!),
                    items: apiMethods
                        .map(
                          (apiMethod) => DropdownMenuItem(
                            value: apiMethod,
                            child: Text(apiMethod),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IntrinsicWidth(
                child: InputDecorator(
                  decoration: const InputDecoration(),
                  child: DropdownButton<bool>(
                    hint: const Text('Message type'),
                    value: isRequestSelected,
                    onChanged: (apiMethod) => onMessageTypeSelected(apiMethod!),
                    items: const [
                      DropdownMenuItem(value: true, child: Text('Request')),
                      DropdownMenuItem(value: false, child: Text('Response')),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              if (inProgress) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
