// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomFormfield extends StatefulWidget {
  CustomFormfield(
      {super.key,
      required this.controller,
      this.hintText,
      this.label,
      this.obscureText = false,
      this.isPassword = false,
      this.length = 25});
  final TextEditingController? controller;
  final String? hintText;
  final String? label;
  bool obscureText;
  bool isPassword;
  int length;

  @override
  State<CustomFormfield> createState() => _CustomFormfieldState();
}

class _CustomFormfieldState extends State<CustomFormfield> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        validator: (value) {
          if (value == null ||
              value.isEmpty ||
              (widget.obscureText && value.length < 6)) {
            return "Enter a valid ${widget.label!.toLowerCase()}";
          }
          return null;
        },
        controller: widget.controller,
        obscureText: widget.obscureText,
        // keyboardType: TextInputType.number,
        maxLength: widget.length,
        decoration: InputDecoration(
            counterText: '',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
            hintText: widget.hintText,
            labelText: widget.label,
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: const Icon(
                      Icons.remove_red_eye_sharp,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.obscureText = !widget.obscureText;
                      });
                    },
                  )
                : const SizedBox()),
      ),
    );
  }
}
