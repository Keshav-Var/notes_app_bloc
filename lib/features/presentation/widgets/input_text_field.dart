import 'package:flutter/material.dart';

//

class InputTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const InputTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.validator,
  });

  @override
  InputTextFieldState createState() => InputTextFieldState();
}

class InputTextFieldState extends State<InputTextField> {
  bool _obscureText = true; // Track password visibility

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller, // Attach the controller
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: widget.isPassword
          ? _obscureText
          : false, // Toggle password visibility
      validator: widget.validator, // Attach the validator function
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        // filled: true,
        // fillColor: const Color(0xAAD3D3D3),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText; // Toggle visibility
                  });
                },
              )
            : null,
      ),
    );
  }
}
