import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tigercashiraq/controler/profile_get.dart';
import 'package:tigercashiraq/error/server_error.dart';

void cheningphoto(Profile controller) {
  // File? image;

  Get.dialog(
    AlertDialog(
      title: const Text('تغير الصورة'),
      content: const Text('سيتم قطع 5000 نقطة مقابل عملة تغير الصورة الشخصية'),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('الغاء'),
        ),
        TextButton(
          onPressed: () async {
            final ImagePicker picker = ImagePicker();
            final pickedFile =
                await picker.pickImage(source: ImageSource.gallery);
            SmartDialog.showLoading();
            if (pickedFile != null) {
              // image = File(pickedFile.path);
              try {
                await controller.addPhotoFromGallery(pickedFile);
                Get.back();
                Get.snackbar(
                  'تم تغير الصورة بنجاح',
                  'تم تغير الصورة بنجاح',
                  backgroundColor: Colors.green,
                );
              } catch (e) {
                if (e is ServerError) {}
                Get.snackbar(
                  'خطأ',
                  e.toString(),
                  backgroundColor: Colors.red,
                );
                throw Exception("حدث خطا ما");
              } finally {
                SmartDialog.dismiss();
              }
            }
          },
          child: const Text('تاكيد'),
        ),
      ],
    ),
  );
}
