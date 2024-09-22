import 'package:flutter/material.dart';

// ignore: must_be_immutable, camel_case_types
class CardPositioned extends StatelessWidget {
  CardPositioned(
      {super.key,
      required this.bottom,
      required this.icon,
      required this.onPressed,
      required this.title});
  double bottom;
  Icon icon;
  // final Function onPressed;
  String title;

  // ignore: prefer_typing_uninitialized_variables
  var onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      left: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
              style: const ButtonStyle(
                  shadowColor: MaterialStatePropertyAll(Colors.green)),
              onPressed: onPressed,
              child: Column(
                children: [
                  icon,
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
