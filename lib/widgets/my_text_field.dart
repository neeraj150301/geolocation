import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyTextField extends StatefulWidget {
  final String hintText;
  bool obscureText;
  final TextEditingController controller;

  MyTextField(
      {super.key,
      required this.hintText,
      required this.obscureText,
      required this.controller});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        obscureText: widget.obscureText,
        controller: widget.controller,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (widget.hintText == "Enter Email") {
            if (value == null || value.isEmpty) {
              return 'Email cannot be empty';
            }
            // Simple email validation
            String pattern =
                r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
            RegExp regex = RegExp(pattern);
            if (!regex.hasMatch(value)) {
              return 'Enter a valid email';
            }
          }
          if (widget.hintText.contains("Password")) {
            if (value == null || value.isEmpty) {
              return 'Password cannot be empty';
            }
            if (value.length < 6) {
              return 'Password lenght should not be less then 6';
            }
          }

          if (widget.hintText.contains("Enter Name")) {
            if (value == null || value.isEmpty) {
              return 'Name cannot be empty';
            }
          }

          if (widget.hintText != "Type message here...") {
            if (value == null || value.isEmpty) {
              return 'This field cannot be empty';
            }
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: (widget.hintText == "Enter Email")
              ? const Icon(Icons.email)
              : (widget.hintText.contains("Password"))
                  ? const Icon(Icons.password)
                  : (widget.hintText.contains("Enter Name"))
                      ? const Icon(Icons.person)
                      : null,
          prefixIconColor: Theme.of(context).colorScheme.primary,
          labelText: widget.hintText,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 20.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          suffixIcon: (widget.hintText.contains("Password"))
              ? Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          widget.obscureText = !widget.obscureText;
                        });
                      },
                      icon: widget.obscureText
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off)),
                )
              : null,
          suffixIconColor: Theme.of(context).colorScheme.primary,
          errorStyle: const TextStyle(
            color: Colors.red,
          ),
          filled: true,
        ),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
