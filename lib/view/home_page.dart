import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:gradient_circular_progress_indicator/gradient_circular_progress_indicator.dart';
import 'package:tigercashiraq/view/hestory_page.dart';
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
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              child: Obx(() => Center(
                    child: GradientCircularProgressIndicator(
                      size: MediaQuery.of(context).size.width / 2,
                      progress: 1 - (controller.time.value / 86400),
                      gradient: const LinearGradient(
                        colors: [Ccolors.secndry, Ccolors.primry],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      backgroundColor: Colors.grey.shade200,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyText(
                              titel: "النقاط",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            MyText(
                              titel: controller.user.value.counterAmount ?? "0",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            MyText(
                                titel:
                                    "يتوقف في : ${controller.time.value ~/ 3600}:${(controller.time.value ~/ 60) % 60}:${controller.time.value % 60}",
                                style: Theme.of(context).textTheme.titleSmall),
                          ],
                        ),
                      ),
                    ),
                  )),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Column(
                children: [
                  GetBuilder<SheckTime>(
                      init: SheckTime(),
                      builder: (vvv) {
                        vvv.setboot(controller.time.value);
                        return ElevatedButton(
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
                                      Get.snackbar("خطا", "حدث خطا غير متوقع",
                                          overlayColor: Colors.red);
                                    }
                                  }
                                : null,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              child: Text(
                                vvv.x ? "سحب النقاط" : "تم التفعيل",
                                style: TextStyle(
                                    color: vvv.x ? Colors.white : null),
                              ),
                            ));
                      }),
                  SizedBox(
                    child: MyButton(
                        label: const Text("مضاعفة العداد"),
                        icon: const Icon(Icons.assured_workload),
                        onPressed: () {
                          Get.to(() => CauntrsPage());
                        }),
                  ),
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
                            return const Center(
                                child: Text("لايوجد اخبار الان"));
                          }
                          return CarouselSlider(
                            options: CarouselOptions(
                                height: 200,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                aspectRatio: 16 / 9,
                                pauseAutoPlayOnTouch: true,
                                viewportFraction: 1),
                            items: snapshot.data!.map((url) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width + 50,
                                    height: 70,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    decoration: const BoxDecoration(
                                        // color: Colors.amber,
                                        ),
                                    child: Image.network(
                                      url,
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          );
                        }
                        return const SizedBox(
                            width: double.maxFinite,
                            height: 200,
                            child: Center(child: CircularProgressIndicator()));
                      });
                },
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Obx(() => Container(
                      color: Colors.black87,
                      child: AutoScrollText(
                        newsText(context, controller.news.value),
                        textDirection: TextDirection.rtl,
                        style:
                            const TextStyle(fontSize: 22, color: Colors.white),
                      ),
                    )),
              ],
            ),
            const SizedBox(
              height: 50,
            )
          ]),
        ),
      ),
    );
  }

  String newsText(BuildContext context, String text) {
    int x = ((MediaQuery.of(context).size.width - getTextWidth(text, 22)) /
            getTextWidth(" ", 22))
        .toInt();
    return text + " " * x + (x <= 0 ? " " * 10 : " ").toString();
  }

  AppBar myAppBar(BuildContext context, String title) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Container(
        decoration: BoxDecoration(
          color: Ccolors.secndry,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 13,
                    backgroundColor: Colors.white,
                    child: Text(
                      "TCI",
                      style: TextStyle(color: Ccolors.primry, fontSize: 10),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Obx(() => Text(
                      controller.user.value.balance == null
                          ? "0"
                          : controller.user.value.balance.toString(),
                      style:
                          const TextStyle(color: Colors.black, fontSize: 13)))
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              decoration: BoxDecoration(
                color: Ccolors.primry,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => Text(
                      (int.parse(controller.user.value.balance == null
                                  ? "0"
                                  : controller.user.value.balance.toString()) /
                              double.parse(controller.dvsdr.toString()))
                          .toString(),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 13))),
                  // Icon(Icons.dolr),
                  const SizedBox(
                    width: 5,
                  ),
                  const CircleAvatar(
                    radius: 13,
                    backgroundColor: Colors.white,
                    child: Text("\$",
                        style: TextStyle(color: Ccolors.primry, fontSize: 13)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton.outlined(
            onPressed: () {
              Get.to(() => HestoryPage(
                    user: controller.user.value,
                  ));
            },
            icon: const Icon(Icons.notifications)),
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
