import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tigercashiraq/controler/home_controller.dart';
import 'package:tigercashiraq/view/profile/widgets/cheningname.dart';
import 'package:tigercashiraq/view/profile/widgets/cheningphoto.dart';
import '../../../controler/profile_get.dart';
import '../../../model/user.dart';
import '../../../utl/colors.dart';
import 'time_viow.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final v = Get.put(HomeController());
  final controller = Get.put(Profile());

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1));
    User user = v.user.value;
    controller.getdata();
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
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height:
                                  MediaQuery.of(context).size.height * 36 / 100,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue.shade300,
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(40),
                                            bottomLeft: Radius.circular(40))),
                                    height: MediaQuery.of(context).size.height *
                                        25 /
                                        100,
                                  ),
                                  Positioned(
                                    top: MediaQuery.of(context).size.height / 5,
                                    child: Stack(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8.0),
                                          // Adjust the padding as needed
                                          decoration: BoxDecoration(
                                            border: Border(),
                                            shape: BoxShape.circle,
                                            color: Colors
                                                .white, // Background color for the padding
                                          ),
                                          child: CircleAvatar(
                                            radius:
                                                50, // Adjust the radius as needed
                                            backgroundImage: NetworkImage(
                                              controller.user.photoUrl!,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          child: IconButton.filled(
                                              iconSize: 20,
                                              onPressed: () =>
                                                  cheningphoto(controller),
                                              icon: const Icon(Icons.edit)),
                                          top: 70,
                                        )
                                      ],
                                    ),
                                    right:
                                        MediaQuery.of(context).size.width / 3,
                                  )
                                ],
                              ),
                            ),
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
                                        voieed.user.name!,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      InkWell(
                                        onTap: () => cheningname(controller),
                                        child: CircleAvatar(
                                          radius: 20,
                                          child: IconButton.filled(
                                              iconSize: 20,
                                              onPressed: () =>
                                                  cheningname(controller),
                                              icon: const Icon(Icons.edit)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal:
                                      MediaQuery.of(context).size.width *
                                          1 /
                                          3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.blue.shade300,
                              ),
                              width: MediaQuery.of(context).size.width ,
                              child: FittedBox(child:Text(
                                    '${voieed.user.balance.toString()} نقطة',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ))),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    Colors.blueAccent, // Set the border color
                                width: 2.0, // Set the border width
                              ),
                              borderRadius: BorderRadius.circular(
                                  15.0), // Optional: Set border radius for rounded corners
                            ),
                            child: ListTile(
                              // titleAlignment: ListTileTitleAlignment.titleHeight,
                              leading: Image.asset(
                                "assets/share.png",
                                height: 35,
                              ),
                              title: const Text('كود الاحالة'),
                              subtitle: Text(voieed.user.id.toString()),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.copy,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () async {
                                  // print(user.apiToken);
                                  FlutterClipboard.copy(user.id.toString())
                                      .then((value) =>
                                          Get.snackbar("تم النسخ", ""));
                                },
                              ),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    Colors.blueAccent, // Set the border color
                                width: 2.0, // Set the border width
                              ),
                              borderRadius: BorderRadius.circular(
                                  15.0), // Optional: Set border radius for rounded corners
                            ),
                            child: ListTile(
                              style: ListTileStyle.list,
                              // titleAlignment: ListTileTitleAlignment.titleHeight,
                              leading: Image.asset(
                                "assets/invitation.png",
                                height: 35,
                              ),
                              title: const Text('كود الدعوة'),
                              subtitle: Text(voieed.user.codeInvite.toString()),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.copy,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () async {
                                  // print(user.apiToken);
                                  FlutterClipboard.copy(
                                          voieed.user.codeInvite.toString())
                                      .then((value) =>
                                          Get.snackbar("تم النسخ", ""));
                                },
                              ),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    Colors.blueAccent, // Set the border color
                                width: 2.0, // Set the border width
                              ),
                              borderRadius: BorderRadius.circular(
                                  15.0), // Optional: Set border radius for rounded corners
                            ),
                            child: ListTile(
                              leading: Image.asset(
                                "assets/team.png",
                                height: 35,
                              ),
                              title: const Text('فريقي'),
                              trailing: const Icon(
                                Icons.arrow_forward_sharp,
                                color: Colors.blue,
                              ),
                              subtitle: const Text(
                                  "الاعضاء المنضمين عن طريق كود الدعوة الخاص بك"),
                              onTap: () {
                                Get.to(const TimeViow());
                              },
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    Colors.blueAccent, // Set the border color
                                width: 2.0, // Set the border width
                              ),
                              borderRadius: BorderRadius.circular(
                                  15.0), // Optional: Set border radius for rounded corners
                            ),
                            child: ListTile(
                              leading: Image.asset(
                                "assets/logout.png",
                                height: 35,
                              ),
                              title: Text('تسجيل الدخول'),
                              subtitle: Text('جوجل'),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                          )

                          // ListTile(
                          //   leading: const Icon(Icons.group),
                          //   title: const Text('فديوهاتي'),
                          //   trailing: const Icon(Icons.arrow_forward_sharp),
                          //   subtitle: const Text(""),
                          //   onTap: () {
                          //     Get.to(() => MyVideo());
                          //   },
                          // ),
                          ,
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
