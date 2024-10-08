import 'package:flutter/material.dart';

class RepeatedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String hint;
  final Widget? sufix;
  final bool? isVisible;
  final bool? isNum;
 final void Function(String)? onChanged;
  const RepeatedTextField({
    super.key,
    required this.controller,
    this.validator,
    required this.hint,
    this.sufix,
    this.isVisible,
    this.isNum = false, this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        onChanged: onChanged,
      controller: controller,
      validator: validator,
      obscureText: isVisible ?? false,
      keyboardType: isNum! ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: sufix,
      ),
    );
  }
}