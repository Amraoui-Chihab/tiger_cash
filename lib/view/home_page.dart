import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:tigercashiraq/view/profile_page.dart';

import '../controler/home_controller.dart';
import '../utl/colors.dart';
import 'agents_page.dart';
import 'cauntrs_page.dart';
import 'widget/my_button.dart';
import 'widget/my_text.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({
    super.key,
  });

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, "تايكر كاش العراق"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                            titel: "عداد النقاط",
                            style: Theme.of(context).textTheme.titleLarge),
                        MyText(
                            titel: "تجد هنا عداد النقاط ومستواه",
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  MyButton(
                      label: const Text("مضاعفة العداد"),
                      icon: const Icon(Icons.assured_workload),
                      onPressed: () {
                        // controller.getuserInfo();
                        Get.to(() => CauntrsPage());
                      }),
                ],
              )),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Obx(() => Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                  titel:
                                      "يتوقف في : ${controller.time.value ~/ 3600}:${(controller.time.value ~/ 60) % 60}:${controller.time.value % 60}",
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                            ],
                          ),
                        ),
                        MyText(
                          titel: controller.user.value.counterAmount ?? "0",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    )),
                GetBuilder<SheckTime>(
                    init: SheckTime(),
                    builder: (vvv) {
                      vvv.setboot(controller.time.value);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          vvv.x
                              ? const SizedBox()
                              : Expanded(
                                  flex: 2,
                                  child: MyText(
                                    titel:
                                        "يمكنك السحب بعد انتهاء الوقت وانتهاء العداد",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                          Expanded(
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                        vvv.x ? Ccolors.primry : null)),
                                onPressed: vvv.x
                                    ? () async {
                                        try {
                                          SmartDialog.showLoading();
                                          await controller.active();
                                          SmartDialog.dismiss();
                                          Get.snackbar(
                                              "تهانيئا", "تم التفعيل بنجاح",
                                              overlayColor: Colors.green);
                                          vvv.x = false;
                                          vvv.update();
                                        } catch (e) {
                                          SmartDialog.dismiss();
                                          Get.snackbar(
                                              "خطا", "حدث خطا غير متوقع",
                                              overlayColor: Colors.red);
                                        }
                                      }
                                    : null,
                                child: Text(
                                  "سحب النقاط",
                                  style: TextStyle(
                                      color: vvv.x ? Colors.white : null),
                                )),
                          ),
                        ],
                      );
                    })
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: MyText(
              titel: "اخر الاخبار",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(
            height: 300,
            child: GetBuilder<HomeController>(
              init: HomeController(),
              initState: (_) {},
              builder: (_) {
                return FutureBuilder(
                    future: _.getImigeFromeApi(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text("حصل خطا في تحميل الاخبار"));
                      }
                      if (snapshot.hasData) {
                        if (snapshot.data!.isEmpty) {
                          return const Center(child: Text("لايوجد اخبار الان"));
                        }
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  width: MediaQuery.of(context).size.width - 50,
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data![index],
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
                                      child: SizedBox(
                                        width: 70,
                                        height: 70,
                                        child: CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              );
                            });
                      }
                      return const Center(child: CircularProgressIndicator());
                    });
              },
            ),
          )
        ]),
      ),
    );
  }

  AppBar myAppBar(BuildContext context, String title) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(title),
      centerTitle: true,
      leading: IconButton.outlined(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => ProfilePage(
                  user: controller.user.value,
                ),
              ),
            );
          },
          icon: const Icon(Icons.person)),
      actions: [
        IconButton.outlined(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const AgentsPage(),
                ),
              );
            },
            icon: const Icon(Icons.support_agent)),
      ],
    );
  }
}
