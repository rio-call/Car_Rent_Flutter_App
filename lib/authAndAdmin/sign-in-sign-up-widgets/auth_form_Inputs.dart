import 'package:flutter/material.dart';

typedef AuthDecorationBuilder =
    InputDecoration Function(String label, {Widget? suffixIcon});

class AuthEmailField extends StatelessWidget {
  final TextEditingController controller;
  final AuthDecorationBuilder decoration;
  final FormFieldValidator<String>? validator;
  final Color cursorColor;

  const AuthEmailField({
    super.key,
    required this.controller,
    required this.decoration,
    required this.cursorColor,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      cursorColor: cursorColor,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      decoration: decoration('Email'),
      validator: validator,
    );
  }
}

class AuthPasswordField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final AuthDecorationBuilder decoration;
  final FormFieldValidator<String>? validator;



  const AuthPasswordField({
    super.key,
    required this.label,
    required this.controller,
    required this.obscureText,
    required this.onToggleVisibility,
    required this.decoration,

    required this.validator,

  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),

      obscureText: obscureText,
 
      decoration: decoration(
        label,
        suffixIcon: IconButton(
          onPressed: onToggleVisibility,
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
      validator: validator,
    );
  }
}
