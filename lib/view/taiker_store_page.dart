import 'package:flutter/material.dart';

class TaikerStorePage extends StatelessWidget {
  const TaikerStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: //myAppBar(context, "تايكر ستور"),
            const Text('تايكر ستور'),
        centerTitle: true,
        // actions: [
        //   // IconButton(
        //   //   icon: const Icon(Icons.account_circle),
        //   //   onPressed: () {},
        //   // ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/logo.png',
                height: 100), // تأكد من وجود الصورة في مجلد assets
            const SizedBox(height: 20),
            const Text(
              'تايكر ستور',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'سيتم إضافة هذا الستور قريبا، ترقبوا الإضافة!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
