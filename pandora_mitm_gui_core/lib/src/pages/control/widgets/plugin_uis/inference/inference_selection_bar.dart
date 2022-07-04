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
              const SizedBox(width: 12),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: selectedApiMethod == null
                    ? null
                    : () => onMessageTypeSelected(!isRequestSelected),
                icon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_outlined, size: 20),
                    AnimatedRotation(
                      turns: isRequestSelected ? 0.5 : 0,
                      curve: Curves.bounceOut,
                      duration: const Duration(milliseconds: 400),
                      child: const Icon(Icons.arrow_downward, size: 20),
                    ),
                  ],
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
