import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:tigercashiraq/controler/home_controller.dart';
import 'package:tigercashiraq/controler/video_controller1.dart';
import 'package:tigercashiraq/view/videos/widget/gifi_widget.dart';

Container commentSection(
    BuildContext context, VideoController1 controller, int index) {
  // final HomeController homeController = Get.put(HomeController());
  final HomeController homeController = Get.find();
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height / 2,
    color: Colors.white,
    child: Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                controller.isComment.value = false;
                // controller.update();
              },
              icon: const Icon(Icons.close),
            ),
            const Expanded(
              child: Text(
                "التعليقات",
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        Expanded(
          child: GetBuilder<VideoController1>(builder: (context) {
            return FutureBuilder(
              future: controller
                  .getComment(controller.videoInfo[index].id.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                              snapshot.data![index].user.photoUrl.toString()),
                        ),
                        title: Text(snapshot.data![index].user.name.toString()),
                        subtitle:
                            Text(snapshot.data![index].content.toString()),
                        onTap: () {
                          if (snapshot.data![index].user.id.toString() !=
                              homeController.user.value.id.toString()) {
                            SmartDialog.show(
                                alignment: Alignment.center,
                                builder: (cons) {
                                  return GifiWidget(
                                    userId: controller.comments[index].user.id
                                        .toString(),
                                  );
                                });
                          }
                        });
                  },
                );
              },
            );
          }),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.contentText.value,
                decoration: const InputDecoration(
                  hintText: 'اكتب تعليقك...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                try {
                  await controller.addComment(
                      controller.videoInfo[index].id.toString(),
                      controller.contentText.value.text.toString());
                  controller.contentText.value.clear();
                  Get.back();
                  // controller.videoInfo[index].comment++;
                  controller.update();
                } catch (e) {
                  Get.snackbar("خطأ", e.toString());
                }
              },
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ],
    ),
  );
}
