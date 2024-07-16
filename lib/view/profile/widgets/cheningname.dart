import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:tigercashiraq/controler/home_controller.dart';
import 'package:tigercashiraq/controler/profile_get.dart';
import 'package:tigercashiraq/error/server_error.dart';

void cheningname(Profile controller) {
  final v = Get.put(HomeController());
  Get.dialog(
    AlertDialog(
      title: const Text('تغير اسم المستخدم'),
      content: Form(
        key: controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('سيتم قطع 3000 نقطة مقابل عملة تغير الاسم'),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: controller.nameController,
              decoration: const InputDecoration(
                hintText: 'ادخل اسم المستخدم',
              ),
              validator: (value) {
                if (value!.length < 3) {
                  return 'ادخل اسم المستخدم';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('الغاء'),
        ),
        TextButton(
          onPressed: () async {
            if (controller.formKey.currentState!.validate()) {
              try {
                SmartDialog.showLoading();
                await controller.setUserName();
                Get.back();
                SmartDialog.dismiss();
                v.user.value.name == controller.nameController.text.toString();

                Get.snackbar(
                  'تم تغير الاسم بنجاح',
                  'تم تغير الاسم بنجاح',
                  backgroundColor: Colors.green,
                );
              } catch (e) {
                if (e is ServerError) {
                  Get.snackbar(
                    'خطأ',
                    jsonDecode(e.response.body)["message"].toString(),
                    backgroundColor: Colors.red,
                  );
                } else {
                  Get.snackbar(
                    'خطأ',
                    "حدث خطا ما",
                    backgroundColor: Colors.red,
                  );
                }

                SmartDialog.dismiss();
              }
            }
            // Get.to(() => const ProfilePage());
          },
          child: const Text('تاكيد'),
        ),
      ],
    ),
  );
}
