import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:tigercashiraq/controler/home_controller.dart';
import '../../../controler/gift_controller.dart';

class GifiWidget extends StatelessWidget {
  GifiWidget({
    super.key,
    required this.userId,
    required this.reel_id,
  });

  final String userId;
  final String reel_id;

  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      height: MediaQuery.of(context).size.height / 4,
      width: double.maxFinite,
      padding: const EdgeInsets.only(bottom: 10),
      margin: const EdgeInsets.all(5),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      SmartDialog.dismiss();
                    },
                    icon: const Icon(Icons.close)),
                Text(
                  "الهدايا",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "عبر عن دعمك وارسل الهدايا",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: GetBuilder<GiftController>(
                    init: GiftController(),
                    builder: (controller) {
                      return FutureBuilder(
                          future: controller.getgift(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Center(
                                  child: Text(" حصل خطا اثناء تحميل الهدايا"));
                            } else if (snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text("لا يوجد هدايا لعرضها"));
                            }

                            return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 90,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: FittedBox(
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                          Container(
                                              child: FittedBox(
                                                  child: GestureDetector(
                                            onTapDown: (details) async {
                                              await controller.sendgift(
                                                  snapshot.data![index].id
                                                      .toString(),
                                                  userId,
                                                  reel_id);
                                              homeController.user.value
                                                  .balance = (int.parse(
                                                          homeController.user
                                                              .value.balance
                                                              .toString()) -
                                                      (snapshot
                                                          .data![index].cost))
                                                  .toString();
                                            },
                                            child: Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                // color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                    image: NetworkImage(snapshot
                                                        .data![index].photoUrl
                                                        .toString()),
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                          ))),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(snapshot.data![index].name
                                              .toString()),
                                          Text(snapshot.data![index].cost
                                                  .toString() +
                                              " نقطة"),
                                          // TextButton.icon(
                                          //   onPressed: () async {

                                          //   },
                                          //   label:
                                          // ),
                                        ])),
                                  );
                                });
                          });
                    }))
          ]),
    );
  }
}
