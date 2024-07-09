import 'dart:convert';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tigercashiraq/controler/home_controller.dart';
import 'package:tigercashiraq/error/server_error.dart';
import '../../controler/profile_get.dart';
import '../../model/user.dart';
import '../../utl/colors.dart';
import 'time_viow.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final v = Get.put(HomeController());
  final controller = Get.put(Profile());

  @override
  Widget build(BuildContext context) {
    User user = v.user.value;
    return Scaffold(
      body: GetBuilder<Profile>(
          init: Profile(),
          builder: (voieed) {
            return FutureBuilder(
                future: null,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const SizedBox(height: 20),
                          // const Text(
                          //   'الملف الشخصي',
                          //   style: TextStyle(
                          //       fontSize: 24, fontWeight: FontWeight.bold),
                          //   textAlign: TextAlign.center,
                          // ),
                          // const Text(
                          //   'تجد هنا جميع معلوماتك',
                          //   style: TextStyle(fontSize: 16, color: Colors.grey),
                          //   textAlign: TextAlign.center,
                          // ),
                          Stack(
                            children: [
                              Image.network(
                                user.photoUrl!,
                                height: MediaQuery.of(context).size.height / 4,
                                width: double.maxFinite,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                  top: 5,
                                  left: 5,
                                  child: SafeArea(
                                    child: IconButton.filled(
                                        onPressed: () =>
                                            cheningphoto(controller),
                                        icon: const Icon(Icons.edit)),
                                  ))
                            ],
                          ),
                          SizedBox(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        user.name!,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      InkWell(
                                        onTap: () => cheningname(controller),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            // color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              border: Border.all(color: Ccolors.gay),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Image.asset('assets/logo.png',
                                    height:
                                        50), // Assumes you have an image asset
                                const SizedBox(height: 10),
                                const Text(
                                  'إجمالي النقاط',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '${user.balance.toString()} نقطة',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          ListTile(
                            style: ListTileStyle.list,
                            // titleAlignment: ListTileTitleAlignment.titleHeight,
                            leading: const Icon(Icons.person),
                            title: const Text('كود الاحالة'),
                            subtitle: Text(user.id.toString()),
                            trailing: IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () async {
                                // print(user.apiToken);
                                FlutterClipboard.copy(user.id.toString()).then(
                                    (value) => Get.snackbar("تم النسخ", ""));
                              },
                            ),
                          ),
                          ListTile(
                            style: ListTileStyle.list,
                            // titleAlignment: ListTileTitleAlignment.titleHeight,
                            leading: const Icon(Icons.share),
                            title: const Text('كود الدعوة'),
                            subtitle: Text(user.codeInvite.toString()),
                            trailing: IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () async {
                                // print(user.apiToken);
                                FlutterClipboard.copy(
                                        user.codeInvite.toString())
                                    .then((value) =>
                                        Get.snackbar("تم النسخ", ""));
                              },
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.group),
                            title: const Text('فريقي'),
                            trailing: const Icon(Icons.arrow_forward_sharp),
                            subtitle: const Text(
                                "الاعضاء المنضمين عن طريق كود الدعوة الخاص بك"),
                            onTap: () {
                              Get.to(const TimeViow());
                            },
                          ),

                          const ListTile(
                            leading: Icon(Icons.login),
                            title: Text('تسجيل الدخول'),
                            subtitle: Text('جوجل'),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}

void cheningname(Profile controller) {
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
                // var user=Get.find()

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
