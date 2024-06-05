import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:ggggg/controler/apidata.dart';
import 'package:ggggg/controler/login_getx.dart';
import 'package:ggggg/view/widget/my_button.dart';
import 'package:ggggg/view/widget/my_text.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/logo.png',
                      // height: 50
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyText(
                    titel: 'Tiger Cash Iraq',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  MyText(
                    titel: 'سجل الدخول الى التطبيق عن طريق الخيارات الاتية',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GetBuilder<LoginGetx>(
              init: LoginGetx(),
              initState: (_) {},
              builder: (value) {
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: MyButton(
                        label: MyText(
                          titel: "تسجيل الدخول بواسطة google",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        onPressed: () async {
                          if (await requestPhoneStatePermission()) {
                            try {
                              SmartDialog.showLoading();
                              await value.signInWithGoogle(null);
                              SmartDialog.dismiss();
                            } catch (e) {
                              SmartDialog.dismiss();
                            }
                          } else {
                            Get.snackbar('حدث خطا',
                                "الرجاء الموافقة على الصلاحيات اللازمة",
                                backgroundColor: Colors.red);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
