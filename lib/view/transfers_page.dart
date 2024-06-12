import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../controler/treansfers_controller.dart';
import '../utl/colors.dart';

class TransfersPage extends StatelessWidget {
  TransfersPage({super.key});

  final TreansfersController controller = Get.put(TreansfersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الحوالات'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/logo.png', height: 50),
            const SizedBox(height: 20),
            const Text(
              'حول النقاط الى اي حساب',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Obx(() => Text(
                  'نقاطك الاجمالية: ${controller.user.value.balance}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                )),
            const SizedBox(height: 20),
            TextFormField(
              controller: controller.userId.value,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'كود الاحالة',
              ),
              onChanged: (value) {
                controller.userId.value.text = value;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'مبلغ الإرسال',
              ),
              controller: controller.amount.value,
              onChanged: (value) {
                controller.amount.value.text = value;
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (controller.userId.value.text.isEmpty ||
                        controller.amount.value.text.isEmpty) {
                      Get.snackbar(
                        "خطأ",
                        "الرجاء إدخال كود الإحالة ومبلغ الإرسال",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }
                    // عرض حوار التأكيد
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("تأكيد الحوالة"),
                          content: Text(
                              "هل أنت متأكد من إرسال ${controller.amount.value.text} إلى ${controller.userId.value.text}?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("إلغاء"),
                            ),
                            TextButton(
                              onPressed: () async {
                                try {
                                  SmartDialog.showLoading();
                                  await controller.sendMoney();
                                  SmartDialog.dismiss();
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context)
                                      .pop(); // إغلاق حوار التأكيد
                                  Get.snackbar("تهانيئا", "تمت العملية بنجاح",
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white);
                                } catch (e) {
                                  SmartDialog.dismiss();
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context)
                                      .pop(); // إغلاق حوار التأكيد
                                  var x = jsonDecode(e.toString());
                                  Get.snackbar("خطأ", x["message"],
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white);
                                }
                              },
                              child: const Text("تأكيد"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Ccolors.primry,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: const Text(
                    'تحويل المبلغ',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
