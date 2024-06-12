import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controler/profile_get.dart';
import '../../model/user.dart';
import '../../utl/colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.user});
  final User user;

  // final GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    // User user = User.fromJson(jsonDecode(box.read("user")));
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        // centerTitle: true,
      ),
      body: GetBuilder<Profile>(
          init: Profile(),
          builder: (voieed) {
            return FutureBuilder(
                future: null,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'الملف الشخصي',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          'تجد هنا جميع معلوماتك',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
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
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
                              FlutterClipboard.copy(user.codeInvite.toString())
                                  .then(
                                      (value) => Get.snackbar("تم النسخ", ""));
                            },
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.account_circle),
                          title: const Text('الاسم'),
                          subtitle: Text(user.name.toString()),
                        ),
                        const ListTile(
                          leading: Icon(Icons.login),
                          title: Text('تسجيل الدخول'),
                          subtitle: Text('جوجل'),
                        ),
                        // Container(
                        //   width: double.maxFinite,
                        //   height: 1,
                        //   color: Ccolors.gay,
                        //   margin: const EdgeInsets.symmetric(vertical: 10),
                        // ),
                        // TextButton.icon(
                        //   onPressed: () {

                        //   },
                        //   style: ElevatedButton.styleFrom(foregroundColor: Colors.red),
                        //   icon: const Icon(Icons.logout),
                        //   label: const Text(
                        //     'تسجيل الخروج',
                        //     style: TextStyle(fontSize: 18),
                        //   ),
                        // ),
                      ],
                    ),
                  );
                });
          }),
    );
  }
}
