import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  const MyText({
    super.key,
    this.style,
    required this.titel,
  });
  final TextStyle? style;
  final String titel;

  @override
  Widget build(BuildContext context) {
    return Text(
      titel,
      style: style,
      // textAlign: TextAlign.end,
    );
  }
}
