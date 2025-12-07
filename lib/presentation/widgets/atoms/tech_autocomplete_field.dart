// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../core/constants/tech_suggestions.dart';

class TechAutocompleteField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool required;
  final Function(String)? onSelected;
  final Function(String)? onFieldSubmitted;
  final List<String>? excludeItems;

  const TechAutocompleteField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.required = false,
    this.onSelected,
    this.onFieldSubmitted,
    this.excludeItems,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Autocomplete<String>(
          initialValue: TextEditingValue(text: controller.text),
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<String>.empty();
            }
            return kTechSuggestions.where((String option) {
              final matches = option.toLowerCase().contains(
                textEditingValue.text.toLowerCase(),
              );
              final isExcluded = excludeItems?.contains(option) ?? false;
              return matches && !isExcluded;
            });
          },
          onSelected: (String selection) {
            controller.text = selection;
            onSelected?.call(selection);
          },
          fieldViewBuilder:
              (
                BuildContext context,
                TextEditingController fieldTextEditingController,
                FocusNode fieldFocusNode,
                VoidCallback onFieldSubmitted,
              ) {
                // Sync external controller with internal one if needed
                // But here we want the external controller to be the source of truth eventually.
                // However, Autocomplete uses its own controller.
                // We need to listen to changes.

                // A better approach for forms is to let Autocomplete manage the text input
                // and update our controller on change.

                // If the external controller has text, set it.
                if (fieldTextEditingController.text != controller.text &&
                    controller.text.isNotEmpty) {
                  // This might cause loops if not careful, but initialValue handles the start.
                }

                return TextFormField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  decoration: InputDecoration(
                    labelText: required ? '$label *' : label,
                    prefixIcon: Icon(icon),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    suffixIcon: fieldTextEditingController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              fieldTextEditingController.clear();
                              controller.clear();
                            },
                          )
                        : null,
                  ),
                  validator: required
                      ? (v) => v?.isEmpty == true ? 'Campo obrigatório' : null
                      : null,
                  onChanged: (val) {
                    controller.text = val;
                  },
                  onFieldSubmitted: (val) {
                    onFieldSubmitted(); // Call Autocomplete's onFieldSubmitted to close overlay
                    this.onFieldSubmitted?.call(val);
                  },
                );
              },
          optionsViewBuilder:
              (
                BuildContext context,
                AutocompleteOnSelected<String> onSelected,
                Iterable<String> options,
              ) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: SizedBox(
                      width: constraints.maxWidth,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String option = options.elementAt(index);
                          return ListTile(
                            title: Text(option),
                            onTap: () {
                              onSelected(option);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
        );
      },
    );
  }
}
