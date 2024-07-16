// add block page
import 'dart:async';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BlockPage extends StatefulWidget {
  BlockPage({super.key, required this.time});
  int time;

  @override
  State<BlockPage> createState() => _BlockPageState();
}

class _BlockPageState extends State<BlockPage> {
  @override
  void initState() {
    super.initState();
    timeon();
  }

  timeon() {
    Timer.periodic(const Duration(seconds: 1), (e) {
      if (widget.time > 0) {
        setState(() {
          widget.time = widget.time - 1;
        });
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/logo.png',
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("انت محظور من الاستخدام "),
            const Text("سسبب مخالفتك لسياسة التطبيق"),
            Text(
                "انتهاء الحظر بعد : ${widget.time ~/ 3600}:${(widget.time ~/ 60) % 60}:${widget.time % 60}"),
          ],
        ),
      ),
    );
  }
}
