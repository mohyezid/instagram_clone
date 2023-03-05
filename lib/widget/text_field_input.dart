import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEdit;
  final bool ispass;
  final String hintxt;
  final TextInputType type;
  const TextFieldInput(
      {super.key,
      required this.hintxt,
      this.ispass = false,
      required this.textEdit,
      required this.type});

  @override
  Widget build(BuildContext context) {
    final inputborder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: textEdit,
      decoration: InputDecoration(
          hintText: hintxt,
          border: inputborder,
          focusedBorder: inputborder,
          enabledBorder: inputborder,
          filled: true,
          contentPadding: EdgeInsets.all(8)),
      keyboardType: type,
      obscureText: ispass,
    );
  }
}
