import 'package:flutter/material.dart';

class EcoTextField extends StatefulWidget {
  String? hintText;
  TextEditingController? controller;
  String? Function(String?)? validate;
  bool isPassword;
  Widget? icon;
  bool check;
  final TextInputAction? inputAction;
  final FocusNode? focusNode;
  EcoTextField(
      {super.key,
      this.hintText,
      this.controller,
      this.validate,
      this.isPassword = false,
      this.icon,
      this.check = false,
      this.inputAction,
      this.focusNode});

  @override
  State<EcoTextField> createState() => _EcoTextFieldState();
}

class _EcoTextFieldState extends State<EcoTextField> {
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        focusNode: widget.focusNode,
        textInputAction: widget.inputAction,
        obscureText: widget.isPassword == false ? false : widget.isPassword,
        validator: widget.validate,
        controller: widget.controller,
        decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: widget.icon,
            hintText: widget.hintText ?? 'hint Text....',
            contentPadding: const EdgeInsets.all(10)),
      ),
    );
  }
}
