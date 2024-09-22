import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../error/server_error.dart';
import '../model/user.dart' as u;
import '../view/home/root_page.dart';
import '../view/widget/my_button.dart';
import '../view/widget/my_text.dart';
import '../Api Server/apidata.dart';

class LoginGetx extends GetxController {
  TextEditingController codeController = TextEditingController();
  Future signInWithGoogle(var code) async {
    http.Response x;
    GetStorage box = GetStorage();
    try {
   
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
     
      print("**************");
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
          print("444444444444444444444444");
          print('33333333333333333333333333');
      print(googleAuth!.accessToken.toString());


final credential = GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken,idToken: googleAuth?.idToken);
await FirebaseAuth.instance.signInWithCredential(credential);
      if (kDebugMode) {
        print(googleAuth.accessToken.toString());
      }
      x = await ApiData.loginToMyApi(googleAuth!.accessToken.toString(), code);

      Get.snackbar('تم تسجيل الدخول بنجاح ', "code",
          backgroundColor: Colors.green);
      u.User user = u.User.fromJson(jsonDecode(x.body)["data"]);
      print("###################################");
      print(x.body);
      await box.write("token", jsonDecode(x.body)["api_token"].toString());
      Get.off(const RootPage());
      // Get.to(() => const RootPage());
    } catch (e) {
      print("111111111111111111111");
      print(e.toString());

      if (e is ServerError) {
        if (e.response.statusCode == 324) {
          Get.to(() => const CodeInvid());
        }
        if (e.response.statusCode == 422) {
          print('here here here');
          print(e.response.body);
          Get.snackbar('Error', jsonDecode(e.response.body)["message"]);
         _signOut();
         print('google logout');
        }
        
      } else {
        print("1111111111111111111111");
        print(e.toString());
        Get.snackbar('Error', "حدثت مشكلة في تسجيل الدخول");
        
      }
    }
  }
  Future<void> _signOut() async {
  try {
    await GoogleSignIn().signOut();
    // After successful sign-out, you can navigate to the login screen or show a sign-out message
    print("User signed out");
  } catch (error) {
    print("Error signing out: $error");
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
              CircleAvatar(
  backgroundImage: AssetImage('assets/icons/logo.jpg'),
  radius: 80, // Adjust the radius as needed
),
              const SizedBox(
                height: 30,
              ),
              Container(child:FittedBox(child:Text(" ادخل رمز الدعوة لكي يتم انشاء الحساب"))),
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
                    icon: Icon(Icons.check_circle),

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
