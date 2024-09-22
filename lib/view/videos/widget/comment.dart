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
          child: GetBuilder<VideoController1>(builder: (c) {
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
                              snapshot.data![index].photoUrl.toString()),
                        ),
                        title: Text(snapshot.data![index].name.toString()),
                        subtitle:
                            Text(snapshot.data![index].content.toString()),
                        onTap: () {
                          if (snapshot.data![index].idu.toString() !=
                              homeController.user.value.id.toString()) {
                            SmartDialog.show(
                                alignment: Alignment.center,
                                builder: (cons) {
                                  return GifiWidget(
                                    userId: controller.comments[index].idu
                                        .toString(),
                                    reel_id: c.videoInfo[index].id.toString(),
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
        
      ],
    ),
  );
}
