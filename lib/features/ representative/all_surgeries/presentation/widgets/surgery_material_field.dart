import 'package:flutter/material.dart';
import '../../../../../core/custom_widgets/custom_text_field.dart';

class SurgeryMaterialField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;

  const SurgeryMaterialField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      labelText: label,
      hintText: hint,
    );
  }
}