import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines,
    this.validator,
    required this.title,
  });

  final TextEditingController controller;
  final int? maxLines;
  final String hintText;
  final Function(String? value)? validator;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 8),
        TextFormField(
          maxLines: maxLines,
          style: Theme.of(context).textTheme.labelMedium,
          controller: controller,
          validator: validator != null
              ? (String? value) => validator!(value)
              : null,
          decoration: InputDecoration(hintText: hintText),
        ),
      ],
    );
  }
}
