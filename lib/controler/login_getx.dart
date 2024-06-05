import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ggggg/controler/apidata.dart';
import 'package:ggggg/error/server_error.dart';
import 'package:ggggg/model/user.dart';
import 'package:ggggg/view/root_page.dart';
import 'package:ggggg/view/widget/my_button.dart';
import 'package:ggggg/view/widget/my_text.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class LoginGetx extends GetxController {
  TextEditingController codeController = TextEditingController();
  Future signInWithGoogle(var code) async {
    http.Response x;
    GetStorage box = GetStorage();
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      x = await ApiData.loginToMyApi(googleAuth!.accessToken.toString(), code);
      Get.snackbar('تم تسجيل الدخول بنجاح ', "code",
          backgroundColor: Colors.green);
      User user = User.fromJson(jsonDecode(x.body)["data"]);
      await box.write("token", user.apiToken);
      Get.off(const RootPage());
      // Get.to(() => const RootPage());
    } catch (e) {
      if (e is ServerError) {
        if (e.response.statusCode == 324) {
          Get.to(() => const CodeInvid());
        }
        if (e.response.statusCode == 422) {
          Get.snackbar('Error', jsonDecode(e.response.body)["message"]);
        }
      } else {
        Get.snackbar('Error', "حدثت مشكلة في تسجيل الدخول");
      }
    }
  }
}

class CodeInvid extends StatelessWidget {
  const CodeInvid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التحقق من رمز الدعوة'),
        centerTitle: true,
      ),
      body: GetBuilder<LoginGetx>(
        init: LoginGetx(),
        initState: (_) {},
        builder: (value) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Image.asset("assets/logo.png"),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  MyText(
                    titel: "يرجى ادخل رمز الدعوة لكي يتم انشاء الحساب",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: value.codeController,
                    decoration: InputDecoration(
                      labelText: 'رمز الدعوة',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  MyButton(
                    label: MyText(
                      titel: "تحقق",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    // icon:  Icon(Icons.alfa),
                    onPressed: () async {
                      // if (await requestPhoneStatePermission()) {
                      try {
                        SmartDialog.showLoading();
                        await value.signInWithGoogle(value.codeController.text);
                        SmartDialog.dismiss();
                        // ignore: use_build_context_synchronously
                        // Navigator.pop(context);
                        // Get.off(const LoginPage());
                      } catch (e) {
                        Get.snackbar('Error', e.toString());
                        SmartDialog.dismiss();
                      }
                      // }
                    },
                  ),
                ],
              )
            ]),
          );
        },
      ),
    );
  }
}
