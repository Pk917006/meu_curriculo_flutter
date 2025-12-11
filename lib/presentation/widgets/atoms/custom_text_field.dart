// Flutter imports:
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? hint;
  final int maxLines;
  final bool required;
  final TextInputType? keyboardType;

  const CustomTextField({
    required this.controller, required this.label, required this.icon, super.key,
    this.hint,
    this.maxLines = 1,
    this.required = false,
    this.keyboardType,
  });

  @override
  Widget build(final BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: required
          ? (final v) => v?.isEmpty == true ? 'Campo obrigatório' : null
          : null,
    );
  }
}
