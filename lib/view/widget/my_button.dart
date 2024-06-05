import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  MyButton(
      {super.key, required this.label, this.icon, required this.onPressed});
  final Widget label;
  final Icon? icon;
  // ignore: prefer_typing_uninitialized_variables
  var onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: ButtonStyle(
          padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(100),
            ),
          )),
      onPressed: onPressed,
      label: label,
      icon: icon,
    );
  }
}
